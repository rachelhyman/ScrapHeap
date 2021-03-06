//
//  SCRMapViewController.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/29/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRMapViewController.h"

#import "VOKCoreDataManager.h"
#import "Mapbox.h"
#import "SCRCoreDataUtility.h"
#import "SCRBuilding.h"
#import "SCRViolation.h"
#import "SCRAnnotation.h"
#import "SCRAnnotationDetailViewController.h"
#import "SCRSettingsViewController.h"
#import "SCRSettingsUtility.h"
#import "SCRNetworking.h"

static NSString *const MapboxID = @"rachelvokal.kg9n243b";
static NSString *const DatabasePathUserDefaultsKey = @"tileDatabaseCachePath";
//City of Chicago dumps a bunch of HTML into the description string for each community area.
//These 2 constants are to filter the name of the community area out from the description string.
static NSString *const DescriptionStringBeginning = @"<span class=\"atr-name\">COMMUNITY</span>:</strong> <span class=\"atr-value\">";
static NSString *const DescriptionStringEnding = @"<";
static NSTimeInterval const TileExpiryPeriod = (60*60*24*7*52*10); //arbitrary expiry period of 10 years for tile cache
static CLLocationCoordinate2D const MapCenterCoord = {.latitude = 41.786313, .longitude = -87.615623};

@interface SCRMapViewController () <RMMapViewDelegate, RMTileCacheBackgroundDelegate, SCRSettingsDelegate>

@property (weak, nonatomic) RMMapView *mapView;
@property (weak, nonatomic) UIActivityIndicatorView *progressSpinner;
@property (strong, nonatomic) NSMutableArray *violationCountsArray;
@property (strong, nonatomic) NSMutableArray *communityAreaAnnotationsArray;
@property (strong, nonatomic) NSArray *allBuildingAnnotationsArray;
//5 violations that we will color differently on the map
@property (strong, nonatomic) NSArray *specialViolationsArray;

@end

@implementation SCRMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self doSetup];
}

- (void)dealloc
{
    self.mapView.delegate = nil;
}

- (void)doSetup
{
    [self initializeArrays];
    [self setUpMap];
    [self addGestureRecognizer];
    [self addAnimatingProgressSpinner];
    if ([SCRSettingsUtility sharedUtility].numberOfViolationsToDisplay && [SCRSettingsUtility sharedUtility].dateToDisplayViolationsOnOrAfter) {
        [SCRNetworking getViolationsWithinUpperLeft:UpperLeft23rdAndHalstedCoord
                                         lowerRight:LowerRight95thAndLakeCoord
                                 numberOfViolations:[SCRSettingsUtility sharedUtility].numberOfViolationsToDisplay
                                      onOrAfterDate:[SCRSettingsUtility sharedUtility].dateToDisplayViolationsOnOrAfter
                                  completionHandler:^(NSArray *buildingsArray) {
                                      [self completionHandlerForReloadingMapWithBuildingsArray:buildingsArray];
                                  }];
    } else {
        [SCRNetworking getViolationsWithinUpperLeft:UpperLeft23rdAndHalstedCoord
                                         lowerRight:LowerRight95thAndLakeCoord
                                 numberOfViolations:[SCRNetworking defaultViolationsToFetch]
                                  completionHandler:^(NSArray *buildingsArray) {
                                      [self completionHandlerForReloadingMapWithBuildingsArray:buildingsArray];
                                  }
         ];
    }
}

- (void)initializeArrays
{
    self.violationCountsArray = [NSMutableArray array];
    self.communityAreaAnnotationsArray = [NSMutableArray array];
    self.allBuildingAnnotationsArray = [NSArray array];
    self.specialViolationsArray = @[@"13-12-130",
                                    @"13-12-131",
                                    @"13-12-135",
                                    @"13-12-140",
                                    @"13-12-145"];
}

- (void)addGestureRecognizer
{
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(filterAnnotationsFromGestureRecognizer:)];
    gestureRecognizer.minimumPressDuration = 1.5;
    NSMutableArray *gestureRecognizerArray = [self.mapView.gestureRecognizers mutableCopy];
    //The long press gesture recognizer we want to implement conflicts with one of the map view's existing UILongPressGestureRecognizers
    //We remove the conflicting one that already exists, add in our own, then set the array of gesture recognizers on the map
    NSUInteger index = [gestureRecognizerArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isKindOfClass:[UILongPressGestureRecognizer class]];
    }];
    [gestureRecognizerArray removeObjectAtIndex:index];
    [gestureRecognizerArray addObject:gestureRecognizer];
    self.mapView.gestureRecognizers = gestureRecognizerArray;
}

- (void)setUpMap
{
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:MapboxID];
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];
    self.mapView = mapView;
    mapView.delegate = self;
    mapView.clusteringEnabled = [SCRSettingsUtility sharedUtility].clusteringEnabled;
    
    [mapView setZoom:12 atCoordinate:MapCenterCoord animated:NO];
    
    //Mapbox will check this database cache of previously downloaded tiles before ever hitting the network
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"RMTileCache" ofType:@"db"];
    RMDatabaseCache *databaseCache = [[RMDatabaseCache alloc] initWithDatabase:databasePath];
    [databaseCache setExpiryPeriod:TileExpiryPeriod];
    [mapView.tileCache insertCache:databaseCache atIndex:0];
    
    [self setUpCommunityAreas];
    
    [self.view addSubview:mapView];
}

- (void)fetchAndMapBuildingsInArray:(NSArray *)buildingsArray
{
    if (buildingsArray.count > 0) {
        self.allBuildingAnnotationsArray = [self arrayOfAnnotationsForBuildingsArray:buildingsArray];
        [self.mapView addAnnotations:self.allBuildingAnnotationsArray];
    }
}

- (NSArray *)arrayOfAnnotationsForBuildingsArray:(NSArray *)buildingsArray
{
    NSMutableArray *annotations = [NSMutableArray array];
    SCRAnnotation *annotation;
    
    NSMutableArray *violationCountsArray = [NSMutableArray arrayWithCapacity:buildingsArray.count];
    for (SCRBuilding *building in buildingsArray) {
        [violationCountsArray addObject:@(building.violations.count)];
    }
    
    NSArray *sortedViolationCountsArray = [self sortArrayOfNumbers:violationCountsArray];
    
    NSNumber *oneThirdPercentile = [self calculatePercentile:33 fromSortedArrayOfNumbers:sortedViolationCountsArray];
    NSNumber *twoThirdsPercentile = [self calculatePercentile:66 fromSortedArrayOfNumbers:sortedViolationCountsArray];
    
    for (SCRBuilding *building in buildingsArray) {
        NSString *subtitle = [NSString stringWithFormat:@"Violations: %@", @(building.violations.count)];
        SCRAnnotationType type;
        
        if ([self specialViolationExistsOnBuilding:building]) {
            type = SCRSpecialAnnotation;
        } else if (building.violations.count <= [oneThirdPercentile integerValue]) {
            type = SCRFewAnnotation;
        } else if (building.violations.count <= [twoThirdsPercentile integerValue]) {
            type = SCRSomeAnnotation;
        } else {
            type = SCRManyAnnotation;
        }
        
        annotation = [[SCRAnnotation alloc] initWithMapView:self.mapView
                                                 coordinate:building.coordinate
                                                      title:building.address
                                                   subtitle:subtitle
                                                       type:type
                                            violationsCount:building.violations.count];
        
        [annotations addObject:annotation];
    }
    return annotations;
}

- (BOOL)specialViolationExistsOnBuilding:(SCRBuilding *)building
{
    NSSet *ordinances = [building.violations valueForKeyPath:@"ordinance"];
    for (NSString *ordinance in ordinances) {
        for (NSString *specialViolation in self.specialViolationsArray) {
            if ([ordinance containsString:specialViolation]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)setUpDatabaseForBackgroundCachingWithMapView:(RMMapView *)mapView andtileSource:(RMMapboxSource *)tileSource
{
    //There's a memory leak somewhere in the Mapbox library with background tile caching & I hit my free plan limit anyway.
    //Putting this code in a method for future use.
    RMDatabaseCache *databaseCache;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *databasePath = [defaults objectForKey:DatabasePathUserDefaultsKey];
    
    if (!databasePath) {
        mapView.tileCache.backgroundCacheDelegate = self;
        databaseCache = [[RMDatabaseCache alloc] initUsingCacheDir:NO];
        [databaseCache setExpiryPeriod:TileExpiryPeriod];
        [mapView.tileCache insertCache:databaseCache atIndex:0];
        [mapView.tileCache beginBackgroundCacheForTileSource:tileSource southWest:CLLocationCoordinate2DMake(41.601163, -87.803764) northEast:CLLocationCoordinate2DMake(42.079050, -87.460098) minZoom:10 maxZoom:17];
    } else {
        databaseCache = [[RMDatabaseCache alloc] initWithDatabase:databasePath];
        [mapView.tileCache insertCache:databaseCache atIndex:0];
    }
}

- (void)addAnimatingProgressSpinner
{
    if (!self.progressSpinner) {
        UIActivityIndicatorView *progressSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.progressSpinner = progressSpinner;
        progressSpinner.frame = CGRectMake(0, 0, 70.0, 70.0);
        progressSpinner.backgroundColor = [UIColor lightGrayColor];
        progressSpinner.center = self.view.center;
        [self.view insertSubview:progressSpinner aboveSubview:self.view];
    }
    [self.progressSpinner startAnimating];
}

- (void)stopAnimatingProgressSpinner
{
    if (self.progressSpinner) {
        [self.progressSpinner stopAnimating];
    }
}

- (SCRBuilding *)buildingForAnnotation:(SCRAnnotation *)annotation
{
    NSArray *buildingArray = [[VOKCoreDataManager sharedInstance] arrayForClass:[SCRBuilding class]
                                                                  withPredicate:[SCRBuilding predicateForAddressMatchingString:annotation.title]
                                                                     forContext:nil];
    return buildingArray.firstObject;
}

- (NSArray *)buildingsInCommunityArea:(NSString *)communityAreaString
{
    return [[VOKCoreDataManager sharedInstance] arrayForClass:[SCRBuilding class]
                                                withPredicate:[SCRBuilding predicateForCommmunityAreaMatchingString:communityAreaString]
                                                   forContext:nil];
}

- (void)setUpCommunityAreas
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"CommunityAreas" withExtension:@"geojson"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *geoJSONDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
    
    NSArray *communityAreas = geoJSONDictionary[@"features"];
    
    for (NSDictionary *topLevelArea in communityAreas) {
        NSArray *geometriesArray = [topLevelArea valueForKeyPath:@"geometry.geometries"];
        NSMutableArray *polygonCoordinatesArray = [[[[geometriesArray firstObject] valueForKeyPath:@"coordinates"] firstObject] mutableCopy];

        for (NSUInteger i = 0; i < polygonCoordinatesArray.count; i++) {
            CLLocationDegrees latitude = [[[polygonCoordinatesArray objectAtIndex:i] lastObject] doubleValue];
            CLLocationDegrees longitude = [[[polygonCoordinatesArray objectAtIndex:i] firstObject] doubleValue];
            
            [polygonCoordinatesArray replaceObjectAtIndex:i
                                               withObject:[[CLLocation alloc] initWithLatitude:latitude longitude:longitude]];
        }

        RMPolygonAnnotation *polygonAnnotation = [[RMPolygonAnnotation alloc] initWithMapView:self.mapView points:polygonCoordinatesArray];
        NSString *descriptionString = [topLevelArea valueForKeyPath:@"properties.description"];
        polygonAnnotation.title = [self communityAreaNameFromDescriptionString:descriptionString];
        polygonAnnotation.clusteringEnabled = NO;
        polygonAnnotation.lineColor = [UIColor purpleColor];
        [self.communityAreaAnnotationsArray addObject:polygonAnnotation];
    
    }
    [self.mapView addAnnotations:self.communityAreaAnnotationsArray];
}

- (void)assignCommunityAreas
{
    NSMutableArray *prelimFilteredAnnsArray = [NSMutableArray array];
    
    for (RMPolygonAnnotation *polygonAnn in self.communityAreaAnnotationsArray) {
        for (SCRAnnotation *buildingAnnotation in self.allBuildingAnnotationsArray) {
            if (RMProjectedRectContainsProjectedPoint(polygonAnn.projectedBoundingBox, buildingAnnotation.projectedLocation)) {
                [prelimFilteredAnnsArray addObject:buildingAnnotation];
            }
        }
        
        for (SCRAnnotation *ann in prelimFilteredAnnsArray) {
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(ann.coordinate.latitude, ann.coordinate.longitude);
            CGPoint annPoint = [self.mapView coordinateToPixel:location];
            
            if ([self polygonFromPolygonArray:@[polygonAnn] containingPoint:annPoint]) {
                SCRBuilding *building = [self buildingForAnnotation:ann];
                building.communityArea = polygonAnn.title;
            }
            
        }
    }
}

- (NSString *)communityAreaNameFromDescriptionString:(NSString *)descriptionString
{
    NSRange firstRange = [descriptionString rangeOfString:DescriptionStringBeginning];
    NSUInteger length = firstRange.location + firstRange.length;
    NSRange newRange = NSMakeRange(0, length);
    NSString *prelimString = [descriptionString stringByReplacingCharactersInRange:newRange withString:@""];
    NSRange secondRange = [prelimString rangeOfString:DescriptionStringEnding];
    NSString *finalString = [prelimString substringToIndex:secondRange.location];
    return finalString;
}

- (void)filterAnnotationsFromGestureRecognizer:(UILongPressGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.view];
    NSMutableArray *polygonAnnotations = [NSMutableArray array];
    for (RMAnnotation *annotation in self.mapView.visibleAnnotations) {
        if ([annotation isKindOfClass:[RMPolygonAnnotation class]]) {
            [polygonAnnotations addObject:annotation];
        }
    }
    RMPolygonAnnotation *polygonAnn = [self polygonFromPolygonArray:polygonAnnotations containingPoint:point];
    NSArray *buildingsArray = [self buildingsInCommunityArea:polygonAnn.title];
    NSArray *buildingAddresses = [buildingsArray valueForKeyPath:@"address"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K in %@", @"title", buildingAddresses];
    NSArray *filteredAnnotations = [self.allBuildingAnnotationsArray filteredArrayUsingPredicate:predicate];
    
    [self.mapView removeAnnotations:self.allBuildingAnnotationsArray];
    self.mapView.clusteringEnabled = NO;
    [self.mapView addAnnotations:filteredAnnotations];
    
}

- (RMPolygonAnnotation *)polygonFromPolygonArray:(NSArray *)polygonArray containingPoint:(CGPoint)point
{
    for (RMPolygonAnnotation *polygonAnn in polygonArray) {
        CGMutablePathRef path = CGPathCreateMutable();
        for (NSUInteger i = 0; i < polygonAnn.points.count; i++) {
            CLLocation *location = [polygonAnn.points objectAtIndex:i];
            CGPoint cgPoint = [self.mapView coordinateToPixel:location.coordinate];
            if (i == 0) {
                CGPathMoveToPoint(path, NULL, cgPoint.x, cgPoint.y);
            } else {
                CGPathAddLineToPoint(path, NULL, cgPoint.x, cgPoint.y);
            }
        }
        
        if (CGPathContainsPoint(path, NULL, point, FALSE)) {
            CGPathRelease(path);
            return polygonAnn;
        }
    }
    
    return nil;
}

#pragma mark - RKMapViewDelegate methods

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    RMMapLayer *layer;
    
    if (annotation.isClusterAnnotation) {
        NSNumber *totalViolationsCount = [annotation.clusteredAnnotations valueForKeyPath:@"@sum.violationsCount"];
        annotation.title = [NSString stringWithFormat:@"%@", totalViolationsCount];
        layer = [[RMMarker alloc] initWithUIImage:nil];
        layer.cornerRadius = 75.0/2.0;
        layer.opacity = 0.60;
        layer.bounds = CGRectMake(0, 0, 75, 75);
        [(RMMarker *)layer setTextForegroundColor:[UIColor blackColor]];
        [(RMMarker *)layer changeLabelUsingText:annotation.title];
    } else {
        layer = [SCRAnnotation markerViewForMapView:mapView annotation:annotation];
    }
    return layer;
}

- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    SCRAnnotation *ann = (SCRAnnotation *)annotation;
    SCRBuilding *building = [self buildingForAnnotation:ann];
    
    if ([annotation isKindOfClass:[SCRAnnotation class]]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:SCRStoryboardIdentifier.StoryboardName bundle:nil];
        SCRAnnotationDetailViewController *annotationDetailVC = [storyboard instantiateViewControllerWithIdentifier:SCRStoryboardIdentifier.AnnotationDetailViewController];
        annotationDetailVC.hidesBottomBarWhenPushed = YES;
        annotationDetailVC.building = building;
        [self.navigationController pushViewController:annotationDetailVC animated:YES];
    }
    
}

- (void)mapViewRegionDidChange:(RMMapView *)mapView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateClusterColors) object:nil];
    [self performSelector:@selector(updateClusterColors) withObject:nil afterDelay:0.1];
}

#pragma mark - RMTileCacheBackgroundDelegate methods

- (void)tileCacheDidFinishBackgroundCache:(RMTileCache *)tileCache
{
    if ([tileCache isKindOfClass:[RMDatabaseCache class]]) {
        RMDatabaseCache *databaseCache = (RMDatabaseCache *)tileCache;
        NSString *databaseCachePath = databaseCache.databasePath;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:databaseCachePath forKey:DatabasePathUserDefaultsKey];
        [defaults synchronize];
    }
}

#pragma mark - Clustering

- (NSArray *)sortArrayOfNumbers:(NSArray *)numberArray
{
    return [numberArray sortedArrayUsingSelector:@selector(compare:)];
}

- (NSNumber *)calculatePercentile:(NSInteger)percentile fromSortedArrayOfNumbers:(NSArray *)sortedNumberArray
{
    float percentileFloat = (CGFloat)percentile;
    float index = sortedNumberArray.count * (percentileFloat/100);
    NSInteger roundedIndex = ceil(index);
    roundedIndex = MAX(roundedIndex - 1, 0);
    return sortedNumberArray[roundedIndex];
}

- (void)updateClusterColors
{
    [self.violationCountsArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"isClusterAnnotation", @YES];
    NSArray *clusterArray = [self.mapView.visibleAnnotations filteredArrayUsingPredicate:predicate];
    
    for (RMAnnotation *cluster in clusterArray) {
        NSInteger totalViolationsCount = [cluster.title integerValue];
        [self.violationCountsArray addObject:@(totalViolationsCount)];
    }
    
    NSArray *sortedViolationCountsArray = [self sortArrayOfNumbers:self.violationCountsArray];
    NSNumber *oneThirdPercentile;
    NSNumber *twoThirdsPercentile;
    if (self.violationCountsArray.count > 1) {
        oneThirdPercentile = [self calculatePercentile:33 fromSortedArrayOfNumbers:sortedViolationCountsArray];
        twoThirdsPercentile = [self calculatePercentile:66 fromSortedArrayOfNumbers:sortedViolationCountsArray];
    }
    
    for (RMAnnotation *cluster in clusterArray) {
        if ([cluster.title integerValue] < [oneThirdPercentile integerValue]) {
            cluster.layer.backgroundColor = [UIColor yellowColor].CGColor;
        } else if ([cluster.title integerValue] <= [twoThirdsPercentile integerValue]) {
            cluster.layer.backgroundColor = [UIColor orangeColor].CGColor;
        } else {
            cluster.layer.backgroundColor = [UIColor redColor].CGColor;
        }
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SCRSettingsViewController class]]) {
        ((SCRSettingsViewController *)segue.destinationViewController).settingsDelegate = self;
    }
}

- (void)completionHandlerForReloadingMapWithBuildingsArray:(NSArray *)buildingsArray
{
    [self fetchAndMapBuildingsInArray:buildingsArray];
    [self assignCommunityAreas];
    [self stopAnimatingProgressSpinner];
}

#pragma mark - SCRSettingsDelegate

- (void)didChangeClusteringEnabled:(BOOL)clusteringEnabled
{
    if (clusteringEnabled) {
        self.mapView.clusteringEnabled = YES;
        [self.mapView removeAnnotations:self.allBuildingAnnotationsArray];
        [self.mapView addAnnotations:self.allBuildingAnnotationsArray];
    } else {
        self.mapView.clusteringEnabled = NO;
    }
}

- (void)didChangeNumberOfViolationsToDisplay:(NSInteger)numberOfViolations
{
    [self.mapView removeAnnotations:self.allBuildingAnnotationsArray];
    [self addAnimatingProgressSpinner];
    [SCRNetworking getViolationsWithinUpperLeft:UpperLeft23rdAndHalstedCoord
                                     lowerRight:LowerRight95thAndLakeCoord
                             numberOfViolations:numberOfViolations
                              completionHandler:^(NSArray *buildingsArray) {
                                  [self completionHandlerForReloadingMapWithBuildingsArray:buildingsArray];
                              }];
}

- (void)didChangeDateToDisplayViolationsOnOrAfter:(NSDate *)dateToDisplayViolationsOnOrAfter
{
    [self.mapView removeAnnotations:self.allBuildingAnnotationsArray];
    [self addAnimatingProgressSpinner];
    [SCRNetworking getViolationsWithinUpperLeft:UpperLeft23rdAndHalstedCoord
                                     lowerRight:LowerRight95thAndLakeCoord
                             numberOfViolations:[SCRSettingsUtility sharedUtility].numberOfViolationsToDisplay
                                  onOrAfterDate:dateToDisplayViolationsOnOrAfter
                              completionHandler:^(NSArray *buildingsArray) {
                                  [self completionHandlerForReloadingMapWithBuildingsArray:buildingsArray];
                              }];
}

@end

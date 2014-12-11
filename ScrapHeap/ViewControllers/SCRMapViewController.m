//
//  SCRDefaultMapViewController.m
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
#import "SCRAnnotation.h"
#import "SCRAnnotationDetailViewController.h"

static NSString *const MapboxID = @"rhyman.keaoeg0b";
static NSString *const DatabasePathUserDefaultsKey = @"tileDatabaseCachePath";
static NSTimeInterval const TileExpiryPeriod = (60*60*24*7*52*10); //arbitrary expiry period of 10 years for tile cache
static CLLocationCoordinate2D const ChicagoCenter = {.latitude = 41.878114, .longitude = -87.629798};

@interface SCRMapViewController () <RMMapViewDelegate, RMTileCacheBackgroundDelegate>

@property (weak, nonatomic) RMMapView *mapView;
@property (strong, nonatomic) NSMutableArray *violationCountsArray;

@end

@implementation SCRMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.violationCountsArray = [NSMutableArray array];
    [self setUpMap];
    [self fetchAndMapBuildings];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)dealloc
{
    self.mapView.delegate = nil;
}

- (void)setUpMap
{
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:MapboxID];
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];
    self.mapView = mapView;
    mapView.delegate = self;
    mapView.clusteringEnabled = YES;
    
    [mapView setZoom:11 atCoordinate:ChicagoCenter animated:NO];
    
    //Mapbox will check this database cache of previously downloaded tiles before ever hitting the network
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"RMTileCache" ofType:@"db"];
    RMDatabaseCache *databaseCache = [[RMDatabaseCache alloc] initWithDatabase:databasePath];
    [databaseCache setExpiryPeriod:TileExpiryPeriod];
    [mapView.tileCache insertCache:databaseCache atIndex:0];
    
    [self.view addSubview:mapView];
}

- (void)fetchAndMapBuildings
{
    NSArray *buildings = [SCRCoreDataUtility fetchAllBuildings];
    NSMutableArray *annotations = [NSMutableArray array];
    SCRAnnotation *annotation;
    
    NSMutableArray *violationCountsArray = [NSMutableArray arrayWithCapacity:buildings.count];
    for (SCRBuilding *building in buildings) {
        [violationCountsArray addObject:@(building.violations.count)];
    }
    
    NSArray *sortedViolationCountsArray = [self sortArrayOfNumbers:violationCountsArray];
    
    NSNumber *oneThirdPercentile = [self calculatePercentile:33 fromSortedArrayOfNumbers:sortedViolationCountsArray];
    NSNumber *twoThirdsPercentile = [self calculatePercentile:66 fromSortedArrayOfNumbers:sortedViolationCountsArray];
    
    for (SCRBuilding *building in buildings) {
        NSString *subtitle = [NSString stringWithFormat:@"Violations: %@", @(building.violations.count)];
        SCRAnnotationType type;
        
        if (building.violations.count <= [oneThirdPercentile integerValue]) {
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
    [self.mapView addAnnotations:annotations];
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

- (SCRBuilding *)buildingForAnnotation:(SCRAnnotation *)annotation
{
    NSArray *buildingArray = [[VOKCoreDataManager sharedInstance] arrayForClass:[SCRBuilding class]
                                                                  withPredicate:[SCRBuilding predicateForAddressMatchingString:annotation.title]
                                                                     forContext:nil];
    return buildingArray.firstObject;
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
        [(RMMarker *)layer changeLabelUsingText:[NSString stringWithFormat:@"%@", totalViolationsCount]];
        
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

@end

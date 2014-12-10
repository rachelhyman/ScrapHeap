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

static NSString *const mapboxID = @"rhyman.keaoeg0b";
static CLLocationCoordinate2D const ChicagoCenter = {.latitude = 41.878114, .longitude = -87.629798};

@interface SCRMapViewController () <RMMapViewDelegate>

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
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:mapboxID];
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];
    self.mapView = mapView;
    mapView.delegate = self;
    mapView.clusteringEnabled = YES;
    
    [mapView setZoom:11 atCoordinate:ChicagoCenter animated:NO];
    
    [self.view addSubview:mapView];
}

- (void)fetchAndMapBuildings
{
    NSArray *buildings = [SCRCoreDataUtility fetchAllBuildings];
    NSMutableArray *annotations = [NSMutableArray array];
    SCRAnnotation *annotation;
    
    NSMutableArray *violationCountsArray = [NSMutableArray array];
    for (SCRBuilding *building in buildings) {
        [violationCountsArray addObject:@(building.violations.count)];
    }
    
    NSNumber *oneThirdPercentile = [self calculatePercentile:33 fromArrayOfNumbers:violationCountsArray];
    NSNumber *twoThirdsPercentile = [self calculatePercentile:66 fromArrayOfNumbers:violationCountsArray];
    
    for (SCRBuilding *building in buildings) {
        NSString *subtitle = [NSString stringWithFormat:@"Violations: %@", [NSNumber numberWithInteger:building.violations.count]];
        
        if (building.violations.count <= [oneThirdPercentile floatValue]) {
            annotation = [[SCRAnnotation alloc] initWithMapView:self.mapView
                                                     coordinate:building.coordinate
                                                          title:building.address
                                                       subtitle:subtitle
                                                           type:SCRFewAnnotation
                                                violationsCount:building.violations.count];
        } else if (building.violations.count <= [twoThirdsPercentile floatValue]) {
            annotation = [[SCRAnnotation alloc] initWithMapView:self.mapView
                                                     coordinate:building.coordinate
                                                          title:building.address
                                                       subtitle:subtitle
                                                           type:SCRSomeAnnotation
                                                violationsCount:building.violations.count];
        } else {
            annotation = [[SCRAnnotation alloc] initWithMapView:self.mapView
                                                     coordinate:building.coordinate
                                                          title:building.address
                                                       subtitle:subtitle
                                                           type:SCRManyAnnotation
                                                violationsCount:building.violations.count];
        }
        [annotations addObject:annotation];
    }
    [self.mapView addAnnotations:annotations];
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
        
        layer = [[RMMarker alloc] initWithUIImage:nil];
        layer.cornerRadius = 75/2;
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

#pragma mark - Clustering

- (NSNumber *)calculatePercentile:(NSInteger)percentile fromArrayOfNumbers:(NSArray *)numberArray
{
    NSArray *sortDescriptorArray = @[[NSSortDescriptor sortDescriptorWithKey:nil ascending:YES]];
    NSArray *sortedArray = [numberArray sortedArrayUsingDescriptors:sortDescriptorArray];
    
    float percentileFloat = (CGFloat)percentile;
    float index = sortedArray.count * (percentileFloat/100);
    NSInteger roundedIndex = ceil(index);
    return sortedArray[(roundedIndex - 1)];
}

- (void)updateClusterColors
{
    [self.violationCountsArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"isClusterAnnotation", @YES];
    NSArray *clusterArray = [self.mapView.visibleAnnotations filteredArrayUsingPredicate:predicate];
    
    for (RMAnnotation *cluster in clusterArray) {
        int totalViolationsCount = 0;
        for (SCRAnnotation *building in cluster.clusteredAnnotations) {
            totalViolationsCount += building.violationsCount;
        }
        cluster.title = [NSString stringWithFormat:@"%d", totalViolationsCount];
        [self.violationCountsArray addObject:@(totalViolationsCount)];
    }
    
    NSNumber *oneThirdPercentile;
    NSNumber *twoThirdsPercentile;
    if (self.violationCountsArray.count > 1) {
        oneThirdPercentile = [self calculatePercentile:33 fromArrayOfNumbers:self.violationCountsArray];
        twoThirdsPercentile = [self calculatePercentile:66 fromArrayOfNumbers:self.violationCountsArray];
    }
    
    for (RMAnnotation *cluster in clusterArray) {
        if ([cluster.title integerValue] < [oneThirdPercentile floatValue]) {
            cluster.layer.backgroundColor = [UIColor yellowColor].CGColor;
        } else if ([cluster.title integerValue] <= [twoThirdsPercentile floatValue]) {
            cluster.layer.backgroundColor = [UIColor orangeColor].CGColor;
        } else {
            cluster.layer.backgroundColor = [UIColor redColor].CGColor;
        }
    }
    
}

@end

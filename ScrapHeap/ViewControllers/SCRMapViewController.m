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
static int const FewAnnotationsThreshold = 5;
static int const SomeAnnotationsThreshold = 14;

@interface SCRMapViewController () <RMMapViewDelegate>

@property (weak, nonatomic) RMMapView *mapView;

@end

@implementation SCRMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    [mapView setZoom:11 atCoordinate:ChicagoCenter animated:NO];
    
    [self.view addSubview:mapView];
}

- (void)fetchAndMapBuildings
{
    NSArray *buildings = [SCRCoreDataUtility fetchAllBuildings];
    NSMutableArray *annotations = [NSMutableArray array];
    SCRAnnotation *annotation;
    
    for (SCRBuilding *building in buildings) {
        NSString *subtitle = [NSString stringWithFormat:@"Violations: %@", [NSNumber numberWithInteger:building.violations.count]];
        if (building.violations.count < FewAnnotationsThreshold) {
            annotation = [[SCRAnnotation alloc] initWithMapView:self.mapView
                                                     coordinate:building.coordinate
                                                          title:building.address
                                                       subtitle:subtitle
                                                           type:SCRFewAnnotation];
        } else if (building.violations.count < SomeAnnotationsThreshold) {
            annotation = [[SCRAnnotation alloc] initWithMapView:self.mapView
                                                     coordinate:building.coordinate
                                                          title:building.address
                                                       subtitle:subtitle
                                                           type:SCRSomeAnnotation];
        } else {
            annotation = [[SCRAnnotation alloc] initWithMapView:self.mapView
                                                     coordinate:building.coordinate
                                                          title:building.address
                                                       subtitle:subtitle
                                                           type:SCRManyAnnotation];
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

# pragma mark - RKMapViewDelegate methods

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    return [SCRAnnotation markerViewForMapView:mapView annotation:annotation];
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

@end

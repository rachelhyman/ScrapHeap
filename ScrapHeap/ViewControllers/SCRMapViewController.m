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
static int const FewAnnotationsClusterThreshold = 20;
static int const SomeAnnotationsClusterThreshold = 100;

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
    mapView.clusteringEnabled = YES;
    
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
                                                           type:SCRFewAnnotation
                                                violationsCount:building.violations.count];
        } else if (building.violations.count < SomeAnnotationsThreshold) {
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

# pragma mark - RKMapViewDelegate methods

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    RMMapLayer *layer;
    
    if (annotation.isClusterAnnotation) {
        
        int totalViolationsCount = 0;
        for (SCRAnnotation *ann in annotation.clusteredAnnotations) {
            totalViolationsCount += ann.violationsCount;
        }
        
        if (totalViolationsCount < FewAnnotationsClusterThreshold) {
            layer = [[RMMarker alloc] initWithUIImage:[self createCircleWithColor:[UIColor yellowColor]]];
        } else if (totalViolationsCount < SomeAnnotationsClusterThreshold) {
            layer = [[RMMarker alloc] initWithUIImage:[self createCircleWithColor:[UIColor orangeColor]]];
        } else {
            layer = [[RMMarker alloc] initWithUIImage:[self createCircleWithColor:[UIColor redColor]]];
        }
        layer.opacity = 0.60;
        layer.bounds = CGRectMake(0, 0, 75, 75);
        [(RMMarker *)layer setTextForegroundColor:[UIColor whiteColor]];
        [(RMMarker *)layer changeLabelUsingText:[NSString stringWithFormat:@"%i", totalViolationsCount]];
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

#pragma mark - Clustering

- (UIImage *)createCircleWithColor:(UIColor *)color
{
    UIImage *circle;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.0f, 20.0f), NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGRect rect = CGRectMake(0, 0, 20, 20);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillEllipseInRect(context, rect);
    
    CGContextRestoreGState(context);
    circle = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circle;
}

- (void)calculateAverageClusterCount
{
    NSArray *annotations = self.mapView.annotations;
    NSMutableArray *clusterAnnotations = [[NSMutableArray alloc] init];
    for (RMAnnotation *ann in annotations) {
        if (ann.isClusterAnnotation) {
            [clusterAnnotations addObject:ann];
        }
    }
    
}

@end

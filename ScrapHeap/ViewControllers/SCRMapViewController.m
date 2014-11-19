//
//  SCRDefaultMapViewController.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/29/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRMapViewController.h"

@import MapKit;

#import "VOKCoreDataManager.h"
#import "SCRCoreDataUtility.h"
#import "SCRBuilding.h"
#import "SCRAnnotation.h"
#import "SCRAnnotationDetailViewController.h"

static CLLocationCoordinate2D const ChicagoCenter = {.latitude = 41.878114, .longitude = -87.629798};
static MKCoordinateSpan const InitialSpan = {.latitudeDelta = 0.4, .longitudeDelta = 0.25};

static int const FewAnnotationsThreshold = 5;
static int const SomeAnnotationsThreshold = 14;

@interface SCRMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SCRMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setRegion:MKCoordinateRegionMake(ChicagoCenter, InitialSpan)];
    self.navigationController.navigationBarHidden = YES;
    [self fetchAndMapBuildings];
}

- (void)dealloc
{
    self.mapView.delegate = nil;
}

- (void)fetchAndMapBuildings
{
    NSArray *buildings = [SCRCoreDataUtility fetchAllBuildings];
    NSMutableArray *annotations = [NSMutableArray array];
    SCRAnnotation *annotation;
    
    for (SCRBuilding *building in buildings) {
        NSString *subtitle = [NSString stringWithFormat:@"Violations: %@", [NSNumber numberWithInteger:building.violations.count]];
        if (building.violations.count < FewAnnotationsThreshold) {
            annotation = [[SCRAnnotation alloc] initWithLocation:building.coordinate
                                                           title:building.address
                                                        subtitle:subtitle
                                                            type:SCRFewAnnotation];
        } else if (building.violations.count < SomeAnnotationsThreshold) {
            annotation = [[SCRAnnotation alloc] initWithLocation:building.coordinate
                                                           title:building.address
                                                        subtitle:subtitle
                                                            type:SCRSomeAnnotation];
        } else {
            annotation = [[SCRAnnotation alloc] initWithLocation:building.coordinate
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

#pragma mark - MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    SCRAnnotation *ann = (SCRAnnotation *)annotation;
    return [SCRAnnotation annotationViewForMapView:mapView annotation:annotation type:ann.type];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    SCRAnnotation *annotation = (SCRAnnotation *)view.annotation;
    SCRBuilding *building = [self buildingForAnnotation:annotation];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:SCRStoryboardIdentifier.StoryboardName bundle:nil];
    SCRAnnotationDetailViewController *annotationDetailVC = [storyboard instantiateViewControllerWithIdentifier:SCRStoryboardIdentifier.AnnotationDetailViewController];
    annotationDetailVC.hidesBottomBarWhenPushed = YES; 
    annotationDetailVC.building = building;
    [self.navigationController pushViewController:annotationDetailVC animated:YES];
}

@end

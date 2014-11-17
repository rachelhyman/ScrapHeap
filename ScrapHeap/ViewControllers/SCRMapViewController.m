//
//  SCRDefaultMapViewController.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/29/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRMapViewController.h"

#import "SCRCoreDataUtility.h"
#import "SCRBuilding.h"
#import "SCRAnnotation.h"

@import MapKit;

CLLocationCoordinate2D const ChicagoCenter = {.latitude = 41.878114, .longitude = -87.629798};
MKCoordinateSpan const InitialSpan = {.latitudeDelta = 0.4, .longitudeDelta = 0.25};

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
       CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([building.latitude doubleValue], [building.longitude doubleValue]);
        NSString *subtitle = [NSString stringWithFormat:@"Violations: %lu", building.violations.count];
        if (building.violations.count < FewAnnotationsThreshold) {
            annotation = [[SCRAnnotation alloc] initWithLocation:coordinate
                                                           title:building.address
                                                        subtitle:subtitle
                                                            type:SCRAnnotationType.FewAnnotation];
        } else if (building.violations.count < SomeAnnotationsThreshold) {
            annotation = [[SCRAnnotation alloc] initWithLocation:coordinate
                                                           title:building.address
                                                        subtitle:subtitle
                                                            type:SCRAnnotationType.SomeAnnotation];
        } else {
            annotation = [[SCRAnnotation alloc] initWithLocation:coordinate
                                                           title:building.address
                                                        subtitle:subtitle
                                                            type:SCRAnnotationType.ManyAnnotation];
        }
        [annotations addObject:annotation];
    }
    [self.mapView addAnnotations:annotations];
}

#pragma mark - MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = nil;
    SCRAnnotation *ann = (SCRAnnotation *)annotation;
    if (ann.type == SCRAnnotationType.FewAnnotation) {
        annotationView = [SCRAnnotation annotationViewForMapView:mapView
                                                      annotation:annotation
                                                            type:SCRAnnotationType.FewAnnotation];
    } else if (ann.type == SCRAnnotationType.SomeAnnotation) {
        annotationView = [SCRAnnotation annotationViewForMapView:mapView
                                                      annotation:annotation
                                                            type:SCRAnnotationType.SomeAnnotation];
    } else if (ann.type == SCRAnnotationType.ManyAnnotation) {
        annotationView = [SCRAnnotation annotationViewForMapView:mapView
                                                      annotation:annotation
                                                            type:SCRAnnotationType.ManyAnnotation];
    } else {
        annotationView = [SCRAnnotation annotationViewForMapView:mapView
                                                      annotation:annotation
                                                            type:ann.type];
    }
    return annotationView;
}

@end

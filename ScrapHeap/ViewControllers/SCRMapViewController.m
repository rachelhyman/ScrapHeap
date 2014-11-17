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

@import MapKit;

CLLocationCoordinate2D const ChicagoCenter = {.latitude = 41.878114, .longitude = -87.629798};
MKCoordinateSpan const InitialSpan = {.latitudeDelta = 0.4, .longitudeDelta = 0.25};

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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinview"];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinview"];
        annotationView.canShowCallout = YES;
        annotationView.pinColor = MKPinAnnotationColorPurple;
    } else {
        annotationView.annotation = annotation;
    }
    return annotationView;
}

- (void)dealloc
{
    self.mapView.delegate = nil;
}

- (void)fetchAndMapBuildings
{
    NSArray *buildings = [SCRCoreDataUtility fetchAllBuildings];
    NSMutableArray *annotations = [NSMutableArray array];
    for (SCRBuilding *building in buildings) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake([building.latitude doubleValue], [building.longitude doubleValue]);
        annotation.title = building.address;
        [annotations addObject:annotation];
    }
    [self.mapView addAnnotations:annotations];
}

@end

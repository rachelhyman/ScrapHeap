//
//  SCRAnnotation.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 11/17/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRAnnotation.h"

@implementation SCRAnnotation

//<MKAnnotation> protocol properties are not automatically synthesized, so we do it here
@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord title:(NSString *)annTitle subtitle:(NSString *)annSubtitle type:(NSString *)type
{
    self = [super init];
    if (self) {
        _coordinate = coord;
        _title = annTitle;
        _subtitle = annSubtitle;
        _type = type;
    }
    return self; 
}

+ (MKPinAnnotationView *)annotationViewForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation type:(NSString *)type
{
    MKPinAnnotationView *pinAnnotationView;
    if (type == SCRAnnotationType.FewAnnotation) {
        pinAnnotationView = [self pinAnnotationViewWithIdentifier:SCRAnnotationType.FewAnnotation forMapView:mapView annotation:annotation];
        pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
    } else if (type == SCRAnnotationType.SomeAnnotation) {
        pinAnnotationView = [self pinAnnotationViewWithIdentifier:SCRAnnotationType.SomeAnnotation forMapView:mapView annotation:annotation];
        pinAnnotationView.pinColor = MKPinAnnotationColorPurple;
    } else if (type ==SCRAnnotationType.ManyAnnotation) {
        pinAnnotationView = [self pinAnnotationViewWithIdentifier:SCRAnnotationType.ManyAnnotation forMapView:mapView annotation:annotation];
        pinAnnotationView.pinColor = MKPinAnnotationColorRed;
    } else {
        //fallback case returns generic MKPinAnnotationView in case unexpected type is passed in
        pinAnnotationView = [[MKPinAnnotationView alloc] init];
    }
    return pinAnnotationView;
}

//helper method for creating annotation view with identifier passed in
+ (MKPinAnnotationView *)pinAnnotationViewWithIdentifier:(NSString *)identifier forMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
    } else {
        annotationView.annotation = annotation;
    }
    return annotationView;
}

@end

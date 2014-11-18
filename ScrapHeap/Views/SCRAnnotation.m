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

- (instancetype)initWithLocation:(CLLocationCoordinate2D)coord title:(NSString *)annTitle subtitle:(NSString *)annSubtitle type:(SCRAnnotationType)type
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

+ (MKPinAnnotationView *)annotationViewForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation type:(SCRAnnotationType)type
{
    MKPinAnnotationView *pinAnnotationView = [self pinAnnotationViewforMapView:mapView annotation:annotation];
    
    switch (type) {
        case SCRFewAnnotation:
            pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
            break;
        case SCRSomeAnnotation:
            pinAnnotationView.pinColor = MKPinAnnotationColorPurple;
            break;
        case SCRManyAnnotation:
            pinAnnotationView.pinColor = MKPinAnnotationColorRed;
            break;
        default:
            pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
            break;
    }
    return pinAnnotationView;
}

//helper method for creating annotation view 
+ (MKPinAnnotationView *)pinAnnotationViewforMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation
{
    static NSString *const annotationViewIdentifier = @"annotationview";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier];
        annotationView.canShowCallout = YES;
    } else {
        annotationView.annotation = annotation;
    }
    return annotationView;
}

@end

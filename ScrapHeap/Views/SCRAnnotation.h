//
//  SCRAnnotation.h
//  ScrapHeap
//
//  Created by Rachel Hyman on 11/17/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;

@interface SCRAnnotation : NSObject <MKAnnotation>

///should be a SCRAnnotationType corresponding to relative # of violations for building
@property (nonatomic, strong) NSString *type;

///creates an annotation adhering to <MKAnnotation> protocol.
///set the type to an SCRAnnotationType to ensure annotation is of correct color.
- (id)initWithLocation:(CLLocationCoordinate2D)coord title:(NSString *)annTitle subtitle:(NSString *)annSubtitle type:(NSString *)type;

///returns an MKPinAnnotationView corresponding to the type (SCRAnnotationType) passed in
+ (MKPinAnnotationView *)annotationViewForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation type:(NSString *)type;

@end

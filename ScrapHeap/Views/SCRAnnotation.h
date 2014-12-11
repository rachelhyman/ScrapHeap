//
//  SCRAnnotation.h
//  ScrapHeap
//
//  Created by Rachel Hyman on 11/17/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Mapbox.h"

@interface SCRAnnotation : RMAnnotation

///Count of violations for the building annotation
@property (nonatomic) NSUInteger violationsCount;

///Creates an annotation.
///Set the type to an SCRAnnotationType to ensure annotation is of correct color.
- (instancetype)initWithMapView:(RMMapView *)mapView coordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle type:(SCRAnnotationType)aType violationsCount:(NSUInteger)count;

//Returns an annotation layer that will color markers according to the SCRAnnotationType associated with the annotation.
+ (RMMarker *)markerViewForMapView:(RMMapView *)mapView annotation:(RMAnnotation *)annotation;

@end

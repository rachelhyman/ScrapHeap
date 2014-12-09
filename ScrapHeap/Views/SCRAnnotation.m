//
//  SCRAnnotation.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 11/17/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRAnnotation.h"

static NSString *const buildingMarkerImage = @"commercial";

@implementation SCRAnnotation

- (instancetype)initWithMapView:(RMMapView *)mapView coordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle type:(SCRAnnotationType)aType violationsCount:(NSUInteger)theCount
{
    self = [super initWithMapView:mapView
                       coordinate:aCoordinate
                         andTitle:aTitle];
    if (self) {
        self.subtitle = aSubtitle;
        self.userInfo = @(aType);
        self.violationsCount = theCount;
    }
    return self;
}

+ (RMMarker *)markerViewForMapView:(RMMapView *)mapView annotation:(RMAnnotation *)annotation
{
    RMMarker *marker;
    
    if ([annotation.userInfo isEqual:@(SCRFewAnnotation)]) {
        marker = [[RMMarker alloc] initWithMapboxMarkerImage:buildingMarkerImage tintColor:[UIColor yellowColor]];
    } else if ([annotation.userInfo isEqual:@(SCRSomeAnnotation)]) {
        marker = [[RMMarker alloc] initWithMapboxMarkerImage:buildingMarkerImage tintColor:[UIColor orangeColor]];
    } else {
        marker = [[RMMarker alloc] initWithMapboxMarkerImage:buildingMarkerImage tintColor:[UIColor redColor]];
    }
    
    marker.canShowCallout = YES;
    marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return marker;
}

@end

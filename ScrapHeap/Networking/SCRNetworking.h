//
//  SCRNetworking.h
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/31/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@class AFHTTPSessionManager;

typedef void (^SCRNetworkingBasicCompletionHandler)(void);
typedef void (^SCRNetworkingBuildingsCompletionHandler)(NSArray *buildingsArray);

@interface SCRNetworking : NSObject

///Gets data live from server
+ (void)getViolationsWithCompletionHandler:(SCRNetworkingBasicCompletionHandler)handler;

///Gets data that falls within a bounding box specified by upper left and lower right coordinates and the most recent specified # of violations
///Imports data into Core Data, then passes an array of building model objects into handler
+ (void)getViolationsWithinUpperLeft:(CLLocationCoordinate2D)upperLeftCoord
                          lowerRight:(CLLocationCoordinate2D)lowerRightCoord
                  numberOfViolations:(NSInteger)numberOfViolations
                   completionHandler:(SCRNetworkingBuildingsCompletionHandler)handler;

///Gets data that falls within a bounding box specified by upper left and lower right coordinates, the most recent specified # of violations, and that fall on or after the specified date
///Imports data into Core Data, then passes an array of building model objects into handler
+ (void)getViolationsWithinUpperLeft:(CLLocationCoordinate2D)upperLeftCoord
                          lowerRight:(CLLocationCoordinate2D)lowerRightCoord
                  numberOfViolations:(NSInteger)numberOfViolations
                       onOrAfterDate:(NSDate *)onOrAfterDate
                   completionHandler:(SCRNetworkingBuildingsCompletionHandler)handler;

@end

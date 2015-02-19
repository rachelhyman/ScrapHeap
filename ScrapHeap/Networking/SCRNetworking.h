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

@interface SCRNetworking : NSObject

///Gets data live from server
+ (void)getViolationsWithCompletionHandler:(SCRNetworkingBasicCompletionHandler)handler;

///Gets data that falls within a bounding box specified by upper left and lower right coordinates
///Returns most recent specified # of violations
+ (void)getViolationsWithinUpperLeft:(CLLocationCoordinate2D)upperLeftCoord
                          lowerRight:(CLLocationCoordinate2D)lowerRightCoord
                  numberOfViolations:(NSInteger)numberOfViolations
                   completionHandler:(SCRNetworkingBasicCompletionHandler)handler;

@end

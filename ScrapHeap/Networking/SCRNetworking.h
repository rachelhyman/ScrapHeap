//
//  SCRNetworking.h
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/31/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

@interface SCRNetworking : NSObject

///Gets data live from server
+ (void)getViolations;

@end

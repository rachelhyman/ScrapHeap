//
//  SCRNetworking.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/31/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRNetworking.h"

#import <AFNetworking.h>

static NSString *const Endpoint = @"http://data.cityofchicago.org/resource/22u3-xenr/";

@implementation SCRNetworking

+ (AFHTTPSessionManager *)sessionManager
{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[self baseURL]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
    });
    return manager;
}

+ (NSURL *)baseURL
{
    return [NSURL URLWithString:Endpoint];
}

+ (void)getViolations
{
    [[SCRNetworking sessionManager] GET:Endpoint
                            parameters:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    NSLog(@"%@", responseObject);
                                        }
                                failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    NSLog(@"Failure");
                                }];
}

@end

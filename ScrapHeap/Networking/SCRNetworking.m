//
//  SCRNetworking.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/31/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRNetworking.h"

#import <AFNetworking.h>
#import "SCRCoreDataUtility.h"

static NSString *const Endpoint = @"http://data.cityofchicago.org/resource/22u3-xenr/";
static NSString *const AppToken = @"GthgnkwqVlsElC4cdPqELnrjJ";

@implementation SCRNetworking

+ (AFHTTPSessionManager *)sessionManager
{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[self baseURL]];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:AppToken forHTTPHeaderField:@"X-App-Token"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
    });
    return manager;
}

+ (NSURL *)baseURL
{
    return [NSURL URLWithString:Endpoint];
}

+ (void)getViolationsWithCompletionHandler:(SCRNetworkingBasicCompletionHandler)handler
{
    [[SCRNetworking sessionManager] GET:@""
                             parameters:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    [SCRCoreDataUtility loadDataFromArray:responseObject completion:handler];
                                        }
                                failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    NSLog(@"Failure");
                                }];
}

@end

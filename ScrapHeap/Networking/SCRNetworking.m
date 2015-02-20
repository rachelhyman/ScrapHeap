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
#import "SCRSettingsUtility.h"

static NSString *const Endpoint = @"http://data.cityofchicago.org/resource/22u3-xenr.json";
static NSString *const AppToken = @"GthgnkwqVlsElC4cdPqELnrjJ";
static NSString *const LastFetchedDateKey = @"most recent violation";

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
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    [defaults setObject:[NSDate date] forKey:LastFetchedDateKey];
                                        }
                                failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    NSLog(@"Failure");
                                }];
}

+ (void)getViolationsWithinUpperLeft:(CLLocationCoordinate2D)upperLeftCoord
                          lowerRight:(CLLocationCoordinate2D)lowerRightCoord
                  numberOfViolations:(NSInteger)numberOfViolations
                   completionHandler:(SCRNetworkingBuildingsCompletionHandler)handler
{
    [[SCRNetworking sessionManager] GET:@""
                             parameters:@{
                                          @"$WHERE": [NSString stringWithFormat:@"latitude >= %f AND latitude <= %f AND longitude >= %f AND longitude <= %f", lowerRightCoord.latitude, upperLeftCoord.latitude, upperLeftCoord.longitude, lowerRightCoord.longitude],
                                          @"$LIMIT": @(numberOfViolations),
                                          @"$ORDER": @"violation_date DESC",
                                          }
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    [SCRCoreDataUtility loadDataFromArray:responseObject completion:nil];
                                    [SCRSettingsUtility sharedUtility].numberOfViolationsToDisplay = numberOfViolations;
                                     NSArray *buildingsArray = [SCRCoreDataUtility fetchMostRecentBuildingsWithViolationsCount:numberOfViolations];
                                    if (handler) {
                                        handler(buildingsArray);
                                    }
                                }
                                failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    NSLog(@"Failure");
                                }];
}

@end

//
//  AppDelegate.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/29/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRAppDelegate.h"

#import "SCRCoreDataUtility.h"

@interface SCRAppDelegate ()

@end

@implementation SCRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [SCRCoreDataUtility setUpCoreData];
    return YES;
}

@end

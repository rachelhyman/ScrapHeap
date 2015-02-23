//
//  SCRSettingsUtility.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 2/19/15.
//  Copyright (c) 2015 Rachel Hyman. All rights reserved.
//

#import "SCRSettingsUtility.h"

static NSString *const ClusteringEnabledKey = @"ClusteringEnabledKey";
static NSString *const NumberOfViolationsKey = @"NumberOfViolationsKey";
static NSString *const DateToDisplayViolationsOnOrAfterKey = @"DateToDisplayKey";

@implementation SCRSettingsUtility

+ (instancetype)sharedUtility
{
    static SCRSettingsUtility *sharedUtility = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUtility = [[self alloc] init];
    });
    
    return sharedUtility;
}

#pragma mark - Setters

- (void)setClusteringEnabled:(BOOL)clusteringEnabled
{
    [[NSUserDefaults standardUserDefaults] setBool:clusteringEnabled
                                            forKey:ClusteringEnabledKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setNumberOfViolationsToDisplay:(NSInteger)numberOfViolationsToDisplay
{
    [[NSUserDefaults standardUserDefaults] setInteger:numberOfViolationsToDisplay
                                               forKey:NumberOfViolationsKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDateToDisplayViolationsOnOrAfter:(NSDate *)dateToDisplayViolationsOnOrAfter
{
    [[NSUserDefaults standardUserDefaults] setObject:dateToDisplayViolationsOnOrAfter
                                              forKey:DateToDisplayViolationsOnOrAfterKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Getters

- (BOOL)clusteringEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:ClusteringEnabledKey];
}

- (NSInteger)numberOfViolationsToDisplay
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:NumberOfViolationsKey];
}

- (NSDate *)dateToDisplayViolationsOnOrAfter
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:DateToDisplayViolationsOnOrAfterKey];
}

@end

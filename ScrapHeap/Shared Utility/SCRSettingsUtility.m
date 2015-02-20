//
//  SCRSettingsUtility.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 2/19/15.
//  Copyright (c) 2015 Rachel Hyman. All rights reserved.
//

#import "SCRSettingsUtility.h"

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
    _clusteringEnabled = clusteringEnabled;
//    [[NSUserDefaults standardUserDefaults] setBool:clusteringEnabled
//                                            forKey:ClusteringEnabledKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setNumberOfViolationsToDisplay:(NSInteger)numberOfViolationsToDisplay
{
    _numberOfViolationsToDisplay = numberOfViolationsToDisplay;
//    [[NSUserDefaults standardUserDefaults] setInteger:numberOfViolationsToDisplay
//                                               forKey:NumberOfViolationsKey];
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Getters

//- (BOOL)clusteringEnabled
//{
//    return [[NSUserDefaults standardUserDefaults] boolForKey:ClusteringEnabledKey];
//}
//
//- (NSInteger)numberOfViolationsToDisplay
//{
//    return [[NSUserDefaults standardUserDefaults] integerForKey:NumberOfViolationsKey];
//}

@end

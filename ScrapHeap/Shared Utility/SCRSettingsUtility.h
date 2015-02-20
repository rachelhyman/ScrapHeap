//
//  SCRSettingsUtility.h
//  ScrapHeap
//
//  Created by Rachel Hyman on 2/19/15.
//  Copyright (c) 2015 Rachel Hyman. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const ClusteringEnabledKey;
static NSString *const NumberOfViolationsKey;

@interface SCRSettingsUtility : NSObject

+ (instancetype)sharedUtility;

@property (nonatomic) NSInteger numberOfViolationsToDisplay;
@property (nonatomic) BOOL clusteringEnabled;

@end

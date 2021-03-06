//
//  SCRSettingsUtility.h
//  ScrapHeap
//
//  Created by Rachel Hyman on 2/19/15.
//  Copyright (c) 2015 Rachel Hyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCRSettingsUtility : NSObject

+ (instancetype)sharedUtility;

@property (nonatomic) NSInteger numberOfViolationsToDisplay;
@property (nonatomic) BOOL clusteringEnabled;
@property (nonatomic, strong) NSDate *dateToDisplayViolationsOnOrAfter;

@end

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

@end

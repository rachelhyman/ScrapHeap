//
//  SCRConstants.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/29/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRConstants.h"

const struct SCRNotificationNames SCRNotification = {
    .DidToggleToDefaultMap = @"com.rachelhyman.toggleToDefaultMap",
    .DidToggleToHeatMap = @"com.rachelhyman.toggleToHeatMap",
};

const struct SCRStoryboardIdentifiers SCRStoryboardIdentifier = {
    .DefaultMapViewController = @"SCRDefaultMapViewController",
    .HeatMapViewController = @"SCRHeatMapViewController",
};

const struct SCRCoreDataNames SCRCoreData = {
    .SqliteDatabaseName = @"ScrapHeap.sqlite",
    .ModelName = @"ScrapHeap",
};
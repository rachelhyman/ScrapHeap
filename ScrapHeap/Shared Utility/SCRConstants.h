//
//  SCRConstants.h
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/29/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import <Foundation/Foundation.h>

///Notification name constants
FOUNDATION_EXPORT const struct SCRNotificationNames {
    __unsafe_unretained NSString *DidToggleToDefaultMap;
    __unsafe_unretained NSString *DidToggleToHeatMap;
} SCRNotification;

///Storyboard name constants
FOUNDATION_EXPORT const struct SCRStoryboardIdentifiers {
    __unsafe_unretained NSString *DefaultMapViewController;
    __unsafe_unretained NSString *HeatMapViewController; 
} SCRStoryboardIdentifier;
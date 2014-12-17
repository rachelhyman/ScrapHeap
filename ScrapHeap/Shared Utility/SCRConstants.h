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
    __unsafe_unretained NSString *StoryboardName;
    __unsafe_unretained NSString *DefaultMapViewController;
    __unsafe_unretained NSString *HeatMapViewController;
    __unsafe_unretained NSString *AnnotationDetailViewController;
    __unsafe_unretained NSString *AnnotationDetailTableViewCellIdentifier;
    __unsafe_unretained NSString *AnnotationDetailCell; 
} SCRStoryboardIdentifier;

///Core data constants
FOUNDATION_EXPORT const struct SCRCoreDataNames {
    __unsafe_unretained NSString *SqliteDatabaseName;
    __unsafe_unretained NSString *ModelName;
    __unsafe_unretained NSString *DatabaseResourceName;
    __unsafe_unretained NSString *DatabaseResourceFileExtension;
} SCRCoreData;

///Buckets for relative # of violations for map annotations
typedef NS_ENUM(NSInteger, SCRAnnotationType) {
    SCRFewAnnotation,
    SCRSomeAnnotation,
    SCRManyAnnotation,
};

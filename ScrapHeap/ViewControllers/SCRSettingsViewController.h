//
//  SCRSettingsViewController.h
//  ScrapHeap
//
//  Created by Rachel Hyman on 2/19/15.
//  Copyright (c) 2015 Rachel Hyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCRSettingsDelegate <NSObject>

- (void)didChangeNumberOfViolationsToDisplay:(NSInteger)numberOfViolations;
- (void)didChangeClusteringEnabled:(BOOL)clusteringEnabled;
- (void)didChangeDateToDisplayViolationsOnOrAfter:(NSDate *)dateToDisplayViolationsOnOrAfter;

@end

@interface SCRSettingsViewController : UIViewController

@property (nonatomic, strong) id<SCRSettingsDelegate> settingsDelegate;

@end

//
//  SCRContainerMapViewController.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/29/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRContainerMapViewController.h"

@interface SCRContainerMapViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapToggle;

@end

@implementation SCRContainerMapViewController

- (IBAction)didToggleMap:(id)sender
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    if (self.mapToggle.selectedSegmentIndex == 0) {
        [notificationCenter postNotificationName:SCRNotification.DidToggleToDefaultMap object:nil];
    } else {
         [notificationCenter postNotificationName:SCRNotification.DidToggleToHeatMap object:nil];
    }
}

@end

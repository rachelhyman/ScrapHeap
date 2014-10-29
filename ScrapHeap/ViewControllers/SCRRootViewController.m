//
//  SCRRootViewController.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/29/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRRootViewController.h"
#import "SCRContainerMapViewController.h"

@implementation SCRRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(didToggleToDefaultMap:)
                               name:SCRNotification.DidToggleToDefaultMap
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(didToggleToHeatMap:)
                               name:SCRNotification.DidToggleToHeatMap
                             object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification observers

- (void)didToggleToDefaultMap:(NSNotification *)note
{
    [self switchToChildViewControllerWithStoryboardIdentifier:SCRStoryboardIdentifier.DefaultMapViewController];
}

- (void)didToggleToHeatMap:(NSNotification *)note
{
    [self switchToChildViewControllerWithStoryboardIdentifier:SCRStoryboardIdentifier.HeatMapViewController];
}

- (void)switchToChildViewControllerWithStoryboardIdentifier:(NSString *)identifier
{
    UIViewController *rootVC = self.viewControllers.firstObject;
    NSAssert(([rootVC isKindOfClass:[SCRContainerMapViewController class]]), @"root view controller is not kind of SCRContainerMapViewController class");
    SCRContainerMapViewController *containerMapViewController = (SCRContainerMapViewController *)rootVC;
    
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [containerMapViewController addChildViewController:newViewController];
    [containerMapViewController.containerView addSubview:newViewController.view];
    [newViewController didMoveToParentViewController:containerMapViewController];
    
}

@end

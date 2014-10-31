//
//  SCRTabBarController.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/31/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRTabBarController.h"
#import "SCRRootViewController.h"

@implementation SCRTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpTabBarControllerDelegate];
}

- (void)setUpTabBarControllerDelegate
{
    UIViewController *rootVC = self.viewControllers.firstObject;
    NSAssert([rootVC isKindOfClass:[SCRRootViewController class]], @"root view controller is not kind of SCRRootViewController class");
    self.delegate = (SCRRootViewController *)rootVC;
}

@end

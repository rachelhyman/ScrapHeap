//
//  SCRTabBarController.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/31/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRTabBarController.h"

#import "SCRRootViewController.h"
#import "SCRCoreDataUtility.h"

@implementation SCRTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SCRCoreDataUtility getTestViolations]; 
}

@end

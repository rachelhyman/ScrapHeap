//
//  SCRTabBarController.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/31/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRTabBarController.h"

#import "SCRCoreDataUtility.h"

@interface SCRTabBarController ()  <UITabBarControllerDelegate>

@end

@implementation SCRTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [SCRCoreDataUtility getTestViolations]; 
}

@end

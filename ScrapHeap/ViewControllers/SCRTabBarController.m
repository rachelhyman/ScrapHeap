//
//  SCRTabBarController.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 10/31/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRTabBarController.h"

#import "SCRCoreDataUtility.h"
#import "SCRNetworking.h"

@interface SCRTabBarController ()  <UITabBarControllerDelegate>

@property (nonatomic, weak) UIActivityIndicatorView *progressSpinner;

@end

@implementation SCRTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [self addProgressSpinner];
    [self.progressSpinner startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SCRNetworking getViolationsWithinUpperLeft:UpperLeft23rdAndHalstedCoord
                                         lowerRight:LowerRight95thAndLakeCoord
                                 numberOfViolations:1000
                                  completionHandler:^{
                                      [self.progressSpinner stopAnimating];
                                  }];
    });
}

- (void)addProgressSpinner
{
    UIActivityIndicatorView *progressSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.progressSpinner = progressSpinner;
    progressSpinner.frame = CGRectMake(0, 0, 70.0, 70.0);
    progressSpinner.backgroundColor = [UIColor lightGrayColor];
    progressSpinner.center = self.view.center;
    [self.view addSubview:progressSpinner];
}

@end

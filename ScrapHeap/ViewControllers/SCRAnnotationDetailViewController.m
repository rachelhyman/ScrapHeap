//
//  SCRAnnotationDetailViewController.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 11/18/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRAnnotationDetailViewController.h"

#import "SCRAnnotationDetailDataSource.h"
#import "SCRViolation.h"
#import "SCRBuilding.h"

@interface SCRAnnotationDetailViewController () <VOKFetchedResultsDataSourceDelegate>

@property (nonatomic, strong) SCRAnnotationDetailDataSource *dataSource;

@end

@implementation SCRAnnotationDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    [self setUpDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationItem.title = self.building.address;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES; 
}

- (void)setUpDataSource
{
    self.dataSource = [[SCRAnnotationDetailDataSource alloc] initWithPredicate:[SCRViolation violationsForBuilding:self.building]
                                                                     cacheName:nil
                                                                     tableView:self.tableView
                                                            sectionNameKeyPath:nil
                                                               sortDescriptors:[SCRViolation defaultSortDescriptors]
                                                            managedObjectClass:[SCRViolation class]];
    
    self.dataSource.delegate = self;
}

@end

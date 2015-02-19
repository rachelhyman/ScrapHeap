//
//  SCRSettingsViewController.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 2/19/15.
//  Copyright (c) 2015 Rachel Hyman. All rights reserved.
//

#import "SCRSettingsViewController.h"
#import "SCRMapViewController.h"

@interface SCRSettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *clusteringSwitch;
@property (weak, nonatomic) IBOutlet UISlider *violationsSlider;
@property (weak, nonatomic) IBOutlet UILabel *sliderCurrentNumberLabel;

@end

@implementation SCRSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(cancel)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                 target:self
                                                                                 action:@selector(saveSettings)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.sliderCurrentNumberLabel.text = [NSString stringWithFormat:@"%ld", lroundf(self.violationsSlider.value)];
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveSettings
{

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sliderValueDidChange:(id)sender
{
    self.sliderCurrentNumberLabel.text = [NSString stringWithFormat:@"%ld", lroundf(self.violationsSlider.value)];
}

@end

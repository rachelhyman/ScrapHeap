//
//  SCRSettingsViewController.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 2/19/15.
//  Copyright (c) 2015 Rachel Hyman. All rights reserved.
//

#import "SCRSettingsViewController.h"
#import "SCRMapViewController.h"
#import "SCRSettingsUtility.h"
#import "SCRNetworking.h"

@interface SCRSettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *clusteringSwitch;
@property (weak, nonatomic) IBOutlet UISlider *violationsSlider;
@property (weak, nonatomic) IBOutlet UILabel *sliderCurrentNumberLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) SCRSettingsUtility *settingsUtility;

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
    
    self.settingsUtility = [SCRSettingsUtility sharedUtility];
    
    if (self.settingsUtility.numberOfViolationsToDisplay) {
        self.violationsSlider.value = (float)self.settingsUtility.numberOfViolationsToDisplay;
        self.sliderCurrentNumberLabel.text = [NSString stringWithFormat:@"%ld", self.settingsUtility.numberOfViolationsToDisplay];
    } else {
        self.violationsSlider.value = [SCRNetworking defaultViolationsToFetch];
        self.sliderCurrentNumberLabel.text = [NSString stringWithFormat:@"%ld", [SCRNetworking defaultViolationsToFetch]];
    }
    
    [self.clusteringSwitch setOn:self.settingsUtility.clusteringEnabled];
    self.datePicker.maximumDate = [NSDate date];
    if (self.settingsUtility.dateToDisplayViolationsOnOrAfter) {
        self.datePicker.date = self.settingsUtility.dateToDisplayViolationsOnOrAfter;
    } else {
        self.datePicker.date = [NSDate date];
    }
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveSettings
{
    if (self.settingsDelegate) {
        if (self.clusteringSwitch.isOn != self.settingsUtility.clusteringEnabled) {
            [self.settingsDelegate didChangeClusteringEnabled:self.clusteringSwitch.isOn];
            self.settingsUtility.clusteringEnabled = self.clusteringSwitch.isOn;
        }
        if (((NSInteger)lroundf(self.violationsSlider.value)) != self.settingsUtility.numberOfViolationsToDisplay) {
            [self.settingsDelegate didChangeNumberOfViolationsToDisplay:((NSInteger)roundf(self.violationsSlider.value))];
            self.settingsUtility.numberOfViolationsToDisplay = lroundf(self.violationsSlider.value);
        }
        if (self.datePicker.date != self.settingsUtility.dateToDisplayViolationsOnOrAfter) {
            [self.settingsDelegate didChangeDateToDisplayViolationsOnOrAfter:self.datePicker.date];
            self.settingsUtility.dateToDisplayViolationsOnOrAfter = self.datePicker.date;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sliderValueDidChange:(id)sender
{
    self.sliderCurrentNumberLabel.text = [NSString stringWithFormat:@"%ld", lroundf(self.violationsSlider.value)];
}

@end

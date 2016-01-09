//
//  SCRAnnotationDetailCell.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 11/18/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRAnnotationDetailCell.h"

#import "SCRViolation.h"

@interface SCRAnnotationDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *violationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastModifiedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *inspectorCommentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *ordinanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation SCRAnnotationDetailCell

+ (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
    });
    return dateFormatter;
}

- (void)configureCellWithViolation:(SCRViolation *)violation
{
    self.violationDateLabel.text = [[[self class] sharedDateFormatter] stringFromDate:violation.violationDate];
    self.lastModifiedDateLabel.text = [[[self class] sharedDateFormatter] stringFromDate:violation.lastModifiedDate];
    self.descriptionLabel.text = violation.violationDescription;
    self.inspectorCommentsLabel.text = violation.inspectorComments;
    self.ordinanceLabel.text = violation.ordinance;
    self.statusLabel.text = violation.status;
    [self layoutIfNeeded];
}

@end

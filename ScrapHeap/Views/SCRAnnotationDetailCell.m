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

- (void)configureCellWithViolation:(SCRViolation *)violation
{
    self.violationDateLabel.text = [NSString stringWithFormat:@"%@", violation.violationDate];
    self.lastModifiedDateLabel.text = [NSString stringWithFormat:@"%@", violation.lastModifiedDate];
    self.descriptionLabel.text = violation.description;
    self.inspectorCommentsLabel.text = violation.inspectorComments;
    self.ordinanceLabel.text = violation.ordinance;
    self.statusLabel.text = violation.status;
}

@end

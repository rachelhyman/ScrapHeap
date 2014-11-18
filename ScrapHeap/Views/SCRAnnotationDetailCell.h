//
//  SCRAnnotationDetailCell.h
//  ScrapHeap
//
//  Created by Rachel Hyman on 11/18/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCRViolation;

@interface SCRAnnotationDetailCell : UITableViewCell

- (void)configureCellWithViolation:(SCRViolation *)violation; 

@end

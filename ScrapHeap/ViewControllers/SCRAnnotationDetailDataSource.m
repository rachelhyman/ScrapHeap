//
//  SCRAnnotationDetailDataSource.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 11/18/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SCRAnnotationDetailDataSource.h"
#import "SCRViolation.h"
#import "SCRBuilding.h"
#import "SCRAnnotationDetailCell.h"

@implementation SCRAnnotationDetailDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCRAnnotationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:SCRStoryboardIdentifier.AnnotationDetailTableViewCellIdentifier forIndexPath:indexPath];
    
    SCRViolation *violation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell configureCellWithViolation:violation];
    
    return cell;
}

@end

//
//  SCRCoreDataUtility.h
//  ScrapHeap
//
//  Created by Rachel Hyman on 11/3/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCRCoreDataUtility : NSObject

+ (void)resetCoreData; 
+ (void)setUpCoreData;
+ (void)loadDataFromArray:(NSArray *)array; 

@end

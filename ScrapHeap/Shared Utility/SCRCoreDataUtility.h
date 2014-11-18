//
//  SCRCoreDataUtility.h
//  ScrapHeap
//
//  Created by Rachel Hyman on 11/3/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCRCoreDataUtility : NSObject

///clears out core data and sets it up again
+ (void)resetCoreData;

///sets up core data with our sqlite database and model
+ (void)setUpCoreData;

///creates instances of the SCRViolation class using data from the given array
+ (void)loadDataFromArray:(NSArray *)array;

///loads test data from json
+ (void)getTestViolations;

+ (NSArray *)fetchAllBuildings; 

@end

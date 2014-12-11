//
//  SCRCoreDataUtility.h
//  ScrapHeap
//
//  Created by Rachel Hyman on 11/3/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SHQBasicCompletionHandler)(void);

@interface SCRCoreDataUtility : NSObject

///clears out core data and sets it up again
+ (void)resetCoreData;

///sets up core data with our sqlite database and model
+ (void)setUpCoreData;

///creates instances of the SCRViolation class using data from the given array
+ (void)loadDataFromArray:(NSArray *)array completion:(SHQBasicCompletionHandler)handler;

///loads test data from json
+ (void)getTestViolationsWithCompletion:(SHQBasicCompletionHandler)handler;

+ (NSArray *)fetchAllBuildings; 

@end

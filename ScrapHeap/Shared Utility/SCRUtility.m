//
//  SCRUtility.m
//  ScrapHeap
//
//  Created by Rachel Hyman on 2/22/15.
//  Copyright (c) 2015 Rachel Hyman. All rights reserved.
//

#import "SCRUtility.h"

@implementation SCRUtility

+ (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd'T'HH:mm:ss";
    });
    return dateFormatter;
}

@end

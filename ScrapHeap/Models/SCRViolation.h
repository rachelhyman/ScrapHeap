#import "_SCRViolation.h"

@class SCRBuilding;

@interface SCRViolation : _SCRViolation {}

+ (NSArray *)defaultSortDescriptors;
+ (NSPredicate *)predicateForViolationsForBuilding:(SCRBuilding *)building; 

@end

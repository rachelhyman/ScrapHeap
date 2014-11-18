#import "_SCRViolation.h"

@class SCRBuilding;

@interface SCRViolation : _SCRViolation {}

+ (NSArray *)defaultSortDescriptors;
+ (NSPredicate *)violationsForBuilding:(SCRBuilding *)building; 

@end

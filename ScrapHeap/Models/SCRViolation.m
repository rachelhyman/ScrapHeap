#import "SCRViolation.h"

#import "SCRBuilding.h"

@interface SCRViolation ()

@end

@implementation SCRViolation

+ (NSArray *)defaultSortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:SCRViolationAttributes.violationDate ascending:NO]];
}

+ (NSPredicate *)predicateForViolationsForBuilding:(SCRBuilding *)building
{
    return [NSPredicate predicateWithFormat:@"self IN %@", building.violations]; 
}

@end

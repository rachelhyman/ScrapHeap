#import "SCRBuilding.h"

@interface SCRBuilding ()

@end

@implementation SCRBuilding

- (CLLocationCoordinate2D )coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

+ (NSPredicate *)predicateForAddressMatchingString:(NSString *)string
{
    return  [NSPredicate predicateWithFormat:@"%K = %@", SCRBuildingAttributes.address, string];
}

+ (NSPredicate *)predicateForCommmunityAreaMatchingString:(NSString *)string
{
    return [NSPredicate predicateWithFormat:@"%K = %@", SCRBuildingAttributes.communityArea, string];
}

+ (NSPredicate *)predicateForBuildingForViolation:(SCRViolation *)violation
{
    return [NSPredicate predicateWithFormat:@"%@ IN self.violations", violation];
}

@end

#import "_SCRBuilding.h"

@import CoreLocation;

@class SCRViolation;

@interface SCRBuilding : _SCRBuilding {}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

+ (NSPredicate *)predicateForAddressMatchingString:(NSString *)string;

+ (NSPredicate *)predicateForCommmunityAreaMatchingString:(NSString *)string;

+ (NSPredicate *)predicateForBuildingForViolation:(SCRViolation *)violation;

@end

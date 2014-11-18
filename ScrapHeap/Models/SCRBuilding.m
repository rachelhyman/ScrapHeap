#import "SCRBuilding.h"

@interface SCRBuilding ()

@end

@implementation SCRBuilding

- (CLLocationCoordinate2D )coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

@end

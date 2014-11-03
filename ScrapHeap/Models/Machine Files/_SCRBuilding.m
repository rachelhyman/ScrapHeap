// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SCRBuilding.m instead.

#import "_SCRBuilding.h"

const struct SCRBuildingAttributes SCRBuildingAttributes = {
	.sAddress = @"sAddress",
	.sCommunityArea = @"sCommunityArea",
	.sLatitude = @"sLatitude",
	.sLongitude = @"sLongitude",
};

const struct SCRBuildingRelationships SCRBuildingRelationships = {
	.violations = @"violations",
};

@implementation SCRBuildingID
@end

@implementation _SCRBuilding

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SCRBuilding" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SCRBuilding";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SCRBuilding" inManagedObjectContext:moc_];
}

- (SCRBuildingID*)objectID {
	return (SCRBuildingID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"sLatitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sLatitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sLongitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sLongitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic sAddress;

@dynamic sCommunityArea;

@dynamic sLatitude;

- (double)sLatitudeValue {
	NSNumber *result = [self sLatitude];
	return [result doubleValue];
}

- (void)setSLatitudeValue:(double)value_ {
	[self setSLatitude:@(value_)];
}

- (double)primitiveSLatitudeValue {
	NSNumber *result = [self primitiveSLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveSLatitudeValue:(double)value_ {
	[self setPrimitiveSLatitude:@(value_)];
}

@dynamic sLongitude;

- (double)sLongitudeValue {
	NSNumber *result = [self sLongitude];
	return [result doubleValue];
}

- (void)setSLongitudeValue:(double)value_ {
	[self setSLongitude:@(value_)];
}

- (double)primitiveSLongitudeValue {
	NSNumber *result = [self primitiveSLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveSLongitudeValue:(double)value_ {
	[self setPrimitiveSLongitude:@(value_)];
}

@dynamic violations;

- (NSMutableSet*)violationsSet {
	[self willAccessValueForKey:@"violations"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"violations"];

	[self didAccessValueForKey:@"violations"];
	return result;
}

@end


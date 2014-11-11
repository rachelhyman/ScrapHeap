// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SCRBuilding.m instead.

#import "_SCRBuilding.h"

const struct SCRBuildingAttributes SCRBuildingAttributes = {
	.address = @"address",
	.communityArea = @"communityArea",
	.latitude = @"latitude",
	.longitude = @"longitude",
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

	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic address;

@dynamic communityArea;

@dynamic latitude;

- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:@(value_)];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:@(value_)];
}

@dynamic longitude;

- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:@(value_)];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:@(value_)];
}

@dynamic violations;

- (NSMutableSet*)violationsSet {
	[self willAccessValueForKey:@"violations"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"violations"];

	[self didAccessValueForKey:@"violations"];
	return result;
}

@end


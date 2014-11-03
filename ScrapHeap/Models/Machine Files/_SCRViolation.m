// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SCRViolation.m instead.

#import "_SCRViolation.h"

const struct SCRViolationAttributes SCRViolationAttributes = {
	.sDescription = @"sDescription",
	.sID = @"sID",
	.sInspectorComments = @"sInspectorComments",
	.sLastModifiedDate = @"sLastModifiedDate",
	.sOrdinance = @"sOrdinance",
	.sStatus = @"sStatus",
	.sViolationDate = @"sViolationDate",
};

const struct SCRViolationRelationships SCRViolationRelationships = {
	.building = @"building",
};

@implementation SCRViolationID
@end

@implementation _SCRViolation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SCRViolation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SCRViolation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SCRViolation" inManagedObjectContext:moc_];
}

- (SCRViolationID*)objectID {
	return (SCRViolationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic sDescription;

@dynamic sID;

@dynamic sInspectorComments;

@dynamic sLastModifiedDate;

@dynamic sOrdinance;

@dynamic sStatus;

@dynamic sViolationDate;

@dynamic building;

@end


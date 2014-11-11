// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SCRViolation.m instead.

#import "_SCRViolation.h"

const struct SCRViolationAttributes SCRViolationAttributes = {
	.inspectorComments = @"inspectorComments",
	.lastModifiedDate = @"lastModifiedDate",
	.ordinance = @"ordinance",
	.status = @"status",
	.violationDate = @"violationDate",
	.violationDescription = @"violationDescription",
	.violationID = @"violationID",
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

@dynamic inspectorComments;

@dynamic lastModifiedDate;

@dynamic ordinance;

@dynamic status;

@dynamic violationDate;

@dynamic violationDescription;

@dynamic violationID;

@dynamic building;

@end


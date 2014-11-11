// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SCRBuilding.h instead.

@import CoreData;

extern const struct SCRBuildingAttributes {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *communityArea;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
} SCRBuildingAttributes;

extern const struct SCRBuildingRelationships {
	__unsafe_unretained NSString *violations;
} SCRBuildingRelationships;

@class SCRViolation;

@interface SCRBuildingID : NSManagedObjectID {}
@end

@interface _SCRBuilding : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SCRBuildingID* objectID;

@property (nonatomic, strong) NSString* address;

//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* communityArea;

//- (BOOL)validateCommunityArea:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* latitude;

@property (atomic) double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* longitude;

@property (atomic) double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *violations;

- (NSMutableSet*)violationsSet;

@end

@interface _SCRBuilding (ViolationsCoreDataGeneratedAccessors)
- (void)addViolations:(NSSet*)value_;
- (void)removeViolations:(NSSet*)value_;
- (void)addViolationsObject:(SCRViolation*)value_;
- (void)removeViolationsObject:(SCRViolation*)value_;

@end

@interface _SCRBuilding (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;

- (NSString*)primitiveCommunityArea;
- (void)setPrimitiveCommunityArea:(NSString*)value;

- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;

- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;

- (NSMutableSet*)primitiveViolations;
- (void)setPrimitiveViolations:(NSMutableSet*)value;

@end

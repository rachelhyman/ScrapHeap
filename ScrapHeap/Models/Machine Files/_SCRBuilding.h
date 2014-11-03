// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SCRBuilding.h instead.

@import CoreData;

extern const struct SCRBuildingAttributes {
	__unsafe_unretained NSString *sAddress;
	__unsafe_unretained NSString *sCommunityArea;
	__unsafe_unretained NSString *sLatitude;
	__unsafe_unretained NSString *sLongitude;
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

@property (nonatomic, strong) NSString* sAddress;

//- (BOOL)validateSAddress:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* sCommunityArea;

//- (BOOL)validateSCommunityArea:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* sLatitude;

@property (atomic) double sLatitudeValue;
- (double)sLatitudeValue;
- (void)setSLatitudeValue:(double)value_;

//- (BOOL)validateSLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* sLongitude;

@property (atomic) double sLongitudeValue;
- (double)sLongitudeValue;
- (void)setSLongitudeValue:(double)value_;

//- (BOOL)validateSLongitude:(id*)value_ error:(NSError**)error_;

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

- (NSString*)primitiveSAddress;
- (void)setPrimitiveSAddress:(NSString*)value;

- (NSString*)primitiveSCommunityArea;
- (void)setPrimitiveSCommunityArea:(NSString*)value;

- (NSNumber*)primitiveSLatitude;
- (void)setPrimitiveSLatitude:(NSNumber*)value;

- (double)primitiveSLatitudeValue;
- (void)setPrimitiveSLatitudeValue:(double)value_;

- (NSNumber*)primitiveSLongitude;
- (void)setPrimitiveSLongitude:(NSNumber*)value;

- (double)primitiveSLongitudeValue;
- (void)setPrimitiveSLongitudeValue:(double)value_;

- (NSMutableSet*)primitiveViolations;
- (void)setPrimitiveViolations:(NSMutableSet*)value;

@end

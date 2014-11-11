// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SCRViolation.h instead.

@import CoreData;

extern const struct SCRViolationAttributes {
	__unsafe_unretained NSString *inspectorComments;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *ordinance;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *violationDate;
	__unsafe_unretained NSString *violationDescription;
	__unsafe_unretained NSString *violationID;
} SCRViolationAttributes;

extern const struct SCRViolationRelationships {
	__unsafe_unretained NSString *building;
} SCRViolationRelationships;

@class SCRBuilding;

@interface SCRViolationID : NSManagedObjectID {}
@end

@interface _SCRViolation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SCRViolationID* objectID;

@property (nonatomic, strong) NSString* inspectorComments;

//- (BOOL)validateInspectorComments:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* lastModifiedDate;

//- (BOOL)validateLastModifiedDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* ordinance;

//- (BOOL)validateOrdinance:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* status;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* violationDate;

//- (BOOL)validateViolationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* violationDescription;

//- (BOOL)validateViolationDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* violationID;

//- (BOOL)validateViolationID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) SCRBuilding *building;

//- (BOOL)validateBuilding:(id*)value_ error:(NSError**)error_;

@end

@interface _SCRViolation (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveInspectorComments;
- (void)setPrimitiveInspectorComments:(NSString*)value;

- (NSDate*)primitiveLastModifiedDate;
- (void)setPrimitiveLastModifiedDate:(NSDate*)value;

- (NSString*)primitiveOrdinance;
- (void)setPrimitiveOrdinance:(NSString*)value;

- (NSString*)primitiveStatus;
- (void)setPrimitiveStatus:(NSString*)value;

- (NSDate*)primitiveViolationDate;
- (void)setPrimitiveViolationDate:(NSDate*)value;

- (NSString*)primitiveViolationDescription;
- (void)setPrimitiveViolationDescription:(NSString*)value;

- (NSString*)primitiveViolationID;
- (void)setPrimitiveViolationID:(NSString*)value;

- (SCRBuilding*)primitiveBuilding;
- (void)setPrimitiveBuilding:(SCRBuilding*)value;

@end

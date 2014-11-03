// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SCRViolation.h instead.

@import CoreData;

extern const struct SCRViolationAttributes {
	__unsafe_unretained NSString *sDescription;
	__unsafe_unretained NSString *sID;
	__unsafe_unretained NSString *sInspectorComments;
	__unsafe_unretained NSString *sLastModifiedDate;
	__unsafe_unretained NSString *sOrdinance;
	__unsafe_unretained NSString *sStatus;
	__unsafe_unretained NSString *sViolationDate;
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

@property (nonatomic, strong) NSString* sDescription;

//- (BOOL)validateSDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* sID;

//- (BOOL)validateSID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* sInspectorComments;

//- (BOOL)validateSInspectorComments:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* sLastModifiedDate;

//- (BOOL)validateSLastModifiedDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* sOrdinance;

//- (BOOL)validateSOrdinance:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* sStatus;

//- (BOOL)validateSStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* sViolationDate;

//- (BOOL)validateSViolationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) SCRBuilding *building;

//- (BOOL)validateBuilding:(id*)value_ error:(NSError**)error_;

@end

@interface _SCRViolation (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveSDescription;
- (void)setPrimitiveSDescription:(NSString*)value;

- (NSString*)primitiveSID;
- (void)setPrimitiveSID:(NSString*)value;

- (NSString*)primitiveSInspectorComments;
- (void)setPrimitiveSInspectorComments:(NSString*)value;

- (NSDate*)primitiveSLastModifiedDate;
- (void)setPrimitiveSLastModifiedDate:(NSDate*)value;

- (NSString*)primitiveSOrdinance;
- (void)setPrimitiveSOrdinance:(NSString*)value;

- (NSString*)primitiveSStatus;
- (void)setPrimitiveSStatus:(NSString*)value;

- (NSDate*)primitiveSViolationDate;
- (void)setPrimitiveSViolationDate:(NSDate*)value;

- (SCRBuilding*)primitiveBuilding;
- (void)setPrimitiveBuilding:(SCRBuilding*)value;

@end

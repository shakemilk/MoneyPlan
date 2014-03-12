// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SHMProduct.h instead.

#import <CoreData/CoreData.h>


extern const struct SHMProductAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *quantity;
} SHMProductAttributes;

extern const struct SHMProductRelationships {
	__unsafe_unretained NSString *consumers;
	__unsafe_unretained NSString *event;
	__unsafe_unretained NSString *transaction;
} SHMProductRelationships;

extern const struct SHMProductFetchedProperties {
} SHMProductFetchedProperties;

@class SHMUser;
@class SHMEvent;
@class SHMTransaction;




@interface SHMProductID : NSManagedObjectID {}
@end

@interface _SHMProduct : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SHMProductID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* quantity;



@property int32_t quantityValue;
- (int32_t)quantityValue;
- (void)setQuantityValue:(int32_t)value_;

//- (BOOL)validateQuantity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *consumers;

- (NSMutableSet*)consumersSet;




@property (nonatomic, strong) SHMEvent *event;

//- (BOOL)validateEvent:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) SHMTransaction *transaction;

//- (BOOL)validateTransaction:(id*)value_ error:(NSError**)error_;





@end

@interface _SHMProduct (CoreDataGeneratedAccessors)

- (void)addConsumers:(NSSet*)value_;
- (void)removeConsumers:(NSSet*)value_;
- (void)addConsumersObject:(SHMUser*)value_;
- (void)removeConsumersObject:(SHMUser*)value_;

@end

@interface _SHMProduct (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveQuantity;
- (void)setPrimitiveQuantity:(NSNumber*)value;

- (int32_t)primitiveQuantityValue;
- (void)setPrimitiveQuantityValue:(int32_t)value_;





- (NSMutableSet*)primitiveConsumers;
- (void)setPrimitiveConsumers:(NSMutableSet*)value;



- (SHMEvent*)primitiveEvent;
- (void)setPrimitiveEvent:(SHMEvent*)value;



- (SHMTransaction*)primitiveTransaction;
- (void)setPrimitiveTransaction:(SHMTransaction*)value;


@end

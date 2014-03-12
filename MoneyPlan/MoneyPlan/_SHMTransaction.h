// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SHMTransaction.h instead.

#import <CoreData/CoreData.h>


extern const struct SHMTransactionAttributes {
	__unsafe_unretained NSString *price;
} SHMTransactionAttributes;

extern const struct SHMTransactionRelationships {
	__unsafe_unretained NSString *buyer;
	__unsafe_unretained NSString *event;
	__unsafe_unretained NSString *product;
} SHMTransactionRelationships;

extern const struct SHMTransactionFetchedProperties {
} SHMTransactionFetchedProperties;

@class SHMUser;
@class SHMEvent;
@class SHMProduct;



@interface SHMTransactionID : NSManagedObjectID {}
@end

@interface _SHMTransaction : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SHMTransactionID*)objectID;





@property (nonatomic, strong) NSNumber* price;



@property double priceValue;
- (double)priceValue;
- (void)setPriceValue:(double)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) SHMUser *buyer;

//- (BOOL)validateBuyer:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) SHMEvent *event;

//- (BOOL)validateEvent:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) SHMProduct *product;

//- (BOOL)validateProduct:(id*)value_ error:(NSError**)error_;





@end

@interface _SHMTransaction (CoreDataGeneratedAccessors)

@end

@interface _SHMTransaction (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSNumber*)value;

- (double)primitivePriceValue;
- (void)setPrimitivePriceValue:(double)value_;





- (SHMUser*)primitiveBuyer;
- (void)setPrimitiveBuyer:(SHMUser*)value;



- (SHMEvent*)primitiveEvent;
- (void)setPrimitiveEvent:(SHMEvent*)value;



- (SHMProduct*)primitiveProduct;
- (void)setPrimitiveProduct:(SHMProduct*)value;


@end

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SHMUser.h instead.

#import <CoreData/CoreData.h>


extern const struct SHMUserAttributes {
	__unsafe_unretained NSString *name;
} SHMUserAttributes;

extern const struct SHMUserRelationships {
	__unsafe_unretained NSString *event;
	__unsafe_unretained NSString *products;
	__unsafe_unretained NSString *transactions;
} SHMUserRelationships;

extern const struct SHMUserFetchedProperties {
} SHMUserFetchedProperties;

@class SHMEvent;
@class SHMProduct;
@class SHMTransaction;



@interface SHMUserID : NSManagedObjectID {}
@end

@interface _SHMUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SHMUserID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) SHMEvent *event;

//- (BOOL)validateEvent:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *products;

- (NSMutableSet*)productsSet;




@property (nonatomic, strong) NSSet *transactions;

- (NSMutableSet*)transactionsSet;





@end

@interface _SHMUser (CoreDataGeneratedAccessors)

- (void)addProducts:(NSSet*)value_;
- (void)removeProducts:(NSSet*)value_;
- (void)addProductsObject:(SHMProduct*)value_;
- (void)removeProductsObject:(SHMProduct*)value_;

- (void)addTransactions:(NSSet*)value_;
- (void)removeTransactions:(NSSet*)value_;
- (void)addTransactionsObject:(SHMTransaction*)value_;
- (void)removeTransactionsObject:(SHMTransaction*)value_;

@end

@interface _SHMUser (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (SHMEvent*)primitiveEvent;
- (void)setPrimitiveEvent:(SHMEvent*)value;



- (NSMutableSet*)primitiveProducts;
- (void)setPrimitiveProducts:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTransactions;
- (void)setPrimitiveTransactions:(NSMutableSet*)value;


@end

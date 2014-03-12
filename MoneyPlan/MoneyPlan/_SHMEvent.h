// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SHMEvent.h instead.

#import <CoreData/CoreData.h>


extern const struct SHMEventAttributes {
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *name;
} SHMEventAttributes;

extern const struct SHMEventRelationships {
	__unsafe_unretained NSString *products;
	__unsafe_unretained NSString *transactions;
	__unsafe_unretained NSString *users;
} SHMEventRelationships;

extern const struct SHMEventFetchedProperties {
} SHMEventFetchedProperties;

@class SHMProduct;
@class SHMTransaction;
@class SHMUser;




@interface SHMEventID : NSManagedObjectID {}
@end

@interface _SHMEvent : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SHMEventID*)objectID;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *products;

- (NSMutableSet*)productsSet;




@property (nonatomic, strong) NSSet *transactions;

- (NSMutableSet*)transactionsSet;




@property (nonatomic, strong) NSSet *users;

- (NSMutableSet*)usersSet;





@end

@interface _SHMEvent (CoreDataGeneratedAccessors)

- (void)addProducts:(NSSet*)value_;
- (void)removeProducts:(NSSet*)value_;
- (void)addProductsObject:(SHMProduct*)value_;
- (void)removeProductsObject:(SHMProduct*)value_;

- (void)addTransactions:(NSSet*)value_;
- (void)removeTransactions:(NSSet*)value_;
- (void)addTransactionsObject:(SHMTransaction*)value_;
- (void)removeTransactionsObject:(SHMTransaction*)value_;

- (void)addUsers:(NSSet*)value_;
- (void)removeUsers:(NSSet*)value_;
- (void)addUsersObject:(SHMUser*)value_;
- (void)removeUsersObject:(SHMUser*)value_;

@end

@interface _SHMEvent (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveProducts;
- (void)setPrimitiveProducts:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTransactions;
- (void)setPrimitiveTransactions:(NSMutableSet*)value;



- (NSMutableSet*)primitiveUsers;
- (void)setPrimitiveUsers:(NSMutableSet*)value;


@end

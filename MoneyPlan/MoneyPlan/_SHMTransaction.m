// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SHMTransaction.m instead.

#import "_SHMTransaction.h"

const struct SHMTransactionAttributes SHMTransactionAttributes = {
	.price = @"price",
};

const struct SHMTransactionRelationships SHMTransactionRelationships = {
	.buyer = @"buyer",
	.event = @"event",
	.product = @"product",
};

const struct SHMTransactionFetchedProperties SHMTransactionFetchedProperties = {
};

@implementation SHMTransactionID
@end

@implementation _SHMTransaction

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Transaction";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc_];
}

- (SHMTransactionID*)objectID {
	return (SHMTransactionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"priceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic price;



- (double)priceValue {
	NSNumber *result = [self price];
	return [result doubleValue];
}

- (void)setPriceValue:(double)value_ {
	[self setPrice:[NSNumber numberWithDouble:value_]];
}

- (double)primitivePriceValue {
	NSNumber *result = [self primitivePrice];
	return [result doubleValue];
}

- (void)setPrimitivePriceValue:(double)value_ {
	[self setPrimitivePrice:[NSNumber numberWithDouble:value_]];
}





@dynamic buyer;

	

@dynamic event;

	

@dynamic product;

	






@end

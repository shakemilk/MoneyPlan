// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SHMProduct.m instead.

#import "_SHMProduct.h"

const struct SHMProductAttributes SHMProductAttributes = {
	.name = @"name",
	.quantity = @"quantity",
};

const struct SHMProductRelationships SHMProductRelationships = {
	.consumers = @"consumers",
	.event = @"event",
	.transaction = @"transaction",
};

const struct SHMProductFetchedProperties SHMProductFetchedProperties = {
};

@implementation SHMProductID
@end

@implementation _SHMProduct

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Product";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Product" inManagedObjectContext:moc_];
}

- (SHMProductID*)objectID {
	return (SHMProductID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"quantityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"quantity"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic name;






@dynamic quantity;



- (int32_t)quantityValue {
	NSNumber *result = [self quantity];
	return [result intValue];
}

- (void)setQuantityValue:(int32_t)value_ {
	[self setQuantity:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveQuantityValue {
	NSNumber *result = [self primitiveQuantity];
	return [result intValue];
}

- (void)setPrimitiveQuantityValue:(int32_t)value_ {
	[self setPrimitiveQuantity:[NSNumber numberWithInt:value_]];
}





@dynamic consumers;

	
- (NSMutableSet*)consumersSet {
	[self willAccessValueForKey:@"consumers"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"consumers"];
  
	[self didAccessValueForKey:@"consumers"];
	return result;
}
	

@dynamic event;

	

@dynamic transaction;

	






@end

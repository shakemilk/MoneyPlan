// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SHMUser.m instead.

#import "_SHMUser.h"

const struct SHMUserAttributes SHMUserAttributes = {
	.name = @"name",
};

const struct SHMUserRelationships SHMUserRelationships = {
	.event = @"event",
	.products = @"products",
	.transactions = @"transactions",
};

const struct SHMUserFetchedProperties SHMUserFetchedProperties = {
};

@implementation SHMUserID
@end

@implementation _SHMUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (SHMUserID*)objectID {
	return (SHMUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic event;

	

@dynamic products;

	
- (NSMutableSet*)productsSet {
	[self willAccessValueForKey:@"products"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"products"];
  
	[self didAccessValueForKey:@"products"];
	return result;
}
	

@dynamic transactions;

	
- (NSMutableSet*)transactionsSet {
	[self willAccessValueForKey:@"transactions"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"transactions"];
  
	[self didAccessValueForKey:@"transactions"];
	return result;
}
	






@end

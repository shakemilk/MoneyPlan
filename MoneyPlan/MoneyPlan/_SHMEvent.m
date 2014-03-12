// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SHMEvent.m instead.

#import "_SHMEvent.h"

const struct SHMEventAttributes SHMEventAttributes = {
	.date = @"date",
	.name = @"name",
};

const struct SHMEventRelationships SHMEventRelationships = {
	.products = @"products",
	.transactions = @"transactions",
	.users = @"users",
};

const struct SHMEventFetchedProperties SHMEventFetchedProperties = {
};

@implementation SHMEventID
@end

@implementation _SHMEvent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Event";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Event" inManagedObjectContext:moc_];
}

- (SHMEventID*)objectID {
	return (SHMEventID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic date;






@dynamic name;






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
	

@dynamic users;

	
- (NSMutableSet*)usersSet {
	[self willAccessValueForKey:@"users"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"users"];
  
	[self didAccessValueForKey:@"users"];
	return result;
}
	






@end

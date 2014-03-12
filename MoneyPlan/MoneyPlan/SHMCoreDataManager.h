//
//  SHMCoreDataManager.h
//  MoneyPlan
//
//  Created by Mikhail Grushin on 12/03/14.
//  Copyright (c) 2014 Shakemilk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SHMCoreDataManager : NSObject

+ (NSManagedObjectContext *)mainContext;
+ (NSManagedObjectContext *)createUserContext;
+ (NSManagedObjectContext *)createBackendContext;
+ (NSManagedObjectContext *)createReadonlyContext;
+ (NSManagedObjectContext *)createTemporaryMainContext;
+ (NSPersistentStoreCoordinator *)mainPersistentStoreCoordinator;

@end

@interface NSManagedObjectContext (DVCoreDataManager)

- (void)performBlockAndSaveOrReset:(BOOL (^)(NSError *__autoreleasing *error))block completion:(void (^)(BOOL, NSError *))completion;
- (BOOL)performBlockAndSaveOrReset:(BOOL (^)(NSError *__autoreleasing *error))block error:(NSError *__autoreleasing *)error;

@end

//
//  SHMCoreDataManager.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 12/03/14.
//  Copyright (c) 2014 Shakemilk. All rights reserved.
//

#import "SHMCoreDataManager.h"
#import "SHMManagedObjectContext.h"

typedef NSString *const SHMManagedObjectContextType;
static NSString *const kManagedObjectsDatabaseName = @"SHMManagedObjectsDatabaseName";
static const NSString *DVManagedObjectContextTypeKey = @"DVManagedObjectContextTypeKey";
static SHMManagedObjectContextType DVManagedObjectContextTypeUser = @"DVManagedObjectContextUser";
static SHMManagedObjectContextType DVManagedObjectContextTypeBackend = @"DVManagedObjectContextTypeBackend";
static SHMManagedObjectContextType DVManagedObjectContextTypeReadonly = @"DVManagedObjectContextTypeReadonly";

@interface SHMCoreDataManager()
+ (NSURL *)sqliteStoreURL;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *mainPersistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectContext *userContext;
@property (nonatomic, strong) NSManagedObjectContext *backendContext;
@end

@implementation SHMCoreDataManager

+ (SHMCoreDataManager *)sharedInstance {
    static dispatch_once_t onceToken;
    __strong static SHMCoreDataManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[SHMCoreDataManager alloc] init];
    });
    
    return manager;
}

+ (NSURL *)sqliteStoreURL {
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *databaseName = appInfo[kManagedObjectsDatabaseName];
    
    NSError *error;
    NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    
    return [path URLByAppendingPathComponent:databaseName];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (! _managedObjectModel) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)mainPersistentStoreCoordinator
{
    @synchronized(self) {
        if (! _mainPersistentStoreCoordinator) {
            NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
            
            NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption: @(YES),
                                       NSInferMappingModelAutomaticallyOption: @(YES) };
            
            NSError *error = nil;
            if (! [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[[self class] sqliteStoreURL] options:options error:&error]) {
                if (error) {
                    NSLog(@"Error while adding persistent store : %@", error.localizedDescription);
                }
                _mainPersistentStoreCoordinator = nil;
            }
            else {
                _mainPersistentStoreCoordinator = coordinator;
            }
        }
    }
    
    return _mainPersistentStoreCoordinator;
}

- (NSManagedObjectContext *)mainContext {
    @synchronized(self) {
        if (!_mainContext) {
            NSManagedObjectContext *context = [[SHMManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            context.undoManager = nil;
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
            context.persistentStoreCoordinator = self.mainPersistentStoreCoordinator;
            context.stalenessInterval = 0;
            (context.userInfo)[DVManagedObjectContextTypeKey] = DVManagedObjectContextTypeUser;
            [self addObserversForContext:context];
            
            _mainContext = context;
        }
    }
        
    return _mainContext;
}

- (NSManagedObjectContext *)userContext
{
    if (! _userContext) {
        _userContext = [self createUserContext];
    }
    
    return _userContext;
}

- (NSManagedObjectContext *)backendContext
{
    if (! _backendContext) {
        _backendContext = [self createBackendContext];
    }
    
    return _backendContext;
}

- (NSManagedObjectContext *)createBackendContext
{
    NSManagedObjectContext *context = [[SHMManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.undoManager = nil;
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    context.persistentStoreCoordinator = self.mainPersistentStoreCoordinator;
    (context.userInfo)[DVManagedObjectContextTypeKey] = DVManagedObjectContextTypeBackend;
    [self addObserversForContext:context];
    
    return context;
}

- (NSManagedObjectContext *)createUserContext
{
    NSManagedObjectContext *context = [[SHMManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.undoManager = nil;
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    context.persistentStoreCoordinator = self.mainPersistentStoreCoordinator;
    (context.userInfo)[DVManagedObjectContextTypeKey] = DVManagedObjectContextTypeUser;
    [self addObserversForContext:context];
    
    return context;
}

- (NSManagedObjectContext *)createReadonlyContext
{
    NSManagedObjectContext *context = [[SHMManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.undoManager = nil;
    context.mergePolicy = NSErrorMergePolicy;
    context.persistentStoreCoordinator = self.mainPersistentStoreCoordinator;
    (context.userInfo)[DVManagedObjectContextTypeKey] = DVManagedObjectContextTypeReadonly;
    [self addObserversForContext:context];
    
    return context;
}

- (NSManagedObjectContext *)createTemporaryMainContext
{
    NSManagedObjectContext *context = [[SHMManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.undoManager = nil;
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    context.persistentStoreCoordinator = self.mainPersistentStoreCoordinator;
    context.stalenessInterval = 0;
    (context.userInfo)[DVManagedObjectContextTypeKey] = DVManagedObjectContextTypeUser;
    [self addObserversForContext:context];
    
    return context;
}
    
#pragma mark - Notifications
    
- (void)addObserversForContext:(NSManagedObjectContext *)context
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:context];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextWillSaveNotification:) name:NSManagedObjectContextWillSaveNotification object:context];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextWillDeallocateNotification:) name:SHMManagedObjectContextWillDeallocateNotification object:context];
}

- (void)removeObserversForContext:(NSManagedObjectContext *)context
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHMManagedObjectContextWillDeallocateNotification object:context];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextWillSaveNotification object:context];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:context];
}

- (void)contextWillDeallocateNotification:(NSNotification *)notification
{
    NSManagedObjectContext *context = [notification object];
    
    [self removeObserversForContext:context];
}

- (void)contextDidSaveNotification:(NSNotification *)notification
{
    NSManagedObjectContext *context = [notification object];
    if (context == _mainContext) {
        //
    }
    else if (context.persistentStoreCoordinator == _mainPersistentStoreCoordinator) {
        // background context
        
        [_mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:) withObject:notification waitUntilDone:NO];
    }
}

- (void)contextWillSaveNotification:(NSNotification *)notification {
    
}
    
#pragma mark - Public Shortcuts
    
+ (NSManagedObjectContext *)mainContext
{
    return [self sharedInstance].mainContext;
}

+ (NSManagedObjectContext *)createBackendContext
{
    return [self sharedInstance].backendContext;
}

+ (NSManagedObjectContext *)createUserContext
{
    return [self sharedInstance].userContext;
}

+ (NSManagedObjectContext *)createReadonlyContext
{
    return [[self sharedInstance] createReadonlyContext];
}

+ (NSManagedObjectContext *)createTemporaryMainContext
{
    return [[self sharedInstance] createTemporaryMainContext];
}

+ (NSPersistentStoreCoordinator *)mainPersistentStoreCoordinator
{
    return [[self sharedInstance] mainPersistentStoreCoordinator];
}

@end

@implementation NSManagedObjectContext (DVCoreDataManager)

- (void)performBlockAndSaveOrReset:(BOOL (^)(NSError *__autoreleasing *))block completion:(void (^)(BOOL, NSError *))completion
{
//    NSArray *callStack = [NSThread callStackSymbols];
    
    [self performBlock:^{
        NSError *blockError;
        BOOL blockOk = block(&blockError);
        if (! blockOk) {
            [self reset];
            if (completion) completion(blockOk, blockError);
            return;
        }
        
        if (! [self hasChanges]) {
            if (completion) completion(YES, nil);
            return;
        }
        
        NSError *saveError;
        BOOL saveOk = [self save:&saveError];
        if (! saveOk) {
            [self reset];
            if (completion) completion(saveOk, saveError);
            return;
        }
        
        if (completion) completion(YES, nil);
    }];
}

- (BOOL)performBlockAndSaveOrReset:(BOOL (^)(NSError *__autoreleasing *))block error:(NSError *__autoreleasing *)error
{
    __block BOOL blockOk;
    __block NSError *blockError;
    __block BOOL saveOk;
    __block NSError *saveError;
    [self performBlockAndWait:^{
        blockOk = block(&blockError);
        if (! blockOk) {
            [self reset];
            return;
        }
        
        if (! [self hasChanges]) {
            saveOk = YES;
            return;
        }
        
        saveOk = [self save:&saveError];
        if (! saveOk) {
            [self reset];
            return;
        }
    }];
    
    if (error) {
        *error = blockError ?: saveError;
    }
    
    return blockOk && saveOk;
}

@end

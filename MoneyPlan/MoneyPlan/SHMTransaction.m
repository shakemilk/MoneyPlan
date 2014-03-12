#import "SHMTransaction.h"


@interface SHMTransaction ()

// Private interface goes here.

@end


@implementation SHMTransaction

+ (NSFetchRequest *)transactionsFetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:[SHMTransaction entityName]];
}

@end

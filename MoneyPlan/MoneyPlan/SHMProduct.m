#import "SHMProduct.h"


@interface SHMProduct ()

// Private interface goes here.

@end


@implementation SHMProduct

+ (NSFetchRequest *)productsFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[SHMProduct entityName]];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return fetchRequest;
}

@end

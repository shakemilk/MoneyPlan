#import "SHMEvent.h"


@interface SHMEvent ()

// Private interface goes here.

@end


@implementation SHMEvent

+ (NSFetchRequest *)eventsFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[SHMEvent entityName]];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    return fetchRequest;
}

@end

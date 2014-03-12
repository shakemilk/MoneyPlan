#import "SHMUser.h"


@interface SHMUser ()

// Private interface goes here.

@end


@implementation SHMUser

+ (NSFetchRequest *)usersFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[SHMUser entityName]];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return fetchRequest;
}

@end

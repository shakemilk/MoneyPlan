//
//  SHMManagedObjectContext.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 12/03/14.
//  Copyright (c) 2014 Shakemilk. All rights reserved.
//

#import "SHMManagedObjectContext.h"

NSString *const SHMManagedObjectContextWillDeallocateNotification = @"SHMManagedObjectContextWillDeallocateNotification";

@implementation SHMManagedObjectContext

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHMManagedObjectContextWillDeallocateNotification object:self];
}

@end

//
//  SHMCalculationModule.m
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 29.08.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//
// нужно получать данные в следующем формате:
// заплаченная сумма и соответствующий ей NSDictionary из participantID и флага - 0/1.
// у каждой транзакции должен быть ID
// можно сделать receiveTransactionsOfPerson и receivePersonTransactionsDetails

// сумма транзакции делится на число ненулевых флагов и каждая из частей прибавляется к соответствующему участнику
// должен быть массив сумм для каждого участника. Массив состоит из NSValue (NSNumber)
#warning TODO посмотреть размер NSValue (NSNumber), какие числа он может вмещать
//это должен быть NSDictionary, где ключ - имя или ID, а значение - массив из NSValue
#warning может все-таки Core Data?
//итоговый долг между людьми разрешается следующим образом:
//долг 1го 2му - долг 2го первому. Если > 0, 1ый платит разницу, 2ой ничего. Если < 0, наоборот



#import "SHMCalculationModule.h"

@interface SHMCalculationModule()

@property (nonatomic, weak) NSDictionary* namesOfParticipantsWithId;


@end

@implementation SHMCalculationModule

+ ( SHMCalculationModule* ) sharedInstance
{
    static SHMCalculationModule* sMySingleton = nil;
    
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        sMySingleton = [ [ self alloc ] init ];
    } );
    
    return sMySingleton;
}

-(NSDictionary *) getTransactionsOfPerson: (NSString *) Person
//вот этот метод должен быть в контроллере списка покупок
{
    
}

- (NSValue *) debtOfPerson:(NSString *)debtor toPerson:(NSString *)owner
{
    
}


- (NSValue *) debtOfPersonWithId:(NSInteger)debtorId toPersonWithId:(NSInteger)ownerId
{
    
}




@end

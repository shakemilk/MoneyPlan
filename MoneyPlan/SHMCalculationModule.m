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

@property (nonatomic, strong) NSMutableDictionary* namesOfParticipantsWithId;
@property (nonatomic, strong) NSDictionary* eventTable; //царь-таблица. Здесь транзакции ВСЕХ участников. Ключ - имя участника. вернет dictionary по ключу


@end

@implementation SHMCalculationModule


- (NSDictionary *) namesOfParticipantsWithId{
    if (_namesOfParticipantsWithId == nil) {
        
#warning TODO change when Core Data is implemented
        NSArray *names = [NSArray arrayWithObjects:@"Nadezhda Shmakova", @"Mikhail Grushin", @"Andrey Oveshnikov", @"Mikhail Pogosskiy", nil];
        NSInteger num = 0;
        NSArray *keys = [NSArray arrayWithObjects:[NSNumber numberWithInteger:num],[NSNumber numberWithInteger:num+1],[NSNumber  numberWithInteger:num+2],[NSNumber numberWithInteger:num+3], nil];
//change until here
        
        _namesOfParticipantsWithId =  [[NSMutableDictionary alloc] initWithObjects:keys forKeys:names];
    }
    
    return _namesOfParticipantsWithId;
}


- (NSDictionary *) eventTable{
    if (_eventTable == nil)
    {
        NSURL *urlForPlist = [[NSBundle mainBundle] URLForResource:@"TempListForGettingTransactions" withExtension:@"plist"];
        _eventTable = [[NSDictionary alloc] initWithContentsOfURL:urlForPlist];
    }
    
    return _eventTable;
}

#pragma mark -
#pragma mark Temporary methods before Core Data


-(NSArray *) getTransactionsOfPerson: (NSString *) Person
//читает транзакции человека из базы
{
    
    NSArray *transactionsOfPerson = [[NSArray alloc] initWithArray:[self.eventTable valueForKey:Person]];
    //если такого человека нет, то это ненормально и мы должны здесь падать. Имя Person формируется программой
    return transactionsOfPerson;
}



#pragma mark -
#pragma mark Singleton

+ ( SHMCalculationModule* ) sharedInstance
{
    static SHMCalculationModule* sMySingleton = nil;
    
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        sMySingleton = [ [ self alloc ] init ];
    } );
    
    return sMySingleton;
}


- (NSNumber *) summTransactionsMadeByPerson: (NSString *) Person forDebtor: (NSString *) Debtor
//метод проходит по всем транзакциям, сделанным Person и смотрит, в каких из них участвует Debtor.
//Возвращает сумму частей этих транзакций, относящихся к Debtor
{
    NSArray *TransactionsMadeByPerson = [NSArray arrayWithArray:[self.eventTable valueForKey:Person]];
    
    double Summ = 0.0;
    NSNumber *DebtorKey = [self.namesOfParticipantsWithId valueForKey:Debtor];
    
    for (NSDictionary *transaction in TransactionsMadeByPerson) {
        double Expense = [[transaction objectForKey:@"SelfExpense"] doubleValue];
        NSDictionary *Flags = [transaction objectForKey:@"Flags"];
        
        NSInteger numberOfParts = 0;
        for (NSString *key in Flags) {
            if ([[Flags objectForKey:key] boolValue] == YES)
                numberOfParts++;
        }
        
        double EachPersonDebt = Expense/(double)numberOfParts;
#warning чем грозит преобразование типа в стиле C?
        Summ += EachPersonDebt*[[Flags valueForKey:[DebtorKey stringValue]] boolValue];
    }
    
    return [[NSNumber alloc] initWithDouble:Summ];
}


- (NSNumber *) debtOfPerson:(NSString *)debtor toPerson:(NSString *)owner
{
    NSNumber *DebtorToOwner = [self summTransactionsMadeByPerson:owner forDebtor:debtor];
    NSNumber *OwnerToDebtor = [self summTransactionsMadeByPerson:debtor forDebtor:owner];
    
    return ([DebtorToOwner doubleValue] - [OwnerToDebtor doubleValue]) > 0? DebtorToOwner: [[NSNumber alloc] initWithDouble:0.0];
}


/*- (NSNumber *) debtOfPersonWithId:(NSInteger)debtorId toPersonWithId:(NSInteger)ownerId
{
    
}
*/
@end

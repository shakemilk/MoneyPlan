//
//  SHMCalculationModule.h
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 29.08.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

//Внутри нужны
// 1) массив имен
// 2) данные о транзакциях, которые будут периодически обновляться
//

// нужны методы для:
// 1) расчета для одного участника
// 2) получения транзакций, проведенных конкретным человеком - метод должен быть в классе списка покупок
// 

#import <Foundation/Foundation.h>

@interface SHMCalculationModule : NSObject

+ ( SHMCalculationModule* ) sharedInstance;
- (NSNumber *) debtOfPerson: (NSString *) debtor toPerson: (NSString *)owner;
//- (NSNumber *) debtOfPersonWithId: (NSInteger) debtorId toPersonWithId: (NSInteger)ownerId; //нужно вообще?
-(NSArray *) getNamesOfParticipants;


@end

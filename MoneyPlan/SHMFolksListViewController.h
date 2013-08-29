//
//  SHMFolksListViewController.h
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 24.08.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHMFolksListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

- (NSArray *)getNamesOfParticipants;
- (NSDictionary *)getNamesOfParticipantsWithNumbers;
- (NSInteger)getParticipantNumberForName: (NSString *) Name;
-(void)addNewFriendWithMaxNumberAndName:(NSString *)name;

@end

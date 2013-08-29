//
//  SHMFolksListViewController.h
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 24.08.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHMFolksListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableDictionary *folksNamesDictionary; //имена участников. Состоит из имени участника (Key) и присвоенного ему номера (Value)

-(void)addNewFriendWithMaxNumberAndName:(NSString *)name;

@end

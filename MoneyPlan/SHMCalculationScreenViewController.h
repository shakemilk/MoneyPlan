//
//  SHMTableWithOpeningSectionsViewController.h
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 16.07.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHMCalculationScreenViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *calculationTableView;

@end

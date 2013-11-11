//
//  SHMCalculationScreenTableCell.h
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 23.07.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHMCalculationScreenTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *debtTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *personTextLabel;

-(void)configureWithPersonName:(NSString *)name andDebt:(NSString *)debt;

@end

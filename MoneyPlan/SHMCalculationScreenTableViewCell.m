//
//  SHMCalculationScreenTableCell.m
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 23.07.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMCalculationScreenTableViewCell.h"

@implementation SHMCalculationScreenTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
 UINib *nib = [UINib nibWithNibName:@"SHMCalculationScreenTableViewCell" bundle:[NSBundle mainBundle]];
 self = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];

    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor grayColor].CGColor;
    sublayer.frame = CGRectMake(0, 0, 5.0, self.frame.size.height);
    [self.layer addSublayer:sublayer];
    
 return self;
}


-(void)configureWithPersonName:(NSString *)name andDebt:(NSString *)debt {
    self.personTextLabel.text = name;
    self.debtTextLabel.text = debt;
}
 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end

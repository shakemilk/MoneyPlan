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
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.backgroundColor = [UIColor grayColor].CGColor;
    shapeLayer.frame = CGRectMake(0, 0, 5.0, self.frame.size.height);
#warning линий надо по одной на каждую ячейку и для верхней не нужна верхняя линия
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 20, 0);
    CGPathAddLineToPoint(path, NULL, 360, 0);
    CGPathMoveToPoint(path, NULL, 20, 44);
    CGPathAddLineToPoint(path, NULL, 360, 44);
#warning проверить размеры линий
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:199.f/255 green:199.f/255 blue:205.f/255 alpha:1.f] CGColor]];
    [shapeLayer setLineWidth:0.4f];

    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //[self.layer addSublayer:sublayer];
    [self.layer addSublayer:shapeLayer];
    
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

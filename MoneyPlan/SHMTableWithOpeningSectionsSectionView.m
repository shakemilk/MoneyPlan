//
//  CalculationViewSectionHeaderView.m
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 07.07.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMTableWithOpeningSectionsSectionView.h"
#import <QuartzCore/QuartzCore.h>

@interface SHMTableWithOpeningSectionsSectionView()

@end

@implementation SHMTableWithOpeningSectionsSectionView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title section:(NSInteger)sectionNumber state:(BOOL)isOpened delegate:(id<SHMTableWithOpeningSectionsSectionViewDelegate>)delegate
{
    self = [super initWithFrame:frame];

    //set up tap gesture recognizer

    if (self!=nil)
    {
        self.isOpened = isOpened;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];  //почему тут ничего не надо передавать в toggleOpen?
        [self addGestureRecognizer:tapRecognizer];
        _delegate = delegate;
        _section = sectionNumber;   //передали номер секции
        
        //Имя человека в секции
        //starts here
        CGRect personLabelFrame = self.bounds;
        
        personLabelFrame.origin.x += 15.0;
        personLabelFrame.origin.y += 7.5;
        personLabelFrame.size.height = 25;
        personLabelFrame.size.width = 200;
        
        UILabel *personLabel = [[UILabel alloc] initWithFrame:personLabelFrame];
        personLabel.text = title;
        personLabel.font = [UIFont boldSystemFontOfSize:20.0];
        personLabel.textColor = [UIColor blackColor];
        [personLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:18.0]];
        [self addSubview:personLabel];
        _titleLabel = personLabel;
        //ends here
        
        //подпись, "суммарно потратил"
        //starts here
        CGRect personSpentTextLabelFrame = CGRectMake(personLabelFrame.origin.x + 15.0, personLabelFrame.origin.y + personLabelFrame.size.height, 90.0, self.bounds.size.height - personLabelFrame.size.height - 15.0);
        
        UILabel *personSpentTextLabel = [[UILabel alloc] initWithFrame:personSpentTextLabelFrame];
        personSpentTextLabel.text = @"Потратил(а):";
        personSpentTextLabel.font = [UIFont boldSystemFontOfSize:20.0];
        personSpentTextLabel.textColor = [UIColor grayColor];
        [personSpentTextLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
        [self addSubview:personSpentTextLabel];
        //ends here

        //подпись, сколько он всего потратил
        //starts here
        CGRect personSpentSumLabelFrame = CGRectMake(personSpentTextLabelFrame.origin.x + personSpentTextLabelFrame.size.width + 10.0, personSpentTextLabelFrame.origin.y, 80.0, personSpentTextLabelFrame.size.height);
        
        UILabel *personSpentSumLabel = [[UILabel alloc] initWithFrame:personSpentSumLabelFrame];
        personSpentSumLabel.text = @"1400р.";
        personSpentSumLabel.font = [UIFont boldSystemFontOfSize:20.0];
        personSpentSumLabel.textColor = [UIColor redColor];
        [personSpentSumLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
        [self addSubview:personSpentSumLabel];
        //ends here
        
        //подпись, сколько он суммарно должен
        //starts here
        CGRect debtLabelFrame = CGRectMake(self.bounds.size.width - 60.0, personLabelFrame.origin.y, 60.0, self.bounds.size.height - 15.0);
        
        UILabel *debtLabel = [[UILabel alloc] initWithFrame:debtLabelFrame];
        debtLabel.text = @"300р.";
        debtLabel.font = [UIFont boldSystemFontOfSize:20.0];
        debtLabel.textColor = [UIColor redColor];
        [debtLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:18.0]];
        [self addSubview:debtLabel];
        //ends here
     
        //self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 0.5f;
        self.backgroundColor = [SHMAppearance defaultBackgroundColor];
    }
    return self;
}

-(IBAction) toggleOpen:(id)sender
{
    [self toggleOpenWithUserAction:YES];
}


-(void) drawRect:(CGRect)rect
{
    //для тестирования ввожу окантовывающие текст прямоугольники, больше ни для чего drawrect пока не нужен
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect personLabelFrame = self.bounds;
    personLabelFrame.origin.x += 15.0;
    personLabelFrame.origin.y += 7.5;
    personLabelFrame.size.height = 25;
    personLabelFrame.size.width = 200;
    CGContextAddRect(context, personLabelFrame);
    
    CGRect personSpentTextLabelFrame = CGRectMake(personLabelFrame.origin.x + 15.0, personLabelFrame.origin.y + personLabelFrame.size.height, 90, self.bounds.size.height - personLabelFrame.size.height - 15.0);
    CGContextAddRect(context, personSpentTextLabelFrame);

    CGRect personSpentSumLabelFrame = CGRectMake(personSpentTextLabelFrame.origin.x + personSpentTextLabelFrame.size.width + 10.0, personSpentTextLabelFrame.origin.y, 80.0, personSpentTextLabelFrame.size.height);
    CGContextAddRect(context, personSpentSumLabelFrame);

    CGRect debtLabelFrame = CGRectMake(self.bounds.size.width - 60.0, personLabelFrame.origin.y, 60.0, self.bounds.size.height - 15.0);
    CGContextAddRect(context, debtLabelFrame);

    CGContextSetLineWidth(context, 0.5);
    [[UIColor blueColor] setStroke];
    
    CGContextStrokePath(context);
}


-(void) toggleOpenWithUserAction:(BOOL)userAction
//здесь запускается функция открытия/закрытия списка
{
    self.isOpened = !self.isOpened;
    
    if(userAction){
        if (self.isOpened == YES){
            if([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]){
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
                //self.layer.borderWidth = 1.0f;  //меняем ширину границы, может быть не нужно. Все равно видно
            }
        }
        else{
            if([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]){
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
                //self.layer.borderWidth = 0.5f;
            }
        }
    }
}

@end

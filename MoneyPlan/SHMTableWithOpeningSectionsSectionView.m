//
//  CalculationViewSectionHeaderView.m
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 07.07.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMTableWithOpeningSectionsSectionView.h"
#import <QuartzCore/QuartzCore.h>


@implementation SHMTableWithOpeningSectionsSectionView

@synthesize titleLabel = _titleLabel;
@synthesize delegate = _delegate;
@synthesize section = _section;
@synthesize opened = _opened;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)drawRect:(CGRect)rect
{
    
    //// Color Declarations
    UIColor* fillColor = [UIColor whiteColor];
    UIColor* strokeColor = [UIColor blueColor];
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(5, 5, 310, 35) cornerRadius: 4];
    
    UIBezierPath *fullCellRect = [UIBezierPath bezierPathWithRect:rect];
    
    [fillColor setFill];
    [fullCellRect fill];
    [strokeColor setStroke];
    roundedRectanglePath.lineWidth = 2.5;
    [roundedRectanglePath stroke];


}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title section:(NSInteger)sectionNumber delegate:(id<SHMTableWithOpeningSectionsSectionViewDelegate>)delegate
{
    self = [super initWithFrame:frame];

    //set up tap gesture recognizer
    
    if (self!=nil)
    {
        
        self.opened = YES;    //заглушка. Cписок изначально открыт
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];  //почему тут ничего не надо передавать в toggleOpen?
    
        [self addGestureRecognizer:tapRecognizer];
        
        _delegate = delegate;
        
        _section = sectionNumber;   //передали номер секции
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 15.0;   //взято из проекта apple. подредактировать размеры
        titleLabelFrame.origin.y += 7.5;
        titleLabelFrame.size.width -= 25.0;
        //CGRectInset(titleLabelFrame, 45.0, 15.0); //возвращает прямоугольник с тем же центром, но меньше по размеру
        
        titleLabelFrame.size.height -=15.0;
        
        UILabel *label = [[UILabel alloc] initWithFrame:titleLabelFrame];
        label.text = title;
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textColor = [UIColor blueColor];
        
        //label.textAlignment =
        [self addSubview:label];
        _titleLabel = label;

    }
    
    return self;
    
    
}

-(IBAction) toggleOpen:(id)sender
{
    [self toggleOpenWithUserAction:YES];
}



-(void) toggleOpenWithUserAction:(BOOL)userAction
//здесь запускается функция открытия/закрытия списка
{
    if(userAction)
    {
        
        if (self.opened == NO){
            if([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]){
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
                self.opened = YES; //а если метод как-то странно выполнился? может надо из делегата менять флаг?
            }
        }
        else{
            if([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]){
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
                self.opened = NO;
            }
        }
    }
    
}

@end

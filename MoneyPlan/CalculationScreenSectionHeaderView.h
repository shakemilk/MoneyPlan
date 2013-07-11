//
//  CalculationViewSectionHeaderView.h
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 07.07.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@protocol SectionHeaderViewDelegate;

@interface CalculationScreenSectionHeaderView : UIView

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, assign) NSInteger section;    //а зачем assign?
@property (nonatomic, weak) id <SectionHeaderViewDelegate> delegate;

@property (nonatomic) BOOL opened;   // открыта или закрыта секция


-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)delegate;
-(void) toggleOpenWithUserAction:(BOOL)userAction;

@end




@protocol SectionHeaderViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(CalculationScreenSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger) sectionOpened;
-(void)sectionHeaderView:(CalculationScreenSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger) sectionClosed;

@end
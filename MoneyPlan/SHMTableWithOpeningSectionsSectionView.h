//
//  CalculationViewSectionHeaderView.h
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 07.07.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SHMAppearance.h"

@protocol SHMTableWithOpeningSectionsSectionViewDelegate;

@interface SHMTableWithOpeningSectionsSectionView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) NSInteger section;    //а зачем assign?
@property (nonatomic, weak) id <SHMTableWithOpeningSectionsSectionViewDelegate> delegate;
@property (atomic) BOOL isOpened;   // открыта или закрыта секция

-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber state:(BOOL)isOpened delegate:(id <SHMTableWithOpeningSectionsSectionViewDelegate>)delegate;
-(void) toggleOpenWithUserAction:(BOOL)userAction;

@end


@protocol SHMTableWithOpeningSectionsSectionViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(SHMTableWithOpeningSectionsSectionView *)sectionHeaderView sectionOpened:(NSInteger) sectionOpened;
-(void)sectionHeaderView:(SHMTableWithOpeningSectionsSectionView *)sectionHeaderView sectionClosed:(NSInteger) sectionClosed;

@end
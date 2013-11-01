//
//  SHMAlertView.h
//  MoneyPlan
//
//  Created by Mikhail Grushin on 01/11/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHMAlertView : UIView
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithTitle:(NSString *)title;
- (void)show;
- (void)dismiss;

@end

//
//  SHMAlertView.h
//  MoneyPlan
//
//  Created by Mikhail Grushin on 01/11/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SHMAlertViewType) {
    SHMAlertViewTypeCreateNewEvent,
    SHMAlertViewTypeJoinExistingEvent
};

@class SHMAlertView;

@protocol SHMAlertViewDelegate <NSObject>

-(void)alertView:(SHMAlertView *)alertView didOKWithType:(SHMAlertViewType)type;
-(void)alertView:(SHMAlertView *)alertView didCancelWithType:(SHMAlertViewType)type;
-(void)alertViewWillDismiss:(SHMAlertView *)alertView;
-(void)alertViewDidDismiss:(SHMAlertView *)alertView;

@end

@interface SHMAlertView : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) SHMAlertViewType alertViewType;
@property (nonatomic, weak) id<SHMAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title type:(SHMAlertViewType)type;
- (void)show;
- (void)dismiss;

@end

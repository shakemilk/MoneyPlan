//
//  SHMAlertView.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 01/11/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMAlertView.h"
#import "SHMAppearance.h"

#define kButtonHeight 44.f

@interface SHMBackgroundView : UIView
@property (nonatomic, strong) UIWindow *previousKeyWindow;
@property (nonatomic, strong) UIWindow *alertWindow;

+(instancetype)sharedBackgroundView;
@end

@implementation SHMBackgroundView

+(instancetype)sharedBackgroundView {
    static dispatch_once_t onceToken;
    __strong static SHMBackgroundView *backgroundView;
    dispatch_once(&onceToken, ^{
        backgroundView = [SHMBackgroundView new];
    });
    
    return backgroundView;
}

- (id)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:.5f];
        
        self.previousKeyWindow = [UIApplication sharedApplication].keyWindow;
        
        self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.alertWindow.windowLevel = UIWindowLevelAlert;
        self.alertWindow.backgroundColor = [UIColor clearColor];
        [self.alertWindow addSubview:self];
        [self.alertWindow makeKeyAndVisible];
        
        self.hidden = YES;
    }
    
    return self;
}

-(void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    
    self.alertWindow.hidden = hidden;
    
    if (hidden) {
        [self.alertWindow resignKeyWindow];
        [self.previousKeyWindow makeKeyWindow];
    } else {
        [self.previousKeyWindow resignKeyWindow];
        [self.alertWindow makeKeyWindow];
    }
}

@end

@interface SHMAlertView()
@property (nonatomic, strong) SHMBackgroundView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *okButton;
@end

@implementation SHMAlertView

- (instancetype)initWithTitle:(NSString *)title type:(SHMAlertViewType)type {
    if (self = [super initWithFrame:CGRectMake(0.f, 0.f, 286.f, 204.f)]) {
        self.backgroundColor = [SHMAppearance defaultBackgroundColor];
        self.layer.cornerRadius = 16.f;
        self.title = title;
        _alertViewType = type;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.cancelButton];
        [self addSubview:self.okButton];
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)show {
    self.backgroundView = [SHMBackgroundView sharedBackgroundView];
    self.center = CGPointMake(CGRectGetMidX(self.backgroundView.bounds), CGRectGetMidY(self.backgroundView.bounds));
    [self.backgroundView addSubview:self];
    self.backgroundView.alpha = 0.f;
    self.backgroundView.hidden = NO;
    
    [UIView animateWithDuration:.5f animations:^{
        self.backgroundView.alpha = 1.f;
    }];
}

- (void)dismiss {
    if ([self.delegate respondsToSelector:@selector(alertViewWillDismiss:)]) {
        [self.delegate alertViewWillDismiss:self];
    }
    
    [UIView animateWithDuration:.5f animations:^{
        self.backgroundView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.backgroundView.alpha = 1.f;
        self.backgroundView.hidden = YES;
        self.backgroundView = nil;
        
        if ([self.delegate respondsToSelector:@selector(alertViewDidDismiss:)]) {
            [self.delegate alertViewDidDismiss:self];
        }
    }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0.f, 0.f,
                                       self.bounds.size.width,
                                       55.f);
    self.cancelButton.frame = CGRectMake(0.f, self.bounds.size.height - kButtonHeight,
                                   self.bounds.size.width/2.f,
                                   kButtonHeight);
    self.okButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), self.bounds.size.height - kButtonHeight,
                                     self.bounds.size.width/2.f,
                                     kButtonHeight);
}

- (void)tappedOKButton {
    if ([self.delegate respondsToSelector:@selector(alertView:didOKWithType:)]) {
        [self.delegate alertView:self didOKWithType:self.alertViewType];
    }
    
    [self dismiss];
}

- (void)tappedCancelButton {
    if ([self.delegate respondsToSelector:@selector(alertView:didCancelWithType:)]) {
        [self.delegate alertView:self didCancelWithType:self.alertViewType];
    }
    
    [self dismiss];
}

#pragma mark - Getters

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26.f];
        _titleLabel.textColor = [SHMAppearance rosyTitleColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [SHMAppearance defaultBackgroundColor];
    }
    
    return _titleLabel;
}

-(UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelButton.backgroundColor = [SHMAppearance defaultBackgroundColor];
        [_cancelButton setTitle:@"Отменить" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[SHMAppearance rosyTitleColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.f];
        _cancelButton.layer.borderWidth = .5f;
        _cancelButton.layer.borderColor = [UIColor colorWithRed:200.f/255 green:200.f/255 blue:206.f/255 alpha:1.f].CGColor;
        [_cancelButton addTarget:self action:@selector(tappedCancelButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

-(UIButton *)okButton {
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _okButton.backgroundColor = [SHMAppearance defaultBackgroundColor];
        [_okButton setTitle:@"Готово" forState:UIControlStateNormal];
        [_okButton setTitleColor:[SHMAppearance rosyTitleColor] forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.f];
        _okButton.layer.borderWidth = .5f;
        _okButton.layer.borderColor = [UIColor colorWithRed:200.f/255 green:200.f/255 blue:206.f/255 alpha:1.f].CGColor;
        [_okButton addTarget:self action:@selector(tappedOKButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _okButton;
}

#pragma mark - Setters

-(void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

@end

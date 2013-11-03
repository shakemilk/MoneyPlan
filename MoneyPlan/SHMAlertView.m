//
//  SHMAlertView.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 01/11/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMAlertView.h"
#import "SHMAppearance.h"
#import <QuartzCore/QuartzCore.h>

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

@interface SHMAlertView() <UITextFieldDelegate>
@property (nonatomic, strong) SHMBackgroundView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *eventTextField;
@property (nonatomic, strong) UITextField *dateTextField;
@property (nonatomic, strong) UIDatePicker *datePicker;
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
        [self addSubview:self.eventTextField];
        [self addSubview:self.cancelButton];
        [self addSubview:self.okButton];
        
        if (self.alertViewType == SHMAlertViewTypeCreateNewEvent) {
            [self addSubview:self.dateTextField];
        }
        
        self.clipsToBounds = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)show {
    self.backgroundView = [SHMBackgroundView sharedBackgroundView];
    self.center = CGPointMake(CGRectGetMidX(self.backgroundView.bounds), CGRectGetMidY(self.backgroundView.bounds));
    [self.backgroundView addSubview:self];
    self.backgroundView.alpha = 0.f;
    self.backgroundView.hidden = NO;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self.backgroundView addGestureRecognizer:tapRecognizer];
    
    [UIView animateWithDuration:.5f animations:^{
        self.backgroundView.alpha = 1.f;
    }];
}

- (void)dismiss {
    if ([self.delegate respondsToSelector:@selector(alertViewWillDismiss:)]) {
        [self.delegate alertViewWillDismiss:self];
    }
    
    [self.eventTextField resignFirstResponder];
    [self.dateTextField resignFirstResponder];
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
    self.eventTextField.frame = CGRectMake(0.f, CGRectGetMaxY(self.titleLabel.frame),
                                           self.bounds.size.width,
                                           45.f);
    self.dateTextField.frame = CGRectMake(0.f, CGRectGetMaxY(self.eventTextField.frame),
                                          self.bounds.size.width,
                                          45.f);
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

-(UITextField *)eventTextField {
    if (!_eventTextField) {
        _eventTextField = [[UITextField alloc] init];
        if (self.alertViewType == SHMAlertViewTypeCreateNewEvent) {
            _eventTextField.placeholder = @"Название";
            _eventTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        } else {
            _eventTextField.placeholder = @"ID события";
            _eventTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
        _eventTextField.clearButtonMode = UITextFieldViewModeAlways;
        _eventTextField.backgroundColor = [UIColor whiteColor];
        _eventTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15.f, _eventTextField.bounds.size.height)];
        _eventTextField.leftViewMode = UITextFieldViewModeAlways;
        _eventTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15.f, _eventTextField.bounds.size.height)];
        _eventTextField.rightViewMode = UITextFieldViewModeAlways;
        _eventTextField.returnKeyType = UIReturnKeyDone;
        _eventTextField.delegate = self;
    }
    
    return _eventTextField;
}

-(UITextField *)dateTextField {
    if (!_dateTextField) {
        _dateTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, 45.f)];
        _dateTextField.backgroundColor = [UIColor whiteColor];
        _dateTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 15.f, _dateTextField.bounds.size.height)];
        _dateTextField.leftViewMode = UITextFieldViewModeAlways;
        _dateTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 15.f, _dateTextField.bounds.size.height)];
        _dateTextField.rightViewMode = UITextFieldViewModeAlways;
        _dateTextField.placeholder = @"Дата";
        _dateTextField.inputView = self.datePicker;
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, 44.f)];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Готово" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
        [toolbar setItems:@[barButton]];
        toolbar.backgroundColor = [UIColor whiteColor];
        _dateTextField.inputAccessoryView = toolbar;

        CALayer *borderLayer = [CALayer layer];
        borderLayer.frame = CGRectMake(0.f, 0.f, _dateTextField.bounds.size.width, .5f);
        borderLayer.backgroundColor = [UIColor colorWithRed:200.f/255 green:200.f/255 blue:206.f/255 alpha:1.f].CGColor;
        [_dateTextField.layer addSublayer:borderLayer];
    }
    
    return _dateTextField;
}

-(UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.date = [NSDate date];
        _datePicker.minimumDate = [NSDate date];
        [_datePicker addTarget:self action:@selector(pickerValueChanged) forControlEvents:UIControlEventValueChanged];
        _datePicker.backgroundColor = [UIColor whiteColor];
    }
    
    return _datePicker;
}

-(UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelButton.frame = CGRectMake(0.f, 0.f,
                                         self.bounds.size.width/2.f, self.bounds.size.height - kButtonHeight);
        _cancelButton.backgroundColor = [SHMAppearance defaultBackgroundColor];
        [_cancelButton setTitle:@"Отменить" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[SHMAppearance rosyTitleColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.f];
        
        CALayer *topBorderLayer = [CALayer layer];
        topBorderLayer.frame = CGRectMake(0.f, 0.f, _cancelButton.bounds.size.width, 0.5f);
        topBorderLayer.backgroundColor = [UIColor colorWithRed:200.f/255 green:200.f/255 blue:206.f/255 alpha:1.f].CGColor;
        [_cancelButton.layer addSublayer:topBorderLayer];
        
        CALayer *rightSideBorderLayer = [CALayer layer];
        rightSideBorderLayer.frame = CGRectMake(_cancelButton.bounds.size.width-.5f, 0.f,
                                                .5f, _cancelButton.bounds.size.height);
        rightSideBorderLayer.backgroundColor = topBorderLayer.backgroundColor;
        [_cancelButton.layer addSublayer:rightSideBorderLayer];
        
        [_cancelButton addTarget:self action:@selector(tappedCancelButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

-(UIButton *)okButton {
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _okButton.frame = CGRectMake(0.f, 0.f,
                                     self.bounds.size.width/2.f, self.bounds.size.height - kButtonHeight);
        _okButton.backgroundColor = [SHMAppearance defaultBackgroundColor];
        [_okButton setTitle:@"Готово" forState:UIControlStateNormal];
        [_okButton setTitleColor:[SHMAppearance rosyTitleColor] forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.f];

        CALayer *topBorderLayer = [CALayer layer];
        topBorderLayer.frame = CGRectMake(0.f, 0.f, _okButton.bounds.size.width, 0.5f);
        topBorderLayer.backgroundColor = [UIColor colorWithRed:200.f/255 green:200.f/255 blue:206.f/255 alpha:1.f].CGColor;
        [_okButton.layer addSublayer:topBorderLayer];
        
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

#pragma mark - Keyboard notifications

- (void)keyboardWillShow {
    if (self.backgroundView.hidden) return;
    [UIView animateWithDuration:.2f animations:^{
        CGFloat deltaY;
        deltaY = IS_WIDESCREEN?50.f:84.f;
        if ([self.dateTextField isFirstResponder])
            deltaY += 44.f;
        deltaY -= CGRectGetMidY(self.backgroundView.bounds) - self.center.y;
        self.center = CGPointMake(self.center.x, self.center.y - deltaY);
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide {
    if (self.backgroundView.hidden) return;
    [UIView animateWithDuration:.2f animations:^{
        self.center = CGPointMake(self.center.x, CGRectGetMidY(self.backgroundView.bounds));
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Gesture handler 

- (void)tapHandler:(UITapGestureRecognizer *)recognizer {
    CGPoint tapPoint = [recognizer locationInView:self];
    if (!CGRectContainsPoint(self.bounds, tapPoint)) {
        [self tappedCancelButton];
    }
}

#pragma mark - Text Field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

#pragma mark - Picker view action

- (void)pickerValueChanged {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd.MM.yy";
    self.dateTextField.text = [dateFormatter stringFromDate:self.datePicker.date];
}

- (void)doneAction {
    [self.dateTextField resignFirstResponder];
}

@end

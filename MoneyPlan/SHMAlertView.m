//
//  SHMAlertView.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 01/11/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMAlertView.h"
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

@implementation SHMAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

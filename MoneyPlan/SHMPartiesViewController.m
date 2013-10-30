//
//  SHMPartiesViewController.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 30/10/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMPartiesViewController.h"
#import "SHMAppearance.h"
#import "SHMTabBarController.h"

@interface SHMPartiesViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) SHMTabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation SHMPartiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [SHMAppearance defaultBackgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - New party button action

- (IBAction)newPartyAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Новое событие" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Создать событие", @"Присоединиться к событию", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - Action Sheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        self.tabBarController = [[SHMTabBarController alloc] initWithNibName:nil bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
        [self presentViewController:self.navigationController animated:YES completion:nil];
    }
}

@end

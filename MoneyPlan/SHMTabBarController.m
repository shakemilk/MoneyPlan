//
//  SHMTabBarController.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 30/10/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMTabBarController.h"
#import "SHMFolksListViewController.h"
#import "SHMCalculationScreenViewController.h"
#import "SHMAppearance.h"

@interface SHMTabBarController ()

@property (nonatomic, strong) UIViewController *productsController;
@property (nonatomic, strong) SHMFolksListViewController *folksController;
@property (nonatomic, strong) SHMCalculationScreenViewController *calculationsController;

@end

@implementation SHMTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _productsController = [[UIViewController alloc] init];
        _folksController = [[SHMFolksListViewController alloc] initWithNibName:nil bundle:nil];
        _calculationsController = [[SHMCalculationScreenViewController alloc] initWithNibName:nil bundle:nil];
        
        self.viewControllers = @[_productsController, _folksController, _calculationsController];
        self.selectedViewController = _calculationsController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonTap)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonTap {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

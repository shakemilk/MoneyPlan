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
        self.selectedViewController = _productsController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

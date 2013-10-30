//
//  SHMPartiesViewController.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 30/10/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMPartiesViewController.h"
#import "SHMAppearance.h"

@interface SHMPartiesViewController ()

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

@end

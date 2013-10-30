//
//  SHMViewController.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 03.07.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMViewController.h"
#import "SHMAppearance.h"

@interface SHMViewController ()

@end

@implementation SHMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [SHMAppearance defaultBackgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

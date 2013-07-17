//
//  SHMCalculationScreenViewController.m
//  CalculationScreen
//
//  Created by Mikhail Pogosskiy on 03.07.13.
//  Copyright (c) 2013 Pogosskiy. All rights reserved.
//

#import "SHMCalculationScreenViewController.h"
#import "SHMTableWithOpeningSectionsViewController.h"
#import "Foundation/Foundation.h"

@interface SHMCalculationScreenViewController ()

@property (nonatomic, strong) IBOutlet SHMTableWithOpeningSectionsViewController *tableViewController;

@end


#define HEADER_HEIGHT 45

@implementation SHMCalculationScreenViewController

@synthesize tableViewController = _tableViewController;


-(SHMTableWithOpeningSectionsViewController *) tableViewController
{    
    if(!_tableViewController)
        _tableViewController = [[SHMTableWithOpeningSectionsViewController alloc] init];
    
    return _tableViewController;
}


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
    
    [self.view addSubview:self.tableViewController.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

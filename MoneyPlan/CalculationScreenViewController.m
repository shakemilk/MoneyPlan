//
//  CalculationScreenViewController.m
//  CalculationScreen
//
//  Created by Mikhail Pogosskiy on 03.07.13.
//  Copyright (c) 2013 Pogosskiy. All rights reserved.
//

#import "CalculationScreenViewController.h"
#import "Foundation/Foundation.h"

@interface CalculationScreenViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation CalculationScreenViewController

@synthesize tableView = _tableView;



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    return cell;
}


-(UITableView *)createTableView
{
    
    CGFloat x = 0.0;
    CGFloat y = 50.0;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - 100;
    
    CGRect tableRect = CGRectMake(x, y, width, height);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    /*тут еще параметры бы позадавать*/
    tableView.rowHeight = 45;
    tableView.sectionFooterHeight = 22;
    tableView.sectionHeaderHeight = 22;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;
    
    
    return tableView;
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
	// Do any additional setup after loading the view.
    
    self.tableView = [self createTableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"]; //что это за строка непонятно, но она починила всю таблицу
    [self.view addSubview:self.tableView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

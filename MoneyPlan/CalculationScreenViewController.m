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
@property (nonatomic, strong) NSArray *namesOfPeople;   // тут имена из plist

@property (nonatomic, strong) NSArray *numberOfRowsToShow;    //number for each section

@end


#define HEADER_HEIGHT 45

@implementation CalculationScreenViewController

@synthesize tableView = _tableView;
@synthesize namesOfPeople = _namesOfPeople;

@synthesize numberOfRowsToShow = _numberOfRowsToShow;

#pragma mark -
#pragma mark TableViewDataSource Methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//return number of Sections. It is equal to number of rows in section
{
    return self.namesOfPeople.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //здесь наверное еще проверка какая-нибудь нужна. А если там никого нет в plist?
    
    //return self.namesOfPeople.count;
    return [[self.numberOfRowsToShow objectAtIndex:section] integerValue]; //тест вообще надо следить чтоб там NSInteger был

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //и тут проверки на объект надо воткнуть на то, какой объект мы передаем
    return [self.namesOfPeople objectAtIndex:section];
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; //почему обязательно static???
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) //если доступных ячеек нет, создаем новую ячейку
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //тут нужна проверка на пустоту namesOfPeople
    cell.textLabel.text = [self.namesOfPeople objectAtIndex:indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark -
#pragma mark TableViewController Methods


-(UITableView *)createTableView
{
 
    CGFloat x = 0.0;
    CGFloat y = 50.0;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - 100;
    
    CGRect tableRect = CGRectMake(x, y, width, height);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    
    tableView.rowHeight = 45;
    tableView.sectionFooterHeight = 22;
    tableView.sectionHeaderHeight = 22;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;

    return tableView;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //lazily instatniate headers
    
    CalculationScreenSectionHeaderView *sectionHeader = [[CalculationScreenSectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) title:[self.namesOfPeople objectAtIndex:section] section:section delegate:self];
    //it works!!!
    
    return sectionHeader;
}


#pragma mark -
#pragma mark SectionViewDelegate Methods


-(void)sectionHeaderView:(CalculationScreenSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened
//method launches for the section that was just opened by the user 
{
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.namesOfPeople.count; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    UITableViewRowAnimation insertAnimation = UITableViewRowAnimationTop;
    
    NSMutableArray *array = [self.numberOfRowsToShow mutableCopy];
    NSInteger rowsNumberToAdd = [[array objectAtIndex:sectionOpened] integerValue] + [indexPathsToInsert count];
    NSNumber *rows = [[NSNumber alloc] initWithInteger:rowsNumberToAdd];
    
    [array replaceObjectAtIndex:sectionOpened withObject:rows];
    self.numberOfRowsToShow = array;
    
    // Apply the updates.
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView endUpdates];
}

-(void)sectionHeaderView:(CalculationScreenSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed
//method launches for the section that was just closed by the user
{
    //test
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.namesOfPeople.count; i++) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
    }
    
    
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation deleteAnimation;
    deleteAnimation = UITableViewRowAnimationBottom;
    
    NSMutableArray *array = [self.numberOfRowsToShow mutableCopy];
    NSInteger rows1 = [[array objectAtIndex:sectionClosed] integerValue] - [indexPathsToDelete count];
    NSNumber *rows = [[NSNumber alloc] initWithInteger:rows1];
    
    [array replaceObjectAtIndex:sectionClosed withObject:rows];
    self.numberOfRowsToShow = array;
    
    // Apply the updates.
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
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
    
    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"names" withExtension:@"plist"];
    NSDictionary  *namesDictionary = [[NSDictionary alloc] initWithContentsOfURL:url];
    self.namesOfPeople = [namesDictionary objectForKey:@"Names"];
        
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:nil];
    for (NSInteger i = 0; i < self.namesOfPeople.count; i++) {
        NSNumber *num = [[NSNumber alloc]initWithInteger:self.namesOfPeople.count];
        [array addObject:num];
    }
    self.numberOfRowsToShow = array;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"]; //что это за строка непонятно, но она починила всю таблицу
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

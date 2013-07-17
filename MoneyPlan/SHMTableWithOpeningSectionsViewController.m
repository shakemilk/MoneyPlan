//
//  SHMTableWithOpeningSectionsViewController.m
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 16.07.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMTableWithOpeningSectionsViewController.h"
#import "SHMTableWithOpeningSectionsSectionView.h"

@interface SHMTableWithOpeningSectionsViewController () <SHMTableWithOpeningSectionsSectionViewDelegate>

@property (nonatomic, strong) NSArray *namesOfPeople;   // тут имена из plist
@property (nonatomic, strong) NSArray *numberOfRowsToShow;    //number for each section
@property (nonatomic, strong) NSDictionary *listOfDebts;
@end

@implementation SHMTableWithOpeningSectionsViewController

@synthesize tableView = _tableView;
@synthesize namesOfPeople = _namesOfPeople;
@synthesize numberOfRowsToShow = _numberOfRowsToShow;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


#define HEADER_HEIGHT 45
#define ROW_HEIGHT 45

-(UITableView *) tableView{
    
    if (!_tableView){

        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        
        _tableView.rowHeight = ROW_HEIGHT;
        _tableView.sectionHeaderHeight = HEADER_HEIGHT;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.userInteractionEnabled = YES;
        _tableView.bounces = YES;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    
    return _tableView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    NSURL *urlForArray = [[NSBundle mainBundle] URLForResource:@"names" withExtension:@"plist"];
    NSDictionary  *namesDictionary = [[NSDictionary alloc] initWithContentsOfURL:urlForArray];
    self.namesOfPeople = [namesDictionary objectForKey:@"Names"];
    self.listOfDebts = [namesDictionary objectForKey:@"DebtsByName"];
    
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:nil];
    for (NSInteger i = 0; i < self.namesOfPeople.count; i++) {
        NSNumber *num = [[NSNumber alloc]initWithInteger:self.namesOfPeople.count];
        [array addObject:num];
    }
    self.numberOfRowsToShow = array;
    
    //lazily instantiate tableView
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return self.namesOfPeople.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[self.numberOfRowsToShow objectAtIndex:section] integerValue]; //тест вообще надо следить чтоб там NSInteger был
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //и тут проверки на объект надо воткнуть на то, какой объект мы передаем
    return [self.namesOfPeople objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) //если доступных ячеек нет, создаем новую ячейку
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    //тут нужна проверка на пустоту namesOfPeople
    
    cell.textLabel.text = [self.namesOfPeople objectAtIndex:indexPath.row];
    //cell.detailTextLabel.frame = CGRectMake(10, 20, 200,22);        // required
    cell.detailTextLabel.text = [self.namesOfPeople objectAtIndex:indexPath.row];
    
    NSString *titleForHeader = [self tableView:tableView titleForHeaderInSection:indexPath.section];

    NSNumber *debt = [[self.listOfDebts objectForKey:titleForHeader] objectForKey:cell.textLabel.text];
    
    cell.detailTextLabel.text = [debt stringValue];
    
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];   // also required
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //lazily instatniate headers
    
    SHMTableWithOpeningSectionsSectionView *sectionHeader = [[SHMTableWithOpeningSectionsSectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) title:[self.namesOfPeople objectAtIndex:section] section:section delegate:self];
    //it works!!!
    
    return sectionHeader;
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:10];
    cell.textLabel.backgroundColor=[UIColor whiteColor];
    cell.textLabel.frame = CGRectMake(10, 20, 100,22);
    cell.detailTextLabel.frame = CGRectMake(10, 20, 200,22);
    
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark -
#pragma mark SectionViewDelegate Methods


-(void)sectionHeaderView:(SHMTableWithOpeningSectionsSectionView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened
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

-(void)sectionHeaderView:(SHMTableWithOpeningSectionsSectionView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed
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
    
    NSInteger rowsNumberToDelete = [[array objectAtIndex:sectionClosed] integerValue];
    if (rowsNumberToDelete == 0)
        return;
#warning TODO не должен вообще попадать на этот return. выяснить, почему иногда это происходит
    if (rowsNumberToDelete > 0)
    {
        rowsNumberToDelete -= [indexPathsToDelete count];
    }
    
    
    NSNumber *rows = [[NSNumber alloc] initWithInteger:rowsNumberToDelete];
    
    [array replaceObjectAtIndex:sectionClosed withObject:rows];
    self.numberOfRowsToShow = array;
    
    // Apply the updates.
    [self.tableView beginUpdates];  //между begin и end не должно
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
}

@end

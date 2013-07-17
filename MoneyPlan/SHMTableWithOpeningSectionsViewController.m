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
@property (nonatomic, strong) NSDictionary *listOfDebts;    //тут список долгов, кто кому что должен
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

#define SPACE_FOR_TABBAR 49     //высота таб бара

-(UITableView *) tableView{
    
    if (!_tableView){
        CGFloat x = 0.0;
        CGFloat y = 0.0;
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height - SPACE_FOR_TABBAR - 45; //без 45 при полностью раскрытых секциях сверху и закрытой последней секции нельзя увидеть ее заголовок. на нем не тормозится.
        CGRect rect = CGRectMake(x, y, width, height);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
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
    // Return the number of sections.
    return self.listOfDebts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    //тут нужна проверка на пустоту namesOfPeople
    cell.textLabel.text = [self.namesOfPeople objectAtIndex:indexPath.row];
    
    NSString *titleForHeader = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    NSNumber *debt = [[self.listOfDebts objectForKey:titleForHeader] objectForKey:cell.textLabel.text];
    
    cell.detailTextLabel.text = [debt stringValue];
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //lazily instatniate headers
    
    SHMTableWithOpeningSectionsSectionView *sectionHeader = [[SHMTableWithOpeningSectionsSectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) title:[self.namesOfPeople objectAtIndex:section] section:section delegate:self];
    //it works!!!
    
    return sectionHeader;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];   // also required
    //cell.textLabel.backgroundColor=[UIColor whiteColor];
       
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    deleteAnimation = UITableViewRowAnimationTop;
    
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

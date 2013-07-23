//
//  SHMTableWithOpeningSectionsViewController.m
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 16.07.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMTableWithOpeningSectionsViewController.h"
#import "SHMTableWithOpeningSectionsSectionView.h"
#import "SHMCalculationScreenTableCell.h"

@interface SHMTableWithOpeningSectionsViewController () <SHMTableWithOpeningSectionsSectionViewDelegate>

@property (nonatomic, strong) NSArray *namesOfPeopleArray;   // тут имена из plist
@property (nonatomic, strong) NSArray *numberOfRowsToShowForSection;    //number of rows for each section
@property (nonatomic, strong) NSDictionary *listOfDebts;    //тут список долгов, кто кому что должен
@end

@implementation SHMTableWithOpeningSectionsViewController

#define SHM_HEADER_HEIGHT 45
#define SHM_ROW_HEIGHT 45
#define SHM_SPACE_FOR_TABBAR 49     //высота таб бара


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(UITableView *) calculationTableView{
    
    if (!_calculationTableView){
        CGFloat x = 0.0;
        CGFloat y = 0.0;
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height - SHM_SPACE_FOR_TABBAR - 45; //без 45 при полностью раскрытых секциях сверху и закрытой последней секции нельзя увидеть ее заголовок. на нем не тормозится.
        CGRect rect = CGRectMake(x, y, width, height);
        
        _calculationTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
        _calculationTableView.rowHeight = SHM_ROW_HEIGHT;
        _calculationTableView.sectionHeaderHeight = SHM_HEADER_HEIGHT;
        _calculationTableView.scrollEnabled = YES;
        _calculationTableView.showsVerticalScrollIndicator = YES;
        _calculationTableView.userInteractionEnabled = YES;
        _calculationTableView.bounces = YES;
        
        _calculationTableView.delegate = self;
        _calculationTableView.dataSource = self;
        
        [_calculationTableView registerClass:[SHMCalculationScreenTableCell class] forCellReuseIdentifier:@"Cell"];
        
        //[_calculationTableView registerNib:[UINib nibWithNibName:@"SHMCalculationScreenTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"]; //делаем через registerNib, потому что иначе регистрируется ячейка с дефолтным стилем. Выход - либо использовать xib, либо кастомный класс
    }
    
    return _calculationTableView;
}


-(NSArray *) namesOfPeopleArray
{
    if (!_namesOfPeopleArray)
    {
        NSURL *urlForArray = [[NSBundle mainBundle] URLForResource:@"names" withExtension:@"plist"];
        NSDictionary  *namesDictionary = [[NSDictionary alloc] initWithContentsOfURL:urlForArray];
    
        _namesOfPeopleArray = [namesDictionary objectForKey:@"Names"];
    }
    return _namesOfPeopleArray;
}


-(NSDictionary *) listOfDebts
{
    if (!_listOfDebts)
    {
        NSURL *urlForArray = [[NSBundle mainBundle] URLForResource:@"names" withExtension:@"plist"];
        NSDictionary  *namesDictionary = [[NSDictionary alloc] initWithContentsOfURL:urlForArray];
        
        _listOfDebts = [namesDictionary objectForKey:@"DebtsByName"];
    }
    return _listOfDebts;
}

-(NSArray *) numberOfRowsToShow
{
    if(!_numberOfRowsToShowForSection)
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:nil];
        for (NSInteger i = 0; i < self.namesOfPeopleArray.count; i++) {
            NSNumber *num = [[NSNumber alloc]initWithInteger:self.namesOfPeopleArray.count];
            [array addObject:num];
        }
        _numberOfRowsToShowForSection = array;
    }
    return _numberOfRowsToShowForSection;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = self.calculationTableView; //lazily instantiate tableView
    
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
    return [self.namesOfPeopleArray objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //тут нужна проверка на пустоту namesOfPeopleArray
    cell.textLabel.text = [self.namesOfPeopleArray objectAtIndex:indexPath.row];
    
    NSString *titleForHeader = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    NSNumber *debt = [[self.listOfDebts objectForKey:titleForHeader] objectForKey:cell.textLabel.text];
    
    cell.detailTextLabel.text = [debt stringValue];
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //lazily instatniate headers
    
    SHMTableWithOpeningSectionsSectionView *sectionHeader = [[SHMTableWithOpeningSectionsSectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, SHM_HEADER_HEIGHT) title:[self.namesOfPeopleArray objectAtIndex:section] section:section delegate:self];
    
    return sectionHeader;
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
    
    for (NSInteger i = 0; i < self.namesOfPeopleArray.count; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    UITableViewRowAnimation insertAnimation = UITableViewRowAnimationTop;
    
    NSMutableArray *array = [self.numberOfRowsToShow mutableCopy];
    NSInteger rowsNumberToAdd = [[array objectAtIndex:sectionOpened] integerValue] + [indexPathsToInsert count];
    NSNumber *rows = [[NSNumber alloc] initWithInteger:rowsNumberToAdd];
    
    [array replaceObjectAtIndex:sectionOpened withObject:rows];
    self.numberOfRowsToShowForSection = array;
    
    // Apply the updates.
    [self.calculationTableView beginUpdates];
    [self.calculationTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.calculationTableView endUpdates];
}

-(void)sectionHeaderView:(SHMTableWithOpeningSectionsSectionView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed
//method launches for the section that was just closed by the user
{
    
    //test
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.namesOfPeopleArray.count; i++) {
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
    self.numberOfRowsToShowForSection = array;
    
    // Apply the updates.
    [self.calculationTableView beginUpdates];  //между begin и end не должно
    [self.calculationTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.calculationTableView endUpdates];
}

@end

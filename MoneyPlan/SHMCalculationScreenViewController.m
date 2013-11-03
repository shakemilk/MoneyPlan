//
//  SHMTableWithOpeningSectionsViewController.m
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 16.07.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMCalculationScreenViewController.h"
#import "SHMTableWithOpeningSectionsSectionView.h"
#import "SHMCalculationScreenTableCell.h"
#import "SHMAppearance.h"

@interface SHMCalculationScreenViewController () <SHMTableWithOpeningSectionsSectionViewDelegate>

@property (nonatomic, strong) NSArray *numberOfRowsToShowForSection;    //number of rows for each section
@property (nonatomic, strong) NSDictionary *listOfDebts;    //тут список долгов, кто кому что должен
@property (nonatomic, strong) NSArray *debtsArray;  //массив долгов
@property (nonatomic, strong) NSArray *openedSectionsArray; //YES - секция открыта, NO - закрыта
@property (nonatomic, weak) NSNumber *lastOpenedSection; //последняя открытая секция
@property (nonatomic, strong) NSMutableArray* sectionViewsArray; //массив из элементов SHMCalculationScreenSectionInfo, в которых хранятся указатели на UIView секции.


@end

@implementation SHMCalculationScreenViewController

#define SHM_HEADER_HEIGHT 64
#define SHM_ROW_HEIGHT 44
#define SHM_TAB_BAR_HEIGHT 49     //странные размеры, почему-то не сходятся
#define SHM_NAVIGATION_BAR_HEIGHT 44
#define SHM_STATUS_BAR_HEIGHT 20

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tabBarItem.title = @"Calculations";
    }
    
    return self;
}

-(UITableView *) calculationTableView{
    
    if (!_calculationTableView){
        CGFloat x = 0.0;
        CGFloat y = 0.0;
        CGFloat width = self.view.frame.size.width;
        
#warning размеры таблицы не подгоняются нормально по высоте
        CGFloat height = self.view.frame.size.height-SHM_TAB_BAR_HEIGHT-SHM_NAVIGATION_BAR_HEIGHT-SHM_STATUS_BAR_HEIGHT;
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
        [_calculationTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_calculationTableView setBackgroundColor:[SHMAppearance defaultBackgroundColor]];
    }
    
    return _calculationTableView;
}

-(NSArray *) openedSectionsArray
{
    if (!_openedSectionsArray)
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects: nil];
        for (NSInteger i = 0; i < [self.listOfDebts count]; ++i)
        {
            [tempArray addObject:[[NSNumber alloc] initWithBool:NO]];
        }
        _openedSectionsArray = [tempArray copy];
    }
    return _openedSectionsArray;
}

-(NSMutableArray *) sectionViewsArray
//нужно забить нулями по количеству секций
//потом нули в коде будут заменены на view секций
//надо будет потом предусмотреть возможность добавления новых людей,
//что ведет к добывлению секций и расширению массива
#warning впоследствии возможна сортировка этого массива (сортировка людей в списке). Надо будет проверить
{
    if (_sectionViewsArray == nil){
        _sectionViewsArray = [[NSMutableArray alloc] init];
        
        NSInteger NumberOfSections = [self.listOfDebts count];
        for (NSInteger i = 0; i < NumberOfSections; ++i)
        {
            [_sectionViewsArray insertObject:[[NSNull alloc] init] atIndex:i];
        }
    }
    
    return _sectionViewsArray;
}


-(NSDictionary *) deleteElementsWithZeroDebtFromDictionary: (NSDictionary *) dictionary
//метод удаляет элементы с пустыми значениями из dictionary
{
    
    NSMutableDictionary *dict = [dictionary mutableCopy];
    
    for (NSString *key in dictionary)
    {
        NSDictionary *value = [dictionary objectForKey:key];
        NSMutableDictionary *tempDict = [value mutableCopy];
        for (NSString *key2 in value)
        {
            if ([[value objectForKey:key2] integerValue] == 0)
            {
                [tempDict removeObjectForKey:key2]; 
            }
        }
    [dict removeObjectForKey:key];
    [dict setObject:tempDict forKey:key];
    
    }
    dictionary = dict;
    return dictionary;
}


-(NSDictionary *) receiveDictionaryFromCalculationModule
{
    NSURL *urlForArray = [[NSBundle mainBundle] URLForResource:@"names" withExtension:@"plist"];
    NSMutableDictionary  *namesDictionary = [[NSMutableDictionary alloc] initWithContentsOfURL:urlForArray];

    NSMutableArray *testMass = [[NSMutableArray alloc] initWithObjects: nil];
    
    for(NSInteger m = 0; m < [namesDictionary count]*[namesDictionary count]; ++m)
    {
        [testMass addObject:[[NSNumber alloc] initWithInteger:-1]]; // -1 чтобы в отладчике отследить можно было
    }
    
    NSInteger i = 0;
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    
    for( NSString *key in namesDictionary)
    {
        NSDictionary *dictionary = [namesDictionary objectForKey:key];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (NSString *key2 in dictionary)
        {
            [dict setObject:[[NSNumber alloc] initWithInteger:i] forKey:key2];
            [testMass replaceObjectAtIndex:i withObject:[dictionary objectForKey:key2]];
            i++;
        }
        [temp setObject:dict forKey:key];
    }
    
    self.debtsArray = testMass;
    return temp;
}


-(NSDictionary *) listOfDebts
{
    if (!_listOfDebts)
    {
        _listOfDebts = [self receiveDictionaryFromCalculationModule];
    }
    return _listOfDebts;
}

-(NSArray *) numberOfRowsToShowForSection
{
    if(!_numberOfRowsToShowForSection)
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:nil];
        NSArray *keysFromListOfDebts = [self.listOfDebts allKeys];
        for (NSString *key in keysFromListOfDebts)
        {
            NSNumber *num = [[NSNumber alloc]initWithInteger:0];
            [array addObject:num];
        }
        _numberOfRowsToShowForSection = array;
    }
    return _numberOfRowsToShowForSection;
}
/*
-(NSArray *)arrayOfOpenedSectionsAtAppStart
//метод подгружает число строк для каждой секции при старте приложения
//Нужно использовать внутри numberOfRowsToShowForSection lazy inst. если при старте приложения
//все секции должны быть открыты
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:nil];
    
    NSArray *keysFromListOfDebts = [self.listOfDebts allKeys];
    for (NSString *key in keysFromListOfDebts)
    {
        NSDictionary *dict = [self.listOfDebts objectForKey:key];
        NSNumber *num = [[NSNumber alloc]initWithInteger:dict.count];
        [array addObject:num];
    }
    return array;
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.calculationTableView];
    
    self.view.backgroundColor = [SHMAppearance defaultBackgroundColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.navigationItem.title = @"Calculations";
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
    return [[self.numberOfRowsToShowForSection objectAtIndex:section] integerValue]; //вообще надо следить, наверное, чтоб там NSInteger был
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //и тут проверки на объект надо воткнуть на то, какой объект мы передаем    
    return [[self.listOfDebts allKeys] objectAtIndex:section];
}


-(NSNumber *) findDebtForIndexPath:(NSIndexPath *)indexPath inTableView: (UITableView *) tableView
{
    NSString *titleForHeader = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    NSDictionary *debtor = [self.listOfDebts objectForKey:titleForHeader];
    NSArray *names = [debtor allKeys];
    NSInteger indexInDebtsArray = [[debtor objectForKey:[names objectAtIndex:indexPath.row]] integerValue];
    NSNumber *debt = [self.debtsArray objectAtIndex:indexInDebtsArray];
    return debt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    SHMCalculationScreenTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //тут нужна проверка на пустоту namesOfPeopleArray
    cell.textLabel.text = [[self.listOfDebts allKeys] objectAtIndex:indexPath.row];
    NSNumber *debt = [self findDebtForIndexPath:indexPath inTableView:tableView];
    cell.detailTextLabel.text = [debt stringValue];
    
    return cell;
}


-(SHMTableWithOpeningSectionsSectionView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //lazily instatniate headers    
    SHMTableWithOpeningSectionsSectionView *sectionHeader = [[SHMTableWithOpeningSectionsSectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.calculationTableView.bounds.size.width, SHM_HEADER_HEIGHT) title:[[self.listOfDebts allKeys] objectAtIndex:section] section:section state:[[self.openedSectionsArray objectAtIndex:section] boolValue] delegate:self];
    [self.sectionViewsArray replaceObjectAtIndex:section withObject:sectionHeader];
    
    return sectionHeader;
}

#pragma mark -
#pragma mark Focus at chosen cell

-(NSIndexPath *)firstIndexPathInOpenedSection
//поиск строки в таблице
//для фокуса на нее при открытии секции
{
    NSInteger SectionIndex = [self.lastOpenedSection integerValue];
    NSInteger RowIndex = 4;
    return [NSIndexPath indexPathForRow:RowIndex inSection:SectionIndex];
}

-(void)goToCell
//автоматический скролл к нужной ячейке
{
    NSIndexPath *certainIndexPath = [self firstIndexPathInOpenedSection];
    [self.calculationTableView scrollToRowAtIndexPath:certainIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark SectionViewDelegate Methods

-(void)sectionHeaderView:(SHMTableWithOpeningSectionsSectionView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened
//method launches for the section that was just opened by the user
{
    //нужно закрыть единственную открытую секцию и затем открыть новую
    NSInteger previousOpenedSection = -1;   //если тут останется -1, все секции закрыты
    for (NSInteger i = 0; i < [self.openedSectionsArray count]; i++)
    {
        if ([[self.openedSectionsArray objectAtIndex:i]boolValue] == YES ) {
            previousOpenedSection = i; //запомнили открытую секцию. Работать будет только если секции при старте все закрыты! в этом методе закрывается лишь одна секция - нижняя из открытых
        }
    }
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];

    if (previousOpenedSection > -1)
    {
        for (NSInteger i = 0; i < [self.listOfDebts count]; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenedSection]];
        }
        
        if(previousOpenedSection!=sectionOpened){
            SHMTableWithOpeningSectionsSectionView *headerView =[self.sectionViewsArray objectAtIndex:previousOpenedSection];
            [self sectionHeaderView: headerView sectionClosed:previousOpenedSection];
            [headerView toggleOpenWithUserAction:NO];
        }
    }

    //открываем секцию
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < [self.listOfDebts count]; i++)
    {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    UITableViewRowAnimation insertAnimation = UITableViewRowAnimationTop;
    
    NSMutableArray *array = [self.numberOfRowsToShowForSection mutableCopy];
    NSInteger rowsNumberToAdd = /*[[array objectAtIndex:sectionOpened] integerValue] +*/ [indexPathsToInsert count];
    NSNumber *rows = [[NSNumber alloc] initWithInteger:rowsNumberToAdd];
    
    [array replaceObjectAtIndex:sectionOpened withObject:rows];
    self.numberOfRowsToShowForSection = array;
    
    // Apply the updates.
    [self.calculationTableView beginUpdates];
    [self.calculationTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.calculationTableView endUpdates];
    
    NSMutableArray *tempArray = [self.openedSectionsArray mutableCopy];
    [tempArray replaceObjectAtIndex:sectionOpened withObject:[[NSNumber alloc] initWithBool:YES]];
    self.openedSectionsArray = [tempArray copy];
}

-(void)sectionHeaderView:(SHMTableWithOpeningSectionsSectionView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed
//method launches for the section that was just closed by the user
{
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [self.listOfDebts count]; i++)
    {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation deleteAnimation;
    deleteAnimation = UITableViewRowAnimationTop;
    
    NSMutableArray *array = [self.numberOfRowsToShowForSection mutableCopy];
    NSInteger rowsNumberToDelete = [[array objectAtIndex:sectionClosed] integerValue];
    rowsNumberToDelete -= [indexPathsToDelete count];
    NSNumber *rows = [[NSNumber alloc] initWithInteger:rowsNumberToDelete];
    
    [array replaceObjectAtIndex:sectionClosed withObject:rows];
    self.numberOfRowsToShowForSection = array;
    
    // Apply the updates.
    [self.calculationTableView beginUpdates];  //между begin и end не должно
    [self.calculationTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.calculationTableView endUpdates];
    
    NSMutableArray *tempArray = [self.openedSectionsArray mutableCopy];
    [tempArray replaceObjectAtIndex:sectionClosed withObject:[[NSNumber alloc] initWithBool:NO]];
    self.openedSectionsArray = [tempArray copy];
}

@end

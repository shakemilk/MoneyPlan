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
#import "SHMCalculationModule.h"

@interface SHMCalculationScreenViewController () <SHMTableWithOpeningSectionsSectionViewDelegate>

@property (nonatomic, strong) NSArray *numberOfRowsToShowForSection;    //number of rows for each section
@property (nonatomic, strong) NSArray *debtsArray;  //массив долгов. что за хрень? как он формируется?
@property (nonatomic, strong) NSArray *openedSectionsArray; //YES - секция открыта, NO - закрыта

@property (nonatomic, strong) NSArray *namesOfParticipants; //массив имен участников (массив строк)

@property (nonatomic, strong) SHMCalculationModule *calculationModule;

@end

@implementation SHMCalculationScreenViewController

#define SHM_HEADER_HEIGHT 45
#define SHM_ROW_HEIGHT 45
#define SHM_SPACE_FOR_TABBAR 49     //высота таб бара

-(NSArray *) namesOfParticipants
{
    if (_namesOfParticipants == nil){
        _namesOfParticipants = [self.calculationModule getNamesOfParticipants];
    }
    return _namesOfParticipants;
}

-(SHMCalculationModule *) calculationModule{
    
    if (_calculationModule == nil){
        _calculationModule = [SHMCalculationModule sharedInstance];
    }
    
    return _calculationModule;
}

-(NSArray *) debtsArray
{
    if(_debtsArray == nil){
        _debtsArray = [self receiveArrayFromCalculationModule];
    }
    return _debtsArray;
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
        
    }
    
    return _calculationTableView;
}

-(NSArray *) openedSectionsArray
{
    if (!_openedSectionsArray){
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects: nil];
        for (NSInteger i = 0; i < [self.namesOfParticipants count]; ++i){
            [tempArray addObject:[[NSNumber alloc] initWithBool:YES]];
        }
        _openedSectionsArray = [tempArray copy];
    }
    return _openedSectionsArray;
}
 

-(NSDictionary *) deleteElementsWithZeroDebtFromDictionary: (NSDictionary *) dictionary
//метод удаляет элементы с пустыми значениями из dictionary
//пока не используется
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


-(NSArray *) receiveArrayFromCalculationModule
//непонятно, что точно делает этот метод
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
    
    return testMass;
}


-(NSArray *) numberOfRowsToShowForSection
{
    //в каждой секции будет изначально число строк равное числу участников
    if(!_numberOfRowsToShowForSection)
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:nil];
        for (NSString *key in self.namesOfParticipants)
            [array addObject:[[NSNumber alloc] initWithInteger:self.namesOfParticipants.count]];
        _numberOfRowsToShowForSection = array;
    }
    return _numberOfRowsToShowForSection;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.calculationTableView];
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
    return self.namesOfParticipants.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.numberOfRowsToShowForSection objectAtIndex:section] integerValue]; //тест вообще надо следить чтоб там NSInteger был
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //и тут проверки на объект надо воткнуть на то, какой объект мы передаем
    return [self.namesOfParticipants objectAtIndex:section];
}

/*
-(NSNumber *) findDebtForIndexPath:(NSIndexPath *)indexPath inTableView: (UITableView *) tableView
{
    //продолжать
    NSString *debtor = [self.namesOfParticipants objectAtIndex:indexPath.section];

    NSArray *names = [debtor allKeys];
    NSInteger indexInDebtsArray = [[debtor objectForKey:[names objectAtIndex:indexPath.row]] integerValue];
    NSNumber *debt = [self.debtsArray objectAtIndex:indexInDebtsArray];
    return debt;
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    SHMCalculationScreenTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *owner = [self.namesOfParticipants objectAtIndex:indexPath.row];
    NSString *debtor = [self.namesOfParticipants objectAtIndex:indexPath.section];
    //тут нужна проверка на пустоту namesOfPeopleArray
    cell.textLabel.text = owner;
    NSNumber *debt = [self.calculationModule debtOfPerson:debtor toPerson:owner];
    cell.detailTextLabel.text = [debt stringValue];
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //lazily instatniate headers    
    SHMTableWithOpeningSectionsSectionView *sectionHeader = [[SHMTableWithOpeningSectionsSectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.calculationTableView.bounds.size.width, SHM_HEADER_HEIGHT) title:[self.namesOfParticipants     objectAtIndex:section] section:section state:[[self.openedSectionsArray objectAtIndex:section] boolValue] delegate:self];
    
    return sectionHeader;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark SectionViewDelegate Methods

-(void)sectionHeaderView:(SHMTableWithOpeningSectionsSectionView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened
//method launches for the section that was just opened by the user
{
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < [self.namesOfParticipants count]; i++)
    {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    UITableViewRowAnimation insertAnimation = UITableViewRowAnimationTop;
    
    NSMutableArray *array = [self.numberOfRowsToShowForSection mutableCopy];
    NSInteger rowsNumberToAdd = [[array objectAtIndex:sectionOpened] integerValue] + [indexPathsToInsert count];
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
    for (NSInteger i = 0; i < [self.namesOfParticipants count]; i++)
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

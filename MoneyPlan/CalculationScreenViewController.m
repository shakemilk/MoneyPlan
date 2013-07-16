//
//  CalculationScreenViewController.m
//  CalculationScreen
//
//  Created by Mikhail Pogosskiy on 03.07.13.
//  Copyright (c) 2013 Pogosskiy. All rights reserved.
//

#import "SHMCalculationScreenViewController.h"
#import "Foundation/Foundation.h"

@interface SHMCalculationScreenViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *namesOfPeople;   // тут имена из plist

@property (nonatomic, strong) NSArray *numberOfRowsToShow;    //number for each section

@end


#define HEADER_HEIGHT 45

@implementation SHMCalculationScreenViewController

@synthesize tableView = _tableView;
@synthesize namesOfPeople = _namesOfPeople;

@synthesize numberOfRowsToShow = _numberOfRowsToShow;



-(UITableView *) tableView{
    
    if (!_tableView){
        CGFloat x = 0.0;
        CGFloat y = 50.0;
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height - 100;
        
        CGRect tableRect = CGRectMake(x, y, width, height);
        _tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
        
        _tableView.rowHeight = 45;
        _tableView.sectionFooterHeight = 22;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //тут нужна проверка на пустоту namesOfPeople
    
    
    
    cell.textLabel.text = [self.namesOfPeople objectAtIndex:indexPath.row];
    cell.detailTextLabel.frame = CGRectMake(10, 20, 200,22);        // required
    cell.detailTextLabel.text = [self.namesOfPeople objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];   // also required

    /*
    cell.textLabel.text = @"Foo";
    cell.detailTextLabel.text = @"Bar";
    cell.textLabel.frame = CGRectMake(10, 20, 100,22);
    */
    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:10];
    cell.textLabel.backgroundColor=[UIColor redColor];
    cell.textLabel.frame = CGRectMake(10, 20, 100,22);
    cell.detailTextLabel.frame = CGRectMake(10, 20, 200,22);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // this method is called for each cell and returns height
    //NSString * text = @"Your very long text";
    //CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize: 14.0] forWidth:[tableView frame].size.width - 40.0 lineBreakMode:UILineBreakModeWordWrap];
    // return either default height or height to fit the text
    return 44;
}

 */

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark TableViewController Methods


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
        
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"names" withExtension:@"plist"];
    NSDictionary  *namesDictionary = [[NSDictionary alloc] initWithContentsOfURL:url];
    self.namesOfPeople = [namesDictionary objectForKey:@"Names"];
        
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:nil];
    for (NSInteger i = 0; i < self.namesOfPeople.count; i++) {
        NSNumber *num = [[NSNumber alloc]initWithInteger:self.namesOfPeople.count];
        [array addObject:num];
    }
    self.numberOfRowsToShow = array;
    
    //lazily instantiate tableView
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"]; //что это за строка непонятно, но она починила всю таблицу
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

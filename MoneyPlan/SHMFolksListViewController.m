//
//  SHMFolksListViewController.m
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 24.08.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

//Каждому новодобавленному участнику присваивается номер на единицу больший, чем максимальный номер
//в списке имен участников folksNamesDictionary. При удалении строки НОМЕРА НЕ МЕНЯЮТСЯ, т.е.
//список номеров после удаления строк может стать непоследовательным
//как синхронизировать перемену номеров? Может права на задание номеров давать только администратору встречи?


#import "SHMFolksListViewController.h"
#import "SHMAppearance.h"

#define SHM_HEADER_HEIGHT 45
#define SHM_ROW_HEIGHT 45
#define SHM_SPACE_FOR_TABBAR 49     //высота таб бара

const NSInteger kViewTag = 1;

@interface SHMFolksListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation SHMFolksListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tabBarItem.title = @"Folks";
    }
    
    return self;
}

- (NSMutableDictionary *) folksNamesDictionary{
    NSLog(@"method: %@", NSStringFromSelector(_cmd));
    if (_folksNamesDictionary == nil) {
        NSLog( @"here" );
        _folksNamesDictionary = [NSMutableDictionary dictionary];
    }
    return _folksNamesDictionary;
}

- (NSInteger) maxValueInDictionaryWithPositiveIntegerValues: (NSDictionary *) dictionary
//возвращает максимальный индекс в Dictionary. Нужно для добавления нового имени с увеличенным индексом
{
    NSInteger maxValue = 0;
    for (NSString *key in dictionary){
        if ([[dictionary valueForKey:key] integerValue] > maxValue)
            maxValue = [[dictionary valueForKey:key] integerValue];
    }
    
    return maxValue;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [self.view addSubview:self.folksListTableView];
//    [self.view addSubview:self.textField];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.view.backgroundColor = [SHMAppearance defaultBackgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNewFriendWithMaxNumberAndName:(NSString *)name {
    NSInteger maxNumber = [self maxValueInDictionaryWithPositiveIntegerValues:self.folksNamesDictionary];
    [self.folksNamesDictionary setValue:@(maxNumber+1) forKey:name];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
    NSInteger max = [self maxValueInDictionaryWithPositiveIntegerValues: self.folksNamesDictionary];
    
    NSLog(@"before:%@", self.folksNamesDictionary);
    [self.folksNamesDictionary setObject:[NSNumber numberWithInteger:(max + 1)] forKey:textField.text];
    NSLog(@"after:%@", self.folksNamesDictionary);
    
    textField.text = nil;
    [self.tableView reloadData];
    
    
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[self.folksNamesDictionary allKeys] objectAtIndex:indexPath.row];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.folksNamesDictionary allKeys] count];
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.folksNamesDictionary removeObjectForKey:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SHM_ROW_HEIGHT;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

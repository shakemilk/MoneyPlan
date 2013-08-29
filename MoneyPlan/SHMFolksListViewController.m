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

#define SHM_HEADER_HEIGHT 45
#define SHM_ROW_HEIGHT 45
#define SHM_SPACE_FOR_TABBAR 49     //высота таб бара

#define kTextFieldWidth	280.0
#define kTextFieldHeight 30.0
#define kLeftMargin 20.0
#define kTopMargin 5.0

const NSInteger kViewTag = 1;


@interface SHMFolksListViewController ()

@property (nonatomic, strong) UITableView *folksListTableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableDictionary *folksNamesDictionary; //имена участников. Состоит из имени участника (Key) и присвоенного ему номера (Value)

@end

@implementation SHMFolksListViewController

@synthesize folksNamesDictionary = _folksNamesDictionary;


-(UITableView *) folksListTableView{
    
    if (_folksListTableView == nil){
        CGFloat x = 0.0;
        CGFloat y = kTopMargin + kTextFieldHeight;
        CGFloat width = self.view.frame.size.width;
#warning TODO: Поправить размеры таблицы когда будет дизайн
        CGFloat height = self.view.frame.size.height - SHM_SPACE_FOR_TABBAR - 45;
        CGRect rect = CGRectMake(x, y, width, height);
        
        _folksListTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
        _folksListTableView.rowHeight = SHM_ROW_HEIGHT;
        _folksListTableView.sectionHeaderHeight = SHM_HEADER_HEIGHT;
        _folksListTableView.scrollEnabled = YES;
        _folksListTableView.showsVerticalScrollIndicator = YES;
        _folksListTableView.userInteractionEnabled = YES;
        _folksListTableView.bounces = YES;
        
        _folksListTableView.delegate = self;
        _folksListTableView.dataSource = self;
        
        [_folksListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
    }
    
    return _folksListTableView;
}


#pragma mark -
#pragma mark Text Field

- (UITextField *) textField
{
	if (_textField == nil)
	{
		CGRect frame = CGRectMake(kLeftMargin, kTopMargin, kTextFieldWidth, kTextFieldHeight);
		_textField = [[UITextField alloc] initWithFrame:frame];
		
		_textField.borderStyle = UITextBorderStyleRoundedRect;
		_textField.textColor = [UIColor blackColor];
		_textField.font = [UIFont systemFontOfSize:17.0];
		_textField.placeholder = @"<add a new man>";
		_textField.backgroundColor = [UIColor whiteColor];
		_textField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		_textField.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
		_textField.returnKeyType = UIReturnKeyDone;
		
		_textField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		_textField.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
		
		_textField.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
		
		// Add an accessibility label that describes what the text field is for.
		[_textField setAccessibilityLabel:NSLocalizedString(@"AddNewParticipantField", @"")];
	}
	return _textField;
}

- (NSMutableDictionary *) folksNamesDictionary{
    NSLog(@"method: %@", NSStringFromSelector(_cmd));
    if (_folksNamesDictionary == nil) {
        NSLog( @"here" );
        _folksNamesDictionary = [[NSMutableDictionary alloc] init];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view addSubview:self.folksListTableView];
    [self.view addSubview:self.textField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark public methods returning the names of participants

- (NSArray *) getNamesOfParticipants
{
    return [[self.folksNamesDictionary allKeys] copy];
}

- (NSDictionary *) getNamesOfParticipantsWithNumbers
{
    return [self.folksNamesDictionary copy];
-(void)addNewFriendWithMaxNumberAndName:(NSString *)name {
    NSInteger maxNumber = [self maxValueInDictionaryWithPositiveIntegerValues:self.folksNamesDictionary];
    [self.folksNamesDictionary setValue:@(maxNumber+1) forKey:name];
}

- (NSInteger) getParticipantNumberForName:(NSString *)Name
{
    return [[self.folksNamesDictionary valueForKey:Name] integerValue];
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
    [self.folksListTableView reloadData];
    
    
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

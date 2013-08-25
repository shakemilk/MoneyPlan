//
//  SHMFolksListViewController.m
//  MoneyPlan
//
//  Created by Mikhail Pogosskiy on 24.08.13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//
#import "SHMFolksListViewController.h"

#define SHM_HEADER_HEIGHT 45
#define SHM_ROW_HEIGHT 45
#define SHM_SPACE_FOR_TABBAR 49     //высота таб бара
#define kTextFieldWidth	260.0

#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			6.0

#define kTextFieldHeight		30.0

const NSInteger kViewTag = 1;


@interface SHMFolksListViewController ()

@property (nonatomic, strong) UITableView *folksListTableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSDictionary *folksNamesDictionary; //имена участников. Состоит из имени участника (Key) и присвоенного ему номера (Value)

@end

@implementation SHMFolksListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(UITableView *) folksListTableView{
    
    if (!_folksListTableView){
        CGFloat x = 0.0;
        CGFloat y = 0.0;
        CGFloat width = self.view.frame.size.width;
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
#pragma mark Text Fields

- (UITextField *) textField
{
	if (!_textField)
	{
		CGRect frame = CGRectMake(kLeftMargin, 8.0, kTextFieldWidth, kTextFieldHeight);
		_textField = [[UITextField alloc] initWithFrame:frame];
		
		_textField.borderStyle = UITextBorderStyleBezel;
		_textField.textColor = [UIColor blackColor];
		_textField.font = [UIFont systemFontOfSize:17.0];
		_textField.placeholder = @"<enter text>";
		_textField.backgroundColor = [UIColor whiteColor];
		_textField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		_textField.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
		_textField.returnKeyType = UIReturnKeyDone;
		
		_textField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		
		_textField.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
		
		_textField.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
		
		// Add an accessibility label that describes what the text field is for.
		[_textField setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}
	return _textField;
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
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.folksNamesDictionary allKeys] count];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

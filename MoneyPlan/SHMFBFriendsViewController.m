//
//  SHMFBFriendsViewController.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 8/29/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMFBFriendsViewController.h"
#import "SHMFolksListViewController.h"

@interface SHMFBFriendsViewController ()

@property (nonatomic, strong) NSArray *arrayOfFriends;

@end

@implementation SHMFBFriendsViewController

-(NSArray *)arrayOfFriends {
    if (!_arrayOfFriends) {
        _arrayOfFriends = [NSArray arrayWithObjects:@"Миша Грушин", @"Надя Шмакова", @"Миша Погосский", nil];
    }
    
    return _arrayOfFriends;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.arrayOfFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [self.arrayOfFriends objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITabBarController *tabBar = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    SHMFolksListViewController *parent = [tabBar.viewControllers objectAtIndex:1];
    [parent addNewFriendWithMaxNumberAndName:[self.arrayOfFriends objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

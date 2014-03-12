//
//  SHMPartiesViewController.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 30/10/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMPartiesViewController.h"
#import "SHMAppearance.h"
#import "SHMTabBarController.h"
#import "SHMButtonCollectionViewCell.h"
#import "SHMPartyCollectionViewCell.h"
#import "SHMAlertView.h"
#import "SHMEvent.h"
#import "SHMCoreDataManager.h"
#import "SHMManagedObjectContext.h"

@interface SHMPartiesViewController () <UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SHMButtonCollectionViewCellDelegate, SHMAlertViewDelegate>

@property (nonatomic, strong) SHMTabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *partiesArray;
@end

@implementation SHMPartiesViewController

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
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [SHMAppearance defaultBackgroundColor];
    [self.collectionView registerClass:[SHMButtonCollectionViewCell class] forCellWithReuseIdentifier:@"ButtonCell"];
    [self.collectionView registerClass:[SHMPartyCollectionViewCell class] forCellWithReuseIdentifier:@"PartyCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)partiesArray {
    if (!_partiesArray) {
        _partiesArray = @[].mutableCopy;
        NSManagedObjectContext *context = [SHMCoreDataManager mainContext];
        NSError *error;
        NSArray *events = [context executeFetchRequest:[SHMEvent eventsFetchRequest] error:&error];
        if (!error) {
            [_partiesArray addObjectsFromArray:events];
        }
    }
    
    return _partiesArray;
}

#pragma mark - Collection view data source

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        SHMPartyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PartyCell" forIndexPath:indexPath];
        SHMEvent *party = self.partiesArray[indexPath.row-1];
        [cell configureWithEvent:party];
        return cell;
    } else {
        SHMButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ButtonCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.partiesArray.count + 1;
}

#pragma mark - Collection view delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        SHMTabBarController *tabBarController = [[SHMTabBarController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
        navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:navController animated:YES completion:nil];
    }
}

#pragma mark - Collection view flow layout delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(95.f, 100.f);
}

#pragma mark - Button cell delegate

-(void)buttonCellWasTappedForNewEvent:(SHMButtonCollectionViewCell *)cell {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Новое событие" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Создать новое событие", @"Присоединиться к событию", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - Action Sheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        SHMAlertView *alertView;
        if (buttonIndex == 0) {
            alertView = [[SHMAlertView alloc] initWithTitle:@"Создание события" type:SHMAlertViewTypeCreateNewEvent];
        } else {
            alertView = [[SHMAlertView alloc] initWithTitle:@"Участие в событии" type:SHMAlertViewTypeJoinExistingEvent];
        }
        alertView.delegate = self;
        [alertView show];
    }
}

#pragma mark - SHMAlertView delegate

-(void)alertView:(SHMAlertView *)alertView createEventWithName:(NSString *)name date:(NSDate *)date {
    NSManagedObjectContext *context = [SHMCoreDataManager mainContext];
    [context performBlockAndSaveOrReset:^BOOL(NSError *__autoreleasing *error) {
        SHMEvent *event = [SHMEvent insertInManagedObjectContext:context];
        event.name = name;
        event.date = date;
        [self.partiesArray addObject:event];
        return YES;
    } completion:^(BOOL success, NSError *error) {
        if (success && !error) {
            [self.collectionView reloadData];
        }
    }];
}

-(void)alertView:(SHMAlertView *)alertView joinEventWithID:(NSString *)eventID {
//    [self.collectionView performBatchUpdates:^{
//        SHMEvent *newParty = [[[SHMEvent alloc] init];
//        newParty.name = @"День рождения Маши";
//        newParty.date = [NSDate date];
//        [self.partiesArray addObject:newParty];
//        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:self.partiesArray.count inSection:0];
//        [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
//    } completion:^(BOOL finished) {
//        [self.collectionView reloadData];
//    }];
}

-(void)alertView:(SHMAlertView *)alertView didCancelWithType:(SHMAlertViewType)type {
    
}

@end

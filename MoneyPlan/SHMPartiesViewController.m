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

@interface SHMPartiesViewController () <UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SHMButtonCollectionViewCellDelegate>

@property (nonatomic, strong) SHMTabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSUInteger numberOfEvents;

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

#pragma mark - Collection view data source

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        SHMPartyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PartyCell" forIndexPath:indexPath];
        return cell;
    } else {
        SHMButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ButtonCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfEvents + 1;
}

#pragma mark - Collection view flow layout delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(95.f, 100.f);
}

#pragma mark - Button cell delegate 

-(void)buttonCellWasTappedForNewEvent:(SHMButtonCollectionViewCell *)cell {
    [self.collectionView performBatchUpdates:^{
        self.numberOfEvents++;
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:self.numberOfEvents inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}

#pragma mark - Action Sheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        self.tabBarController = [[SHMTabBarController alloc] initWithNibName:nil bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
        [self presentViewController:self.navigationController animated:YES completion:nil];
    }
}

@end

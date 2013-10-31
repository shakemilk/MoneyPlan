//
//  SHMButtonCollectionViewCell.h
//  MoneyPlan
//
//  Created by Mikhail Grushin on 31/10/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHMButtonCollectionViewCell;

@protocol SHMButtonCollectionViewCellDelegate <NSObject>

-(void)buttonCellWasTappedForNewEvent:(SHMButtonCollectionViewCell *)cell;

@end

@interface SHMButtonCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<SHMButtonCollectionViewCellDelegate> delegate;

@end

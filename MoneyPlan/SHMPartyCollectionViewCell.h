//
//  SHMPartyCollectionViewCell.h
//  MoneyPlan
//
//  Created by Mikhail Grushin on 30/10/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHMEvent;

@interface SHMPartyCollectionViewCell : UICollectionViewCell

-(void)configureWithEvent:(SHMEvent *)event;

@end

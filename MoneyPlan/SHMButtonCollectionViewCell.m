//
//  SHMButtonCollectionViewCell.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 31/10/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMButtonCollectionViewCell.h"

@interface SHMButtonCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation SHMButtonCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    UINib *nib = [UINib nibWithNibName:@"SHMButtonCollectionViewCell" bundle:[NSBundle mainBundle]];
    self = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    return self;
}

- (IBAction)tapToNewEvent:(id)sender {
    if ([self.delegate respondsToSelector:@selector(buttonCellWasTappedForNewEvent:)]) {
        [self.delegate buttonCellWasTappedForNewEvent:self];
    }
}

@end

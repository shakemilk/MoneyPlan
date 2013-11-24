//
//  SHMPartyCollectionViewCell.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 30/10/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMPartyCollectionViewCell.h"

@interface SHMPartyCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@end

@implementation SHMPartyCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    UINib *nib = [UINib nibWithNibName:@"SHMPartyCollectionViewCell" bundle:[NSBundle mainBundle]];
    self = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    return self;
}

-(void)configureWithEventName:(NSString *)name dateString:(NSString *)dateString {
    self.dateLabel.text = dateString;
    self.descriptionLabel.text = name;
}

@end

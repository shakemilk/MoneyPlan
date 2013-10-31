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

//-(void)prepareForReuse {
//    self.dateLabel.text = @"";
//    self.descriptionLabel.text = @"";
//}

-(void)configureWithEventName:(NSString *)name description:(NSString *)description {
    self.dateLabel.text = name;
    self.descriptionLabel.text = description;
}

@end

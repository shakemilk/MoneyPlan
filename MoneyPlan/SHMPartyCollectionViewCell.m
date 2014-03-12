//
//  SHMPartyCollectionViewCell.m
//  MoneyPlan
//
//  Created by Mikhail Grushin on 30/10/13.
//  Copyright (c) 2013 Shakemilk. All rights reserved.
//

#import "SHMPartyCollectionViewCell.h"
#import "SHMEvent.h"

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

- (void)prepareForReuse {
    _dateLabel.text = nil;
    _descriptionLabel.text = nil;
}

-(void)configureWithEvent:(SHMEvent *)event {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd.MM.yy";
    self.dateLabel.text = [dateFormatter stringFromDate:event.date];
    self.descriptionLabel.text = event.name;
}

@end

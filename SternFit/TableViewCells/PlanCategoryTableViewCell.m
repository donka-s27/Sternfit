//
//  PlanCategoryTableViewCell.m
//  SternFit
//
//  Created by MacOS on 1/30/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import "PlanCategoryTableViewCell.h"

@implementation PlanCategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(NSString *) value {
    self.labelValue.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    self.labelValue.text = value;
}

@end

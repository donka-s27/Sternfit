//
//  SharedFittabTableViewCell.m
//  SternFit
//
//  Created by MacOS on 1/12/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import "SharedFittabTableViewCell.h"

@implementation SharedFittabTableViewCell

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

@end

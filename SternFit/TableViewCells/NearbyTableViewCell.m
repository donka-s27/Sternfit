//
//  NearbyTableViewself.m
//  SternFit
//
//  Created by MacOS on 12/16/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "NearbyTableViewCell.h"
#import "AppDelegate.h"

@implementation NearbyTableViewCell

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

- (void) setData:(Friend*) user {
    self.labelUsername.font = [UIFont fontWithName:@"Lato-Bold" size:16.0f];
    self.labelMessage.font = [UIFont fontWithName:@"Lato-Regular" size:13.0f];
    self.labelDistance.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    self.labelTimer.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([user.image isEqual:@""]) {
        [self.imgAvator setImage:[UIImage imageNamed:@"avator.png"]];
    } else {
        [self.imgAvator setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.imgAvator setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, user.image]]];
    }
    UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    self.imgAvator.layer.borderColor = borderColor.CGColor;
    self.imgAvator.layer.borderWidth = 3.0f;
    self.imgAvator.layer.cornerRadius = 30.0f;
    self.imgAvator.layer.masksToBounds = YES;
    if (user.gender == YES) {
        UIColor *borderColor1 = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
        self.imgAvator.layer.borderColor = borderColor1.CGColor;
    } else {
        UIColor *borderColor1 = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:90.0f/255.0f alpha:1];
        self.imgAvator.layer.borderColor = borderColor1.CGColor;
    }
    
    self.labelStatus.layer.borderColor = borderColor.CGColor;
    self.labelStatus.layer.borderWidth = 2.0f;
    self.labelStatus.layer.cornerRadius = 7.5f;
    if (user.status == NO) {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
    } else {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:227.0f/255.0f blue:54.0f/255.0f alpha:1];
    }
    
    self.labelUsername.text = user.name;
    self.labelMessage.text = user.message;
    double distance = user.distance;
    if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
        self.labelDistance.text = [NSString stringWithFormat:@"%.2f mi", distance];
    } else {
        distance = distance * 1.60934f;
        self.labelDistance.text = [NSString stringWithFormat:@"%.2f km", distance];
    }
    
    int mins = user.lastupdatetime;
    
    if (mins / 60 == 0)
        self.labelTimer.text = [NSString stringWithFormat:@"%dmins ago", mins, NSLocalizedString(@"ago", nil)];
    else if (mins / 60 < 24)
        self.labelTimer.text = [NSString stringWithFormat:@"%dh %dm ago", mins / 60, mins % 60, NSLocalizedString(@"ago", nil)];
    else {
        self.labelTimer.text = [NSString stringWithFormat:@"%d %@ %@", (mins / 60 / 24) + 1, NSLocalizedString(@"days", nil), NSLocalizedString(@"ago", nil)];
    }
    /*UITapGestureRecognizer *btntap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnhandlegesture:)];
    self.btnTap.tag = indexPath.row;
    [self.btnTap addGestureRecognizer:btntap];
    */
    //[self.btnAddFriend setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(@"Add Friend", nil)] forState:UIControlStateNormal];
    //[self.btnChat setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(@"Chat", nil)] forState:UIControlStateNormal];
    
    if (user.isFriend == 1) {
        [self.btnAddFriend setImage:[UIImage imageNamed:@"friends_chat.png"] forState:UIControlStateNormal];
    } else if (user.isFriend == 2) {
        [self.btnAddFriend setImage:[UIImage imageNamed:@"nearby_pending.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)btnTapClicked:(id)sender {
    [self.parent gotoOtherProfile:self.index];
}
- (IBAction)btnAddFriendClicked:(id)sender {
    [self.parent addFriend:self.index];
}

@end

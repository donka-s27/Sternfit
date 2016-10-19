//
//  NearbyTableViewCell.h
//  SternFit
//
//  Created by MacOS on 12/16/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "Friend.h"
#import "NearbyViewController.h"

@interface NearbyTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet AsyncImageView *imgAvator;
@property (nonatomic, strong) IBOutlet UILabel *labelStatus;
@property (nonatomic, strong) IBOutlet UILabel *labelUsername;
@property (nonatomic, strong) IBOutlet UILabel *labelMessage;
@property (nonatomic, strong) IBOutlet UILabel *labelDistance;
@property (nonatomic, strong) IBOutlet UIButton *btnAddFriend;
@property (nonatomic, strong) IBOutlet UILabel *labelTimer;
@property (nonatomic, strong) IBOutlet UIButton *btnTap;

@property (nonatomic) int index;
@property (nonatomic, strong) NearbyViewController *parent;

- (void)setData:(Friend*) user;
- (IBAction)btnTapClicked:(id)sender;
- (IBAction)btnAddFriendClicked:(id)sender;

@end

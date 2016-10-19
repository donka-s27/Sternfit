//
//  FriendsTableViewCell.h
//  SternFit
//
//  Created by MacOS on 12/19/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "Friend.h"
#import "FriendsViewController.h"

@interface FriendsTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet AsyncImageView *imgAvator;
@property (nonatomic, strong) IBOutlet UILabel *labelStatus;
@property (nonatomic, strong) IBOutlet UILabel *labelUsername;
@property (nonatomic, strong) IBOutlet UILabel *labelMessage;
@property (nonatomic, strong) IBOutlet UILabel *labelDistance;
@property (nonatomic, strong) IBOutlet UIButton *btnChat;
@property (nonatomic, strong) IBOutlet UILabel *labelTimer;
@property (nonatomic, strong) IBOutlet UIButton *btnTap;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;
@property (nonatomic, strong) IBOutlet UIButton *btnTap1;

@property (nonatomic, strong) FriendsViewController *parent;
@property (nonatomic) int index;

- (void)setData:(Friend*) user;
- (IBAction)btnTapClicked:(id)sender;
- (IBAction)btnDeleteClicked:(id)sender;
- (IBAction)btnTap1Clicked:(id)sender;
- (IBAction)btnChatClicked:(id)sender;

@end

//
//  NotificationTableViewCell.h
//  SternFit
//
//  Created by MacOS on 12/18/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "NotificationViewController.h"

@interface NotificationTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet AsyncImageView *imgAvator;
@property (nonatomic, strong) IBOutlet UILabel *labelStatus;
@property (nonatomic, strong) IBOutlet UILabel *labelName;
@property (nonatomic, strong) IBOutlet UILabel *labelMessage;
@property (nonatomic, strong) IBOutlet UILabel *labelTime;
@property (nonatomic, strong) IBOutlet UIButton *btnAccept;
@property (nonatomic, strong) IBOutlet UIButton *btnDecline;
@property (nonatomic, strong) IBOutlet UIButton *btnAddFriend;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;
@property (nonatomic, strong) IBOutlet UIButton *btnTap;

@property (nonatomic) int index;
@property (nonatomic, strong) NotificationViewController *controller;

- (void) setData:(NSMutableDictionary *) user;
- (IBAction)btnAddFriendClicked:(id)sender;
- (IBAction)btnAcceptFriendClicked:(id)sender;
- (IBAction)btnDeclineFriendClicked:(id)sender;
- (IBAction)btnDeleteNotificationClicked:(id)sender;
- (IBAction)btnFriendTapClicked:(id)sender;

@end

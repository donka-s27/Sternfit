//
//  MessageTableViewCell.h
//  SternFit
//
//  Created by MacOS on 12/18/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "MessageViewController.h"
#import "Message.h"

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet AsyncImageView *imgProfile;
@property (nonatomic, strong) IBOutlet UILabel *labelUsername;
@property (nonatomic, strong) IBOutlet UILabel *labelMessage;
@property (nonatomic, strong) IBOutlet UILabel *labelDistance;
@property (nonatomic, strong) IBOutlet UILabel *labelLastUpdateTime;
@property (nonatomic, strong) IBOutlet UILabel *labelMessageTime;
@property (nonatomic, strong) IBOutlet UILabel *labelStatus;
@property (nonatomic, strong) IBOutlet UILabel *labelNum;
@property (nonatomic, strong) IBOutlet UIImageView *imgDistance;
@property (nonatomic, strong) IBOutlet UIImageView *imgLastUpdateTime;

@property (nonatomic, strong) MessageViewController *parent;
@property (nonatomic) int index;

- (IBAction)btnProfilePictureClicked:(id)sender;
- (IBAction)btnBodyClicked:(id)sender;
- (IBAction)btnDeleteClicked:(id)sender;
- (void)setData:(Message*)message;
@end

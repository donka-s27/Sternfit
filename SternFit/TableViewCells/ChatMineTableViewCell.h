//
//  ChatMineTableViewCell.h
//  SternFit
//
//  Created by MacOS on 1/21/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "ChatViewController.h"

@interface ChatMineTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *labelDate;
@property (nonatomic, strong) IBOutlet UIView *viewMessage;
@property (nonatomic, strong) IBOutlet UIView *viewAvator;
@property (nonatomic, strong) IBOutlet AsyncImageView *imgAvator;
@property (nonatomic, strong) IBOutlet UILabel *labelOnline;
@property (nonatomic, strong) IBOutlet UIImageView *imgMessageBack;
@property (nonatomic, strong) IBOutlet UILabel *labelMessage;
@property (nonatomic, strong) IBOutlet AsyncImageView *imgEmoji;
@property (nonatomic, strong) IBOutlet UILabel *labelGroupChat;

@property (nonatomic, strong) ChatViewController *parent;

- (void) setData:(NSMutableDictionary *) message;
- (float) cellHeight;
- (IBAction)btnProfileClicked:(id)sender;

@end

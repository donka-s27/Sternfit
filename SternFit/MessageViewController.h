//
//  MessageViewController.h
//  SternFit
//
//  Created by MacOS on 12/10/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *labelPageTitle;
@property (nonatomic, strong) IBOutlet UITableView *messagesTableView;
@property (nonatomic) BOOL pullToRefreshFlag;

- (IBAction)btnAddGroupClicked:(id)sender;
- (void) gotoFittab:(int) index;
- (void) gotoChatroom:(int) index;
- (void) deleteMessage:(int) index;

- (void) loadMessages;

@end

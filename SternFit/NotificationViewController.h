//
//  NotificationViewController.h
//  SternFit
//
//  Created by MacOS on 12/10/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *notificationTableView;
@property (nonatomic, strong) IBOutlet UILabel *labelPageTitle;

- (void) reloadTable;
- (void)addFriend:(int) index;
- (void)acceptFriendRequest:(int) index;
- (void)declineFriendRequest:(int) index;
- (void)deleteNotification:(int) index;
- (void) checkNotification:(int) index;

@end

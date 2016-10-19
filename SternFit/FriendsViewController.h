//
//  FriendsViewController.h
//  SternFit
//
//  Created by MacOS on 12/11/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *labelPageTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelGroupChat;
@property (nonatomic, strong) IBOutlet UITextField *txtSearch;
@property (nonatomic, strong) IBOutlet UITableView *friendsTableView;
@property (nonatomic, strong) IBOutlet UILabel *labelSort1;
@property (nonatomic, strong) IBOutlet UILabel *labelSort2;
@property (nonatomic, strong) IBOutlet UILabel *labelSortLocation;
@property (nonatomic, strong) IBOutlet UILabel *labelSortDistance;
@property (nonatomic, strong) IBOutlet UILabel *labelSortAlpha;
@property (nonatomic, strong) IBOutlet UIView *overlayView1;
@property (nonatomic, strong) IBOutlet UIView *sortView;
@property (nonatomic) BOOL pullToRefreshFlag;

- (IBAction)btnSearchClicked:(id)sender;
- (IBAction)btnGroupChatClicked:(id)sender;
- (IBAction)btnSortMenuShowClicked:(id)sender;
- (IBAction)btnSortMenuHideClicked:(id)sender;
- (IBAction)btnSortByLocationClicked:(id)sender;
- (IBAction)btnSortByDistanceClicked:(id)sender;
- (IBAction)btnSortByAlphaClicked:(id)sender;
- (void) refreshFriends;

- (void)chatFriendClick:(int) index;
- (void)deleteFriendClick:(int) index;
- (void)tapClick:(int) index;

@end

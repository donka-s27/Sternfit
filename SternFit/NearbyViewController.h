//
//  NearbyViewController.h
//  SternFit
//
//  Created by MacOS on 12/10/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPopoverSlider.h"
#import "NMRangeSlider.h"
#import "AsyncImageView.h"

@interface NearbyViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet AsyncImageView *imgProfile;
@property (nonatomic, strong) IBOutlet UIImageView *imgPhoto1;
@property (nonatomic, strong) IBOutlet UIImageView *imgPhoto2;
@property (nonatomic, strong) IBOutlet UIImageView *imgPhoto3;
@property (nonatomic, strong) IBOutlet UIImageView *imgPhoto4;
@property (nonatomic, strong) IBOutlet UIImageView *imgPhoto5;
@property (nonatomic, strong) IBOutlet UILabel *labelUsername;
@property (nonatomic, strong) IBOutlet UILabel *labelQuote;
@property (nonatomic, strong) IBOutlet UILabel *labelAge;
@property (nonatomic, strong) IBOutlet UILabel *labelHeight;
@property (nonatomic, strong) IBOutlet UILabel *labelWeight;
@property (nonatomic, strong) IBOutlet UILabel *labelNearbyTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnFilter;
@property (nonatomic, strong) IBOutlet UITableView *friendsTableView;
@property (nonatomic, strong) IBOutlet UITextField *txtSearch;
@property (nonatomic, strong) IBOutlet UIView *nearbyView1;
@property (nonatomic, strong) IBOutlet UIView *nearbyView2;
@property (nonatomic, strong) IBOutlet UILabel *labelStatus;

@property (nonatomic) BOOL pullToRefreshFlag;

- (IBAction)btnFilterClicked:(id)sender;
- (void) refreshUsers;
- (void) gotoOtherProfile:(int) index;
- (void)addFriend:(int) index;

@end

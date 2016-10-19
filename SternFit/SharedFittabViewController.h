//
//  SharedFittabViewController.h
//  SternFit
//
//  Created by MacOS on 1/12/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharedFittabViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *labelPageTitle;
@property (nonatomic, strong) IBOutlet UITableView *friendsTableView;
@property (nonatomic, strong) IBOutlet UILabel *labelSortLocation;
@property (nonatomic, strong) IBOutlet UILabel *labelSortDistance;
@property (nonatomic, strong) IBOutlet UILabel *labelSortAlpha;
@property (nonatomic, strong) IBOutlet UIView *overlayView1;
@property (nonatomic, strong) IBOutlet UIView *sortView;

- (IBAction)btnSortMenuShowClicked:(id)sender;
- (IBAction)btnSortMenuHideClicked:(id)sender;
- (IBAction)btnSortByLocationClicked:(id)sender;
- (IBAction)btnSortByDistanceClicked:(id)sender;
- (IBAction)btnSortByAlphaClicked:(id)sender;

@end

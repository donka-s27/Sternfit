//
//  StartGroupViewController.h
//  SternFit
//
//  Created by MacOS on 12/18/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface StartGroupViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *groupLabelTitle;
@property (nonatomic, strong) IBOutlet UITextField *groupTxtSearch;
@property (nonatomic, strong) IBOutlet UITableView *groupUsersTableView;
@property (nonatomic, strong) IBOutlet UIButton *groupBtnCancel;
@property (nonatomic, strong) IBOutlet UIButton *groupBtnOK;
@property (nonatomic, strong) IBOutlet UIView *groupView;

- (IBAction)btnSearchClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;
- (IBAction)btnOKClicked:(id)sender;

@end

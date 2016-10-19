//
//  SideMenuViewController.h
//  SternFit
//
//  Created by MacOS on 12/10/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, retain) UIViewController *parentViewController;

@property (nonatomic, strong) IBOutlet UIImageView *imgAvator;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelSubtitle;
@property (nonatomic, strong) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) IBOutlet UILabel *labelStatus;

- (IBAction)btnProfileClicked:(id)sender;

@end

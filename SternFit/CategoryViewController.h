//
//  CategoryViewController.h
//  SternFit
//
//  Created by MacOS on 1/19/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CategoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *exerciseLabelTitle;
@property (nonatomic, strong) IBOutlet UITextField *exerciseTxtSearch;
@property (nonatomic, strong) IBOutlet UITableView *exerciseTableView;

- (IBAction)btnBackClicked:(id)sender;

@end

//
//  ExerciseViewController.h
//  SternFit
//
//  Created by MacOS on 12/22/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ExerciseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *exerciseLabelTitle;
@property (nonatomic, strong) IBOutlet UITextField *exerciseTxtSearch;
@property (nonatomic, strong) IBOutlet UITableView *exerciseTableView;

@property (nonatomic) int selectCatId;
@property (nonatomic, strong) NSString *exerciseName;

- (IBAction)btnBackClicked:(id)sender;

@end

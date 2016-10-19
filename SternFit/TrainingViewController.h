//
//  TrainingViewController.h
//  SternFit
//
//  Created by MacOS on 12/11/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *labelWeekday1;
@property (nonatomic, strong) IBOutlet UILabel *labelWeekday2;
@property (nonatomic, strong) IBOutlet UILabel *labelWeekday3;
@property (nonatomic, strong) IBOutlet UILabel *labelWeekday4;
@property (nonatomic, strong) IBOutlet UILabel *labelWeekday5;
@property (nonatomic, strong) IBOutlet UILabel *labelWeekday6;
@property (nonatomic, strong) IBOutlet UILabel *labelWeekday7;
@property (nonatomic, strong) IBOutlet UILabel *labelWeekdayHighlight1;
@property (nonatomic, strong) IBOutlet UILabel *labelWeekdayHighlight2;
@property (nonatomic, strong) IBOutlet UILabel *labelWeekdayHighlight3;
@property (nonatomic, strong) IBOutlet UILabel *labelWeekdayHighlight4;
@property (nonatomic, strong) IBOutlet UILabel *labelWeekdayHighlight5;
@property (nonatomic, strong) IBOutlet UILabel *labelWeekdayHighlight6;
@property (nonatomic, strong) IBOutlet UILabel *labelWeekdayHighlight7;
@property (nonatomic, strong) IBOutlet UILabel *labelPageTitle;
@property (nonatomic, strong) IBOutlet UIView *planView;
@property (nonatomic, strong) IBOutlet UITableView *planTableView;
@property (nonatomic, strong) IBOutlet UIButton *btnSave;
@property (nonatomic, strong) IBOutlet UIButton *btnShare;
@property (nonatomic, strong) IBOutlet UIView *overlayView1;
@property (nonatomic, strong) IBOutlet UIView *shareView;
@property (nonatomic, strong) IBOutlet UIImageView *imgEditMode;

@property (nonatomic) int planIndex;

- (IBAction)btnAddPlanClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnShareClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnEditModeClicked:(id)sender;

- (void) hideShareView;

@end

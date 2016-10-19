//
//  DetailViewController.h
//  SternFit
//
//  Created by MacOS on 1/19/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Exercise.h"
#import "AsyncImageView.h"
#import "TrainingPlan.h"
#import "DietPlan.h"
#import "SupplementPlan.h"

@interface DetailViewController :  UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIView *detailView;
@property (nonatomic, strong) IBOutlet UILabel *detailLabelTitle;
@property (nonatomic, strong) IBOutlet UITextView *detailSummary;
@property (nonatomic, strong) IBOutlet AsyncImageView *detailImage;
@property (nonatomic, strong) IBOutlet UIView *detailSubView1;
@property (nonatomic, strong) IBOutlet UIView *detailSubView2;
@property (nonatomic, strong) IBOutlet UIView *detailSubView3;
@property (nonatomic, strong) IBOutlet UIView *detailSubView4;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView1;
@property (nonatomic, strong) IBOutlet UIButton *btnSave;

@property (nonatomic, strong) Exercise *exercise;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic) int planIndex;
@property (nonatomic) int planId;
@property (nonatomic, strong) TrainingPlan *tPlan;
@property (nonatomic, strong) DietPlan *dPlan;
@property (nonatomic, strong) SupplementPlan *sPlan;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;

@end

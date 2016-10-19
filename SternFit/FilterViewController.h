//
//  FilterViewController.h
//  SternFit
//
//  Created by MacOS on 1/12/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPopoverSlider.h"
#import "NMRangeSlider.h"

@interface FilterViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIView *filterView;
@property (nonatomic, strong) IBOutlet UILabel *filterLabelTitle;
@property (nonatomic, strong) IBOutlet UILabel *filterLabelGender;
@property (nonatomic, strong) IBOutlet UILabel *filterLabelGenderValue;
@property (nonatomic, strong) IBOutlet UILabel *filterLabelAge;
@property (nonatomic, strong) IBOutlet UILabel *filterLabelAgeValue;
@property (nonatomic, strong) IBOutlet UILabel *filterLabelAppear;
@property (nonatomic, strong) IBOutlet UILabel *filterLabelAppearValue;
@property (nonatomic, strong) IBOutlet UILabel *filterLabelDistance;
@property (nonatomic, strong) IBOutlet UILabel *filterLabelDistanceValue;
@property (nonatomic, strong) IBOutlet UIButton *filterBtnMale;
@property (nonatomic, strong) IBOutlet UIButton *filterBtnFemale;
@property (nonatomic, strong) IBOutlet UIButton *filterBtn100;
@property (nonatomic, strong) IBOutlet UIButton *filterBtn500;
@property (nonatomic, strong) IBOutlet UIButton *filterBtn1000;
@property (nonatomic, strong) IBOutlet NMRangeSlider *filterSliderAge;
@property (nonatomic, strong) IBOutlet ANPopoverSlider *filterSliderAppear;
@property (nonatomic, strong) IBOutlet UIImageView *filterImgMale;
@property (nonatomic, strong) IBOutlet UIImageView *filterImgFemale;
@property (nonatomic, strong) IBOutlet UIImageView *filterImgGenderBoth;
@property (nonatomic, strong) IBOutlet UIImageView *filterImg100;
@property (nonatomic, strong) IBOutlet UIImageView *filterImg500;
@property (nonatomic, strong) IBOutlet UIImageView *filterImg1000;
@property (nonatomic, strong) IBOutlet UILabel *lowerLabel;
@property (nonatomic, strong) IBOutlet UILabel *upperLabel;
@property (nonatomic, strong) IBOutlet UIView *lowerView;
@property (nonatomic, strong) IBOutlet UIView *upperView;
@property (nonatomic, strong) NSString* gender;
@property (nonatomic) int age_start;
@property (nonatomic) int age_end;
@property (nonatomic) int appear_time;
@property (nonatomic) int distance;

- (IBAction)btnFilterMaleClicked:(id)sender;
- (IBAction)btnFilterFemaleClicked:(id)sender;
- (IBAction)btnFilterGenderBothClicked:(id)sender;
- (IBAction)btnFilterDistance100Clicked:(id)sender;
- (IBAction)btnFilterDistance500Clicked:(id)sender;
- (IBAction)btnFilterDistance1000Clicked:(id)sender;
- (IBAction)btnFilterBackClicked:(id)sender;
- (IBAction)btnFilterSaveClicked:(id)sender;
-(void)fadePopupViewInAndOut:(BOOL)aFadeIn;

@end

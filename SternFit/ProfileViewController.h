//
//  ProfileViewController.h
//  SternFit
//
//  Created by MacOS on 12/11/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ProfileViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet AsyncImageView *imgProfile;
@property (nonatomic, strong) IBOutlet UIImageView *imgProfileUpload;
@property (nonatomic, strong) IBOutlet UIButton *btnProfileUpload;
@property (nonatomic, strong) IBOutlet AsyncImageView *imgPhoto1;
@property (nonatomic, strong) IBOutlet AsyncImageView *imgPhoto2;
@property (nonatomic, strong) IBOutlet AsyncImageView *imgPhoto3;
@property (nonatomic, strong) IBOutlet AsyncImageView *imgPhoto4;
@property (nonatomic, strong) IBOutlet AsyncImageView *imgPhoto5;
@property (nonatomic, strong) IBOutlet UIImageView *imgUpload1;
@property (nonatomic, strong) IBOutlet UIImageView *imgUpload2;
@property (nonatomic, strong) IBOutlet UIImageView *imgUpload3;
@property (nonatomic, strong) IBOutlet UIImageView *imgUpload4;
@property (nonatomic, strong) IBOutlet UIImageView *imgUpload5;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelSubtitle;
@property (nonatomic, strong) IBOutlet UILabel *labelAge;
@property (nonatomic, strong) IBOutlet UILabel *labelHeight;
@property (nonatomic, strong) IBOutlet UILabel *labelWeight;
@property (nonatomic, strong) IBOutlet UILabel *labelTrainingPlan;
@property (nonatomic, strong) IBOutlet UIButton *btnAdd;
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
@property (nonatomic, strong) IBOutlet UITableView *planTableView;
@property (nonatomic, strong) IBOutlet UIButton *btnUploadPhoto1;
@property (nonatomic, strong) IBOutlet UIButton *btnUploadPhoto2;
@property (nonatomic, strong) IBOutlet UIButton *btnUploadPhoto3;
@property (nonatomic, strong) IBOutlet UIButton *btnUploadPhoto4;
@property (nonatomic, strong) IBOutlet UIButton *btnUploadPhoto5;
@property (nonatomic, strong) IBOutlet UIButton *btnEditFitTab;
@property (nonatomic, strong) IBOutlet UILabel *labelStatus;
@property (nonatomic, strong) IBOutlet UIView *overlayView;
@property (nonatomic, strong) IBOutlet UIImageView *imgPlanScroll;
@property (nonatomic, strong) IBOutlet UIView *planCategoryView;
@property (nonatomic, strong) IBOutlet UITableView *planCategoryTableView;

- (IBAction)btnPhotoUpload1Clicked:(id)sender;
- (IBAction)btnPhotoUpload2Clicked:(id)sender;
- (IBAction)btnPhotoUpload3Clicked:(id)sender;
- (IBAction)btnPhotoUpload4Clicked:(id)sender;
- (IBAction)btnPhotoUpload5Clicked:(id)sender;
- (IBAction)btnProfilePhotoUploadClicked:(id)sender;
- (IBAction)btnEditFitTabClicked:(id)sender;
- (IBAction)btnAddPlanClicked:(id)sender;
- (IBAction)btnShareClicked:(id)sender;
- (IBAction)btnPlanCategoryClicked:(id)sender;

@end

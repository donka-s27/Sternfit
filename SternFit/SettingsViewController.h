//
//  SettingsViewController.h
//  SternFit
//
//  Created by MacOS on 12/11/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UIGestureRecognizerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imgProfile;
@property (nonatomic, strong) IBOutlet UILabel *labelPageTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelMode;
@property (nonatomic, strong) IBOutlet UILabel *labelVisibleSelect;
@property (nonatomic, strong) IBOutlet UILabel *labelInvisibleSelect;
@property (nonatomic, strong) IBOutlet UIButton *btnOption1;
@property (nonatomic, strong) IBOutlet UIButton *btnOption2;
@property (nonatomic, strong) IBOutlet UIButton *btnOption3;
@property (nonatomic, strong) IBOutlet UIView *viewOption;
@property (nonatomic, strong) IBOutlet UILabel *labelUsernameTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelUsername;
@property (nonatomic, strong) IBOutlet UILabel *labelPasswordTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelNotificationTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelNotificationDesc;
@property (nonatomic, strong) IBOutlet UILabel *labelUnitTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelUnit;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit1;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit2;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit3;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit4;
@property (nonatomic, strong) IBOutlet UIButton *btnSave;
@property (nonatomic, strong) IBOutlet UIImageView *imgMetric;
@property (nonatomic, strong) IBOutlet UIImageView *imgUS;
@property (nonatomic, strong) IBOutlet UIImageView *imgBg;
@property (nonatomic, strong) IBOutlet UISwitch *switchNotification;
@property (nonatomic, strong) IBOutlet UILabel *labelTap;
@property (nonatomic, strong) IBOutlet UILabel *labelStatus;

- (IBAction)btnShowVisibleOptions:(id)sender;
- (IBAction)btnHideVisibleOptions:(id)sender;
- (IBAction)btnOption1Clicked:(id)sender;
- (IBAction)btnOption2Clicked:(id)sender;
- (IBAction)btnOption3Clicked:(id)sender;
- (IBAction)btnProfileImageClicked:(id)sender;
- (IBAction)btnEditUsernameClicked:(id)sender;
- (IBAction)btnEditPasswordClicked:(id)sender;
- (IBAction)btnEditMetricClicked:(id)sender;
- (IBAction)btnEditUSClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;
@end

//
//  SignupViewController.h
//  SternFit
//
//  Created by MacOS on 12/9/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIButton *btnTour;
@property (nonatomic, strong) IBOutlet UIButton *btnCreate;
@property (nonatomic, strong) IBOutlet UITextField *txtUsername;
@property (nonatomic, strong) IBOutlet UITextField *txtPassword;
@property (nonatomic, strong) IBOutlet UITextField *txtEmail;
@property (nonatomic, strong) IBOutlet UILabel *labelBirthday;
@property (nonatomic, strong) IBOutlet UIView *overlayView;
@property (nonatomic, strong) IBOutlet UIView *pickerView;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIButton *btnDone;
@property (nonatomic, strong) IBOutlet UIImageView *imgMale;
@property (nonatomic, strong) IBOutlet UIImageView *imgFemale;
@property (nonatomic, strong) IBOutlet UIButton *btnMale;
@property (nonatomic, strong) IBOutlet UIButton *btnFemale;
@property (nonatomic, strong) IBOutlet UIView *viewAlert;
@property (nonatomic, strong) IBOutlet UILabel *labelAlert;
@property (nonatomic, strong) IBOutlet UIImageView *imgBack;
@property (nonatomic, strong) IBOutlet UIImageView *imgUser;

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *strGender;

- (IBAction)btnTourClicked:(id)sender;
- (IBAction)btnCreateClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnBirthdayClicked:(id)sender;
- (IBAction)btnDoneClicked:(id)sender;
- (IBAction)btnCloseClicked:(id)sender;
- (IBAction)btnMaleClicked:(id)sender;
- (IBAction)btnFemaleClicked:(id)sender;

@end

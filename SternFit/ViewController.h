//
//  ViewController.h
//  SternFit
//
//  Created by MacOS on 12/9/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet UITextField *txtUsername;
@property (nonatomic, strong) IBOutlet UITextField *txtPassword;
@property (nonatomic, strong) IBOutlet UIButton *btnForgotPassword;
@property (nonatomic, strong) IBOutlet UIButton *btnSignup;
@property (nonatomic, strong) IBOutlet UIButton *btnLogin;
@property (nonatomic, strong) IBOutlet UIButton *btnFacebookLogin;
@property (nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, strong) IBOutlet UIScrollView *forgotScrollView;
@property (nonatomic, strong) IBOutlet UIView *overlayView;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelSubtitle;
@property (nonatomic, strong) IBOutlet UITextField *txtEmail;
@property (nonatomic, strong) IBOutlet UIButton *btnEmailSend;
@property (nonatomic, strong) IBOutlet UIButton *btnClose;
@property (nonatomic, strong) IBOutlet FBLoginView *facebookLoginView;
//locationService
@property (nonatomic, strong) CLLocationManager *locationManager;

- (IBAction)btnLoginClicked:(id)sender;
- (IBAction)btnFacebookLoginClicked:(id)sender;
- (IBAction)btnForgotPasswordClicked:(id)sender;
- (IBAction)btnSignupClicked:(id)sender;
- (IBAction)btnEmailSendClicked:(id)sender;
- (IBAction)btnCloseClicked:(id)sender;

@end

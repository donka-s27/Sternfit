//
//  SplashViewController.h
//  SternFit
//
//  Created by MacOS on 1/9/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface SplashViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *btnSignin;
@property (nonatomic, strong) IBOutlet UIButton *btnRegister;
@property (nonatomic, strong) IBOutlet UIImageView *imgBg;
@property (nonatomic, strong) IBOutlet UIImageView *imgLogo;
@property (nonatomic, strong) IBOutlet UIImageView *imgLogo1;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *backView;

- (IBAction)btnSigninClicked:(id)sender;
- (IBAction)btnRegisterClicked:(id)sender;

@end

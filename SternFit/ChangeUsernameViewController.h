//
//  ChangeUsernameViewController.h
//  SternFit
//
//  Created by MacOS on 1/30/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeUsernameViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UITextField *txtUsername;
@property (nonatomic, strong) IBOutlet UITextField *txtPassword;
@property (nonatomic, strong) IBOutlet UITextField *txtNewPassword;
@property (nonatomic, strong) IBOutlet UITextField *txtNewPasswordAgain;
@property (nonatomic, strong) IBOutlet UIView *viewUsername;
@property (nonatomic, strong) IBOutlet UIView *viewPassword;
@property (nonatomic, strong) IBOutlet UIView *viewAlert;
@property (nonatomic, strong) IBOutlet UILabel *labelAlert;

@property (nonatomic) BOOL isUsernameChange;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnSaveUsernameClicked:(id)sender;
- (IBAction)btnSavePasswordClicked:(id)sender;

@end

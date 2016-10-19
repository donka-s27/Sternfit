//
//  SharePopupViewController.h
//  SternFit
//
//  Created by MacOS on 12/22/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCustomTabBarController.h"
#import "OtherProfileViewController.h"
#import "TrainingViewController.h"

@interface SharePopupViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *shareLabel;
@property (nonatomic, strong) IBOutlet UIButton *btnClose;
@property (nonatomic, retain) UIViewController *parentViewController;
@property (nonatomic, retain) MHCustomTabBarController *tabBarController;
@property (nonatomic, retain) OtherProfileViewController *otherProfileController;

@property (nonatomic, strong) NSString *content;

- (IBAction)btnFacebookClicked:(id)sender;
- (IBAction)btnTwitterClicked:(id)sender;
- (IBAction)btnShareCloseClicked:(id)sender;

@end

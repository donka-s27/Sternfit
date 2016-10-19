//
//  ChangeUsernameViewController.m
//  SternFit
//
//  Created by MacOS on 1/30/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import "ChangeUsernameViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface ChangeUsernameViewController () {
    NSUserDefaults *defaults;
}

@end

@implementation ChangeUsernameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.isUsernameChange == YES) {
        self.viewUsername.hidden = NO;
        self.viewPassword.hidden = YES;
        self.txtUsername.text = [defaults objectForKey:@"name"];
        self.txtUsername.textColor = [UIColor blackColor];
        self.labelTitle.text = NSLocalizedString(@"Change Username", nil);
    } else {
        self.viewUsername.hidden = YES;
        self.viewPassword.hidden = NO;
        self.txtPassword.text = NSLocalizedString(@"Password", nil);
        self.txtNewPassword.text = NSLocalizedString(@"New Password", nil);
        self.txtNewPasswordAgain.text = NSLocalizedString(@"New Password, again", nil);
        self.labelTitle.text = NSLocalizedString(@"Change Password", nil);
        self.txtPassword.secureTextEntry = NO;
        self.txtNewPassword.secureTextEntry = NO;
        self.txtNewPasswordAgain.secureTextEntry = NO;
    }
    
    self.viewAlert.hidden = YES;
    
    self.labelTitle.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17.0f];
    self.labelAlert.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark TextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.txtUsername) {
        if ([textField.text isEqual:NSLocalizedString(@"Username", nil)]) {
            textField.text = @"";
        }
    }
    if (textField == self.txtPassword) {
        if ([textField.text isEqual:NSLocalizedString(@"Password", nil)]) {
            textField.text = @"";
            textField.secureTextEntry = YES;
        }
    }
    if (textField == self.txtNewPasswordAgain) {
        if ([textField.text isEqual:NSLocalizedString(@"New Password, again", nil)]) {
            textField.text = @"";
            textField.secureTextEntry = YES;
        }
    }
    if (textField == self.txtNewPassword) {
        if ([textField.text isEqual:NSLocalizedString(@"New Password", nil)]) {
            textField.text = @"";
            textField.secureTextEntry = YES;
        }
    }
    
    textField.textColor = [UIColor blackColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.txtUsername) {
        if ([textField.text isEqual:@""]) {
            self.txtUsername.text = NSLocalizedString(@"Username", nil);
            textField.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        }
    }
    if (textField == self.txtPassword) {
        if ([textField.text isEqual:@""]) {
            textField.text = NSLocalizedString(@"Password", nil);
            textField.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            textField.secureTextEntry = NO;
        }
    }
    if (textField == self.txtNewPasswordAgain) {
        if ([textField.text isEqual:@""]) {
            textField.text = NSLocalizedString(@"New Password, again", nil);
            textField.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            textField.secureTextEntry = NO;
        }
    }
    if (textField == self.txtNewPassword) {
        if ([textField.text isEqual:@""]) {
            textField.text = NSLocalizedString(@"New Password", nil);
            textField.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            textField.secureTextEntry = NO;
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.txtPassword) {
        [self.txtNewPassword becomeFirstResponder];
    } else if (textField == self.txtNewPassword) {
        [self.txtNewPasswordAgain becomeFirstResponder];
    }
    
    
    return YES;
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnSaveUsernameClicked:(id)sender {
    [self.txtUsername resignFirstResponder];
    
    if ([self.txtUsername.text isEqual:@""] || [self.txtUsername.text isEqual:NSLocalizedString(@"Username", nil)]) {
        self.labelAlert.text = NSLocalizedString(@"Please type username", nil);
        self.viewAlert.hidden = NO;
        return;
    }
    
    if ([self checkValid:self.txtUsername.text] == NO) {
        self.labelAlert.text = NSLocalizedString(@"Usernames can only use letters, numbers, and underscores.", nil);
        self.viewAlert.hidden = NO;
        return;
    }
    
    if ([self.txtUsername.text length] > 30) {
        self.labelAlert.text = NSLocalizedString(@"Ensure the username has at most 30 characters.", nil);
        self.viewAlert.hidden = NO;
        return;
    }
    
    
    
    [self showProgress:YES];
    
    NSURL *myURL1 = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?type=0&ID=%@&value=%@", SERVER_ADDRESS, CHANGE_USER_CREDENTIAL, [defaults objectForKey:@"userID"], self.txtUsername.text]];
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:myURL1 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request1 setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request1 queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               [self showProgress:NO];
                               
                               NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                               
                               if ([[result objectForKey:@"status"] isEqual:@"success"]) {
                                   self.labelAlert.text = NSLocalizedString(@"You have successfully changed your username!", nil);
                                   self.viewAlert.hidden = NO;
                                   
                                   [defaults setObject:self.txtUsername.text forKey:@"name"];
                                   
                                   [defaults synchronize];
                               } else {
                                   self.labelAlert.text = [NSLocalizedString(@"Username XXX is not available.", nil) stringByReplacingOccurrencesOfString:@"XXX" withString:self.txtUsername.text];
                                   self.viewAlert.hidden = NO;
                               }
                               
                           }];
    
}
- (IBAction)btnSavePasswordClicked:(id)sender {
    [self.txtPassword resignFirstResponder];
    [self.txtNewPasswordAgain resignFirstResponder];
    [self.txtNewPassword resignFirstResponder];
    
    NSString *password = self.txtPassword.text;
    NSString *newPassword = self.txtNewPassword.text;
    
    if ([password isEqual:@""] || [password isEqual:NSLocalizedString(@"Password", nil)] || [newPassword isEqual:@""] || [newPassword isEqual:NSLocalizedString(@"New Password", nil)]) {
        self.labelAlert.text = NSLocalizedString(@"Please type password", nil);
        self.viewAlert.hidden = NO;
        return;
    }
    
    if (![newPassword isEqual:self.txtNewPasswordAgain.text]) {
        self.labelAlert.text = NSLocalizedString(@"New password doesn't match. Please type it again!", nil);
        self.viewAlert.hidden = NO;
        return;
    }
    
    if ([self checkValid:newPassword] == NO) {
        self.labelAlert.text = NSLocalizedString(@"Password can only use letters, numbers, and underscores.", nil);
        self.viewAlert.hidden = NO;
        return;
    }
    
    if ([newPassword length] > 30) {
        self.labelAlert.text = NSLocalizedString(@"Ensure the password has at most 30 characters.", nil);
        self.viewAlert.hidden = NO;
        return;
    }
    
    [self showProgress:YES];
    NSURL *myURL1 = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?type=1&username=%@&password=%@&newPassword=%@", SERVER_ADDRESS, CHANGE_PASSWORD, [defaults objectForKey:@"name"], password, newPassword]];
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:myURL1 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request1 setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request1 queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [self showProgress:NO];
                               
                               NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                               
                               if ([[result objectForKey:@"status"] isEqual:@"success"]) {
                                   [defaults setObject:newPassword forKey:@"password"];
                                   [defaults synchronize];
                                   
                                   self.labelAlert.text = NSLocalizedString(@"You have successfully changed your password!", nil);
                                   self.viewAlert.hidden = NO;
                               } else {
                                   self.labelAlert.text = NSLocalizedString(@"Current password is incorrect.", nil);
                                   self.viewAlert.hidden = NO;
                               }
                           }];
}

- (BOOL) checkValid:(NSString *) string {
    NSMutableArray *validValues = (NSMutableArray*) [@"a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9,_" componentsSeparatedByString:@","];
    NSString *temp;
    BOOL ret = NO;
    for (int j = 0; j < [string length] - 1; j++) {
        temp = [string substringWithRange:NSMakeRange(j, 1)];
        ret = NO;
        for (int i = 0; i < [validValues count]; i++) {
            if ([[validValues objectAtIndex:i] isEqual:temp])
            {
                ret = YES;
                break;
            }
        }
        
        if (ret == NO)
            return NO;
    }
    
    return YES;
}

- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}

@end

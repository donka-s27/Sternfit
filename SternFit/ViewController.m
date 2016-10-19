//
//  ViewController.m
//  SternFit
//
//  Created by MacOS on 12/9/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "SignupViewController.h"

@interface ViewController () {
    BOOL isRetina;
    AppDelegate *appDelegate;
    NSUserDefaults *defaults;
}

@end

@implementation ViewController

@synthesize txtPassword, txtUsername, btnFacebookLogin, btnForgotPassword, btnLogin, btnSignup, mainScrollView, btnClose, btnEmailSend, txtEmail, labelSubtitle, labelTitle, forgotScrollView, overlayView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.facebookLoginView.readPermissions = @[@"user_birthday"];
    
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.currentLocation = self.locationManager.location;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    if (appDelegate.currentLocation.coordinate.latitude == 0.0f)
        [self startStandardUpdates];
    
    [btnSignup setTitle:NSLocalizedString(@"Sign Up", nil) forState:UIControlStateNormal];
    [btnFacebookLogin setTitle:NSLocalizedString(@"LOGIN WITH FACEBOOK", nil) forState:UIControlStateNormal];
    [btnForgotPassword setTitle:NSLocalizedString(@"Forgot password?", nil) forState:UIControlStateNormal];
    [btnLogin setTitle:NSLocalizedString(@"LOGIN", nil) forState:UIControlStateNormal];
    txtUsername.text = NSLocalizedString(@"Username", nil);
    txtPassword.text = NSLocalizedString(@"Password", nil);
    labelTitle.text = NSLocalizedString(@"ENTER YOUR EMAIL", nil);
    labelSubtitle.text = NSLocalizedString(@"We will send new password to your email.", nil);
    [btnEmailSend setTitle:NSLocalizedString(@"SEND", nil) forState:UIControlStateNormal];
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == 480)
        isRetina = true;
    else
        isRetina = false;
    
    UITapGestureRecognizer *tapView1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap1:)];
    tapView1.delegate = self;
    [mainScrollView addGestureRecognizer:tapView1];
    
    UITapGestureRecognizer *tapView2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap1:)];
    tapView2.delegate = self;
    [forgotScrollView addGestureRecognizer:tapView2];
    
    overlayView.hidden = YES;
    forgotScrollView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    if (isRetina)
        [mainScrollView setContentOffset:CGPointMake(0, -60) animated:YES];
}

#pragma - mark TextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == txtUsername) {
        if (isRetina)
            [mainScrollView setContentOffset:CGPointMake(0, 60) animated:YES];
        else
            [mainScrollView setContentOffset:CGPointMake(0, 60) animated:YES];
        
        if ([txtUsername.text isEqual:NSLocalizedString(@"Username", nil)])
            txtUsername.text = @"";
    } else if (textField == txtPassword) {
        if (isRetina)
            [mainScrollView setContentOffset:CGPointMake(0, 60) animated:YES];
        else
            [mainScrollView setContentOffset:CGPointMake(0, 60) animated:YES];
        if ([txtPassword.text isEqual:NSLocalizedString(@"Password", nil)])
            txtPassword.text = @"";
    } else if (textField == txtEmail) {
        //if (isRetina)
          //  [forgotScrollView setContentOffset:CGPointMake(0, 60) animated:YES];
        /*else
            [forgotScrollView setContentOffset:CGPointMake(0, 60) animated:YES];*/
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == txtUsername) {
        if ([txtUsername.text isEqual:@""])
            txtUsername.text = NSLocalizedString(@"Username", nil);
    } else if (textField == txtPassword) {
        if ([txtPassword.text isEqual:@""])
            txtPassword.text = NSLocalizedString(@"Password", nil);
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (isRetina)
        [mainScrollView setContentOffset:CGPointMake(0, -60) animated:YES];
    else
        [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

- (IBAction)viewTap1:(UITapGestureRecognizer*)recognizer {
    [txtUsername resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtEmail resignFirstResponder];
    if (isRetina) {
        [mainScrollView setContentOffset:CGPointMake(0, -60) animated:YES];
        [forgotScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [forgotScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (IBAction)btnLoginClicked:(id)sender {
    NSString *username = txtUsername.text;
    NSString *password = txtPassword.text;
    if ([username isEqual:NSLocalizedString(@"Username", nil)])
        username = @"";
    if ([password isEqual:NSLocalizedString(@"Password", nil)])
        password = @"";
    if ([username isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Please type username", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if ([password isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Please type password", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    
    
    
    [self showProgress:YES];
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@&password=%@", SERVER_ADDRESS, LOGIN_USER, username, password]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               @try {
                                   if (data != nil) {
                                       NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       
                                       if ([[result objectForKey:@"status"] isEqual:@"fail"]) {
                                           [self showProgress:NO];
                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APPTAG message:[result objectForKey:@"response"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                           [alertView show];
                                           return;
                                       } else if ([[result objectForKey:@"status"] isEqual:@"success"]){
                                           NSMutableDictionary *res = (NSMutableDictionary*) [result objectForKey:@"response"];
                                           
                                           //
                                           if ([[res objectForKey:@"gender"] intValue] == 1)
                                               [defaults setObject:@"male" forKey:@"gender"];
                                           else
                                               [defaults setObject:@"female" forKey:@"gender"];
                                           [defaults setObject:[res objectForKey:@"username"] forKey:@"name"];
                                           [defaults setObject:[res objectForKey:@"email"] forKey:@"email"];
                                           
                                           int birthYear = [[[[res objectForKey:@"birthday"] description] substringToIndex:4] intValue];
                                           NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                           [formatter setDateFormat:@"yyyy"];
                                           int currentYear = [[formatter stringFromDate:[NSDate date]] intValue];
                                           int age = currentYear - birthYear;
                                           
                                           [defaults setObject:[NSString stringWithFormat:@"%d", age] forKey:@"age"];
                                           [defaults setObject:[res objectForKey:@"height"] forKey:@"height"];
                                           [defaults setObject:[res objectForKey:@"weight"] forKey:@"weight"];
                                           [defaults setObject:[res objectForKey:@"quote"] forKey:@"quote"];
                                           //[defaults setObject:[res objectForKey:@"password"] forKey:@"password"];
                                           [defaults setObject:[res objectForKey:@"ID"] forKey:@"userID"];
                                           [defaults setObject:@"1" forKey:@"isLogin"];
                                           [defaults removeObjectForKey:@"profile"];
                                           [defaults removeObjectForKey:@"photo2"];
                                           [defaults removeObjectForKey:@"photo3"];
                                           [defaults removeObjectForKey:@"photo4"];
                                           [defaults removeObjectForKey:@"photo5"];
                                           [defaults removeObjectForKey:@"photo1"];
                                           [defaults setObject:[res objectForKey:@"visible"] forKey:@"visibleMode"];
                                           [defaults setObject:[res objectForKey:@"notificationSound"] forKey:@"isNotification"];
                                           // filter options
                                           NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
                                           [filters setObject:@"all" forKey:@"gender"];
                                           [filters setObject:@"19" forKey:@"age_start"];
                                           [filters setObject:@"36" forKey:@"age_end"];
                                           [filters setObject:@"3" forKey:@"appear_time"];
                                           [filters setObject:@"2" forKey:@"distance"];
                                           [defaults setObject:filters forKey:@"nearby_filters"];
                                           
                                           [defaults synchronize];
                                           
                                           appDelegate.tabIndex = 0;
                                           
                                           NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@&lat=%f&long=%f", SERVER_ADDRESS, UPDATE_USER, username, appDelegate.currentLocation.coordinate.latitude, appDelegate.currentLocation.coordinate.longitude]];
                                           NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
                                           
                                           [request setHTTPMethod:@"POST"];
                                           
                                           [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                                            
                                                                  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                                      
                                                                      NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@", SERVER_ADDRESS, GET_USER_IMAGES, username]];
                                                                      NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
                                                                      
                                                                      [request setHTTPMethod:@"POST"];
                                                                      
                                                                      [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                                                                       
                                                                                             completionHandler:^(NSURLResponse *response1, NSData *data1, NSError *error1) {
                                                                                                 NSMutableArray *result1 = (NSMutableArray*) [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
                                                                                                 
                                                                                                 if ([result1 count] > 0) {
                                                                                                     [self downloadUserImages:result1 index:0 username:username];
                                                                                                 } else {
                                                                                                     [self showProgress:NO];
                                                                                                     //[self performSegueWithIdentifier:@"gotoNearby" sender:self];
                                                                                                     
                                                                                                     [self moveToNearby];
                                                                                                 }
                                                                                             }];
                                                                  }];
                                           
                                       }
                                   } else {
                                       [self showProgress:NO];
                                   }
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   
                               }
                               
                               
                           }];
}

- (void) moveToNearby {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MHCustomTabBarController *controller = (MHCustomTabBarController *)[storyboard instantiateViewControllerWithIdentifier:@"MHCustomTabBarController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) downloadUserImages:(NSMutableArray *) images index:(int)index username:(NSString*) username {
    NSString *filename = [images objectAtIndex:index];
    static int ind;
    index++;
    ind = index;
    [NSURLConnection sendAsynchronousRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@_%@", IMAGE_URL, username, filename]]]
     
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^( NSURLResponse *response, NSData *data, NSError *error ) {
                               if(error)
                               {
                                   
                               }
                               else
                               {
                                   @try {
                                       UIImage *image = [UIImage imageWithData:data];
                                       if(image != nil) {
                                           
                                           NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                                                NSUserDomainMask, YES);
                                           
                                           NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
                                           [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
                                           
                                           
                                           if ([filename isEqual:@"profile.jpg"])
                                               [defaults setObject:filename forKey:@"profile"];
                                           else if ([filename isEqual:@"photo1.jpg"])
                                               [defaults setObject:filename forKey:@"photo1"];
                                           else if ([filename isEqual:@"photo2.jpg"])
                                               [defaults setObject:filename forKey:@"photo2"];
                                           else if ([filename isEqual:@"photo3.jpg"])
                                               [defaults setObject:filename forKey:@"photo3"];
                                           else if ([filename isEqual:@"photo4.jpg"])
                                               [defaults setObject:filename forKey:@"photo4"];
                                           else if ([filename isEqual:@"photo5.jpg"])
                                               [defaults setObject:filename forKey:@"photo5"];
                                       }
                                   }
                                   @catch (NSException *exception) {
                                       
                                   }
                                   @finally {
                                       
                                   }
                                   
                               }
                               if (ind >= [images count]) {
                                   [self showProgress:NO];
                                   //[self performSegueWithIdentifier:@"gotoNearby" sender:self];
                                   [self moveToNearby];
                               } else {
                                   [self downloadUserImages:images index:ind username:username];
                               }
                           }];
}

- (void) makeRequestForUserData {
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

- (IBAction)btnForgotPasswordClicked:(id)sender {
    txtEmail.text = @"";
    overlayView.hidden = NO;
    forgotScrollView.hidden = NO;
}

- (IBAction)btnFacebookLoginClicked:(id)sender {
    [self showProgress:YES];
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"user_birthday", @"email",nil];
    //[[THE_APP theFacebook] authorize:permissions];
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState state,
                                                      NSError *error) {
                                      [self sessionStateChanged:session
                                                          state:state
                                                          error:error];
                                  }];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            // Handle the logged in scenario
            
            // You may wish to show a logged in view
            [self fbDidLogin];
            break;
        }
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed: {
            // Handle the logged out scenario
            
            // Close the active session
            [FBSession.activeSession closeAndClearTokenInformation];
            //[self fbDidNotLogin:YES];
            // You may wish to show a logged out view
            
            break;
        }
        default:
            break;
    }
    
    if (error) {
        // Handle authentication errors
    }
}

- (void) fbDidLogin {
    [FBRequestConnection startForMeWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?email=%@", SERVER_ADDRESS, CHECK_USER, [user objectForKey:@"email"]]];
             NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
             
             [request setHTTPMethod:@"POST"];
             
             [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
              
                                    completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                        @try {
                                            if (data != nil) {
                                                NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                
                                                if ([[result objectForKey:@"status"] isEqual:@"fail"]) {
                                                    [self showProgress:NO];
                                                    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                    SignupViewController *controller = (SignupViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
                                                    controller.email = [user objectForKey:@"email"];
                                                    controller.strGender = [user objectForKey:@"gender"];
                                                    [self.navigationController pushViewController:controller animated:YES];
                                                    
                                                    return;
                                                } else if ([[result objectForKey:@"status"] isEqual:@"success"]){
                                                    NSMutableDictionary *res = (NSMutableDictionary*) [result objectForKey:@"response"];
                                                    
                                                    //
                                                    if ([[res objectForKey:@"gender"] intValue] == 1)
                                                        [defaults setObject:@"male" forKey:@"gender"];
                                                    else
                                                        [defaults setObject:@"female" forKey:@"gender"];
                                                    [defaults setObject:[res objectForKey:@"username"] forKey:@"name"];
                                                    [defaults setObject:[res objectForKey:@"email"] forKey:@"email"];
                                                    
                                                    int birthYear = [[[[res objectForKey:@"birthday"] description] substringToIndex:4] intValue];
                                                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                    [formatter setDateFormat:@"yyyy"];
                                                    int currentYear = [[formatter stringFromDate:[NSDate date]] intValue];
                                                    int age = currentYear - birthYear;
                                                    
                                                    [defaults setObject:[NSString stringWithFormat:@"%d", age] forKey:@"age"];
                                                    [defaults setObject:[res objectForKey:@"height"] forKey:@"height"];
                                                    [defaults setObject:[res objectForKey:@"weight"] forKey:@"weight"];
                                                    [defaults setObject:[res objectForKey:@"quote"] forKey:@"quote"];
                                                    //[defaults setObject:[res objectForKey:@"password"] forKey:@"password"];
                                                    [defaults setObject:[res objectForKey:@"ID"] forKey:@"userID"];
                                                    [defaults setObject:@"1" forKey:@"isLogin"];
                                                    [defaults removeObjectForKey:@"profile"];
                                                    [defaults removeObjectForKey:@"photo2"];
                                                    [defaults removeObjectForKey:@"photo3"];
                                                    [defaults removeObjectForKey:@"photo4"];
                                                    [defaults removeObjectForKey:@"photo5"];
                                                    [defaults removeObjectForKey:@"photo1"];
                                                    [defaults setObject:[res objectForKey:@"visible"] forKey:@"visibleMode"];
                                                    [defaults setObject:[res objectForKey:@"notificationSound"] forKey:@"isNotification"];
                                                    // filter options
                                                    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
                                                    [filters setObject:@"all" forKey:@"gender"];
                                                    [filters setObject:@"19" forKey:@"age_start"];
                                                    [filters setObject:@"36" forKey:@"age_end"];
                                                    [filters setObject:@"3" forKey:@"appear_time"];
                                                    [filters setObject:@"2" forKey:@"distance"];
                                                    [defaults setObject:filters forKey:@"nearby_filters"];
                                                    
                                                    [defaults synchronize];
                                                    
                                                    appDelegate.tabIndex = 0;
                                                    
                                                    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@&lat=%f&long=%f", SERVER_ADDRESS, UPDATE_USER, [res objectForKey:@"username"], appDelegate.currentLocation.coordinate.latitude, appDelegate.currentLocation.coordinate.longitude]];
                                                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
                                                    
                                                    [request setHTTPMethod:@"POST"];
                                                    
                                                    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                                                     
                                                                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                                               
                                                                               NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@", SERVER_ADDRESS, GET_USER_IMAGES, [res objectForKey:@"username"]]];
                                                                               NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
                                                                               
                                                                               [request setHTTPMethod:@"POST"];
                                                                               
                                                                               [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                                                                                
                                                                                                      completionHandler:^(NSURLResponse *response1, NSData *data1, NSError *error1) {
                                                                                                          NSMutableArray *result1 = (NSMutableArray*) [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
                                                                                                          
                                                                                                          if ([result1 count] > 0) {
                                                                                                              [self downloadUserImages:result1 index:0 username:[res objectForKey:@"username"]];
                                                                                                          } else {
                                                                                                              [self showProgress:NO];
                                                                                                             // [self performSegueWithIdentifier:@"gotoNearby" sender:self];
                                                                                                              [self moveToNearby];
                                                                                                          }
                                                                                                      }];
                                                                           }];
                                                    
                                                }
                                            } else {
                                                [self showProgress:NO];
                                            }
                                        }
                                        @catch (NSException *exception) {
                                            
                                        }
                                        @finally {
                                            
                                        }
                                        
                                        
                                    }];
         } else {
             [self showProgress:NO];
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:@"Login Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alertView show];
         }
     }];
}

- (IBAction)btnSignupClicked:(id)sender {
    [self performSegueWithIdentifier:@"gotoSignup" sender:self];
}

- (IBAction)btnEmailSendClicked:(id)sender {
    NSString *email = txtEmail.text;
    if ([email isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Please type email address", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (![self validateEmail:email]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Incorrect email format", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [txtEmail resignFirstResponder];
    
    [self showProgress:YES];
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?&email=%@", SERVER_ADDRESS, LOST_PASSWORD, email]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [self showProgress:NO];
                               @try {
                                   NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                   
                                   if ([[result objectForKey:@"status"] isEqual:@"fail"]) {
                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APPTAG message:[result objectForKey:@"response"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                       [alertView show];
                                   } else if ([[result objectForKey:@"status"] isEqual:@"success"]){
                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APPTAG message:[result objectForKey:@"response"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                       [alertView show];
                                       
                                       [forgotScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                                       overlayView.hidden = YES;
                                       forgotScrollView.hidden = YES;
                                   }
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   
                               }
                               
                           }];
}

- (IBAction)btnCloseClicked:(id)sender {
    [txtEmail resignFirstResponder];
    [forgotScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    overlayView.hidden = YES;
    forgotScrollView.hidden = YES;
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; //  return 0;
    return [emailTest evaluateWithObject:candidate];
}


- (void) updateCurrentLocation {
    // call the same method on a background thread
    dispatch_queue_t unsyncNamesQueue =
    dispatch_queue_create("UnsyncNamesFromServer", DISPATCH_QUEUE_SERIAL);
    //....
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                   unsyncNamesQueue, ^{
                       NSLog(@"here");
                       
                       [self updateCurrentLocation];
                   }
                   );
}

- (void) startLocationServices {
    
    appDelegate.currentLocation = self.locationManager.location;
    
    if (appDelegate.currentLocation.coordinate.latitude != 0.0f)
        [self.locationManager stopUpdatingLocation];
}

- (void)startStandardUpdates {
	if (nil == self.locationManager) {
		self.locationManager = [[CLLocationManager alloc] init];
	}
	
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
	// Set a movement threshold for new events.
	self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
    
    appDelegate.currentLocation = self.locationManager.location;
	
	//[self.locationManager startUpdatingLocation];
}

- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}
@end

//
//  SharePopupViewController.m
//  SternFit
//
//  Created by MacOS on 12/22/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "SharePopupViewController.h"
#import "AppDelegate.h"
#import <Social/Social.h>

@interface SharePopupViewController () {
    AppDelegate *appDelegate;
}

@end

@implementation SharePopupViewController

@synthesize parentViewController;

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
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    if (self.otherProfileController != nil) {
        self.shareLabel.text = [NSLocalizedString(@"Share Your Fit-Tab", nil) stringByReplacingOccurrencesOfString:@"Your" withString:[NSString stringWithFormat:@"%@'s", appDelegate.selectOtherUser.name]];
    } else
        self.shareLabel.text = NSLocalizedString(@"Share Your Fit-Tab", nil);
    /*
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == 480) {
        CGRect frame = self.btnClose.frame;
        frame.origin.y -= 10;
        self.btnClose.frame = frame;
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnFacebookClicked:(id)sender {
    if (self.tabBarController != nil) {
        
        /*if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            //self.content = [NSString stringWithFormat:@"%@ %@", self.content, @"Facebook"];
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    
                    NSLog(@"Cancelled");
                    
                } else
                    
                {
                    [self showProgress:YES];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@&ID=%@&shareUserID=%d&socialSource=Facebook", SERVER_ADDRESS, SHARE_FITTAB, [defaults objectForKey:@"name"], [defaults objectForKey:@"userID"], appDelegate.selectOtherUser.userId]];
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
                    
                    [request setHTTPMethod:@"POST"];
                    
                    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                     
                                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                               [self showProgress:NO];
                                               if (self.otherProfileController != nil)
                                                   [self.otherProfileController hideShareView];
                                               else if (self.parentViewController != nil)
                                                   [self.parentViewController hideShareView];
                                               else if (self.tabBarController != nil)
                                                   [self.tabBarController hideShareView];
                                               
                                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Successfully shared", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] ;
                                               [alertView show];
                                           }];
                }
                
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
            //Adding the Text to the facebook post value from iOS
            [controller setInitialText:self.content];
            [self presentViewController:controller animated:YES completion:Nil];
        }
        else{
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"You need to login to facebook first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
            [alertView show];
        }*/
        
        
        
        UIImage *img = [UIImage imageNamed:@"share.png"];
        
        UIGraphicsBeginImageContext(CGSizeMake(img.size.width * 2, img.size.height));
        [img drawInRect:CGRectMake(0,0,img.size.width,img.size.height)];
        [appDelegate.imageFittab drawInRect:CGRectMake(img.size.width,0,appDelegate.imageFittab.size.width,appDelegate.imageFittab.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@&ID=%@&shareUserID=%d&socialSource=Facebook", SERVER_ADDRESS, SHARE_FITTAB, [defaults objectForKey:@"name"], [defaults objectForKey:@"userID"], appDelegate.selectOtherUser.userId]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
        
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
         
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   /*if (self.otherProfileController != nil)
                                       [self.otherProfileController hideShareView];
                                   else if (self.parentViewController != nil)
                                       [self.parentViewController hideShareView];
                                   else if (self.tabBarController != nil)
                                       [self.tabBarController hideShareView];*/
                                   /*
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Successfully shared", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] ;
                                    [alertView show];*/
                               }];
        /*
        NSDictionary* dict = @{
                               @"link" : @"https://developers.facebook.com/ios",
                               @"picture" : newImage,
                               @"message":@"Your temp message here",
                               @"name" : @"MyApp",
                               @"caption" : @"TestPost",
                               @"description" : @"Integrating Facebook in ios"
                               };
        [FBRequestConnection startWithGraphPath:@"me/feed" parameters:dict HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSString *alertText;
            if (error)
            {
                NSLog(@"%@",[NSString stringWithFormat: @"error: domain = %@, code = %d", error.domain, error.code]);
                alertText = @"Failed to post to Facebook, try again";
            } else
            {
                alertText = @"Posted successfully to Facebook";
            }
            
            [[[UIAlertView alloc] initWithTitle:@"Facebook Result" message:alertText delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil] show];
        }];
        */
        
        if (self.otherProfileController != nil) {
            [self uploadImage:newImage username:[defaults objectForKey:@"name"] filename:[NSString stringWithFormat:@"%ld.jpg", (long)[[NSDate date] timeIntervalSince1970]]];
        } else
            [self uploadImage:appDelegate.imageFittab username:[defaults objectForKey:@"name"] filename:[NSString stringWithFormat:@"%ld.jpg", (long)[[NSDate date] timeIntervalSince1970]]];
        
        /*FBShareDialogPhotoParams *params = [[FBShareDialogPhotoParams alloc] init];
        params.photos = @[newImage];
        
        FBAppCall *appCall = [FBDialogs presentShareDialogWithPhotoParams:params
                                                              clientState:nil
                                                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                                      if (error) {
                                                                          NSLog(@"Error: %@", error.description);
                                                                      } else {
                                                                          NSLog(@"Success!");
                                                                      }
                                                                  }];
        if (!appCall) {
            [self performPublishAction:^{
                FBRequestConnection *connection = [[FBRequestConnection alloc] init];
                connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
                | FBRequestConnectionErrorBehaviorAlertUser
                | FBRequestConnectionErrorBehaviorRetry;
                
                
                [connection addRequest:[FBRequest requestForUploadPhoto:newImage]
                     completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
                        // [self showAlert:@"Photo Post" result:result error:error];
                         if (FBSession.activeSession.isOpen) {
                             //self.buttonPostPhoto.enabled = YES;
                         }
                     }];
               // [connection setValue:self.content forKey:@"message"];
                
                [connection start];
                
               // self.buttonPostPhoto.enabled = NO;
            }];
        }*/
    }
}
- (IBAction)btnTwitterClicked:(id)sender {
    if (self.tabBarController != nil) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            //self.content = [NSString stringWithFormat:@"%@ %@", self.content, @"Twitter"];
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    
                    NSLog(@"Cancelled");
                    
                } else
                    
                {
                    [self showProgress:YES];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@&ID=%@&shareUserID=%d&socialSource=Twitter", SERVER_ADDRESS, SHARE_FITTAB, [defaults objectForKey:@"name"], [defaults objectForKey:@"userID"], appDelegate.selectOtherUser.userId]];
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
                    
                    [request setHTTPMethod:@"POST"];
                    
                    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                     
                                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                               [self showProgress:NO];
                                               
                                               if (self.otherProfileController != nil)
                                                   [self.otherProfileController hideShareView];
                                               else if (self.parentViewController != nil) {
                                                   if ([self.parentViewController isKindOfClass:[TrainingViewController class]])
                                                       [((TrainingViewController*)self.parentViewController) hideShareView];
                                                   else if ([self.parentViewController isKindOfClass:[DietPlanViewController class]])
                                                       [((DietPlanViewController*)self.parentViewController) hideShareView];
                                                   else if ([self.parentViewController isKindOfClass:[SupplementPlanViewController class]])
                                                       [((SupplementPlanViewController*)self.parentViewController) hideShareView];
                                               } else if (self.tabBarController != nil)
                                                   [self.tabBarController hideShareView];
                                               
                                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Successfully shared", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] ;
                                               [alertView show];
                                           }];
                }
                
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
            controller.completionHandler =myBlock;
            //Adding the Text to the facebook post value from iOS
            [controller setInitialText:[NSString stringWithFormat:@"%@\n http://www.sternfit.com", self.content]];
            [self presentViewController:controller animated:YES completion:Nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    }
}
- (IBAction)btnShareCloseClicked:(id)sender {
    if (self.otherProfileController != nil)
        [self.otherProfileController hideShareView];
    else if (self.tabBarController != nil) {
        [self.tabBarController hideShareView];
    } else if (self.parentViewController != nil) {
        if ([self.parentViewController isKindOfClass:[TrainingViewController class]])
            [((TrainingViewController*)self.parentViewController) hideShareView];
        else if ([self.parentViewController isKindOfClass:[DietPlanViewController class]])
            [((DietPlanViewController*)self.parentViewController) hideShareView];
        else if ([self.parentViewController isKindOfClass:[SupplementPlanViewController class]])
            [((SupplementPlanViewController*)self.parentViewController) hideShareView];
    }
}

- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}

- (void)performPublishAction:(void(^)(void))action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                } else if (error.fberrorCategory != FBErrorCategoryUserCancelled) {
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                                                                        message:@"Unable to get permission to post"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                    [alertView show];
                                                }
                                            }];
    } else {
        action();
    }
    
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
        // we do not need to surface our own alert view if there is an
        // an fberrorUserMessage unless the session is closed.
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
            alertTitle = nil;
            
        } else {
            // Otherwise, use a general "connection problem" message.
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    if (alertTitle) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)uploadImage:(UIImage*)image username:(NSString *)username filename:(NSString *)filename
{
    // [self showProgress:YES];
    [self showProgress:YES];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 90);
    NSString *urlString = [NSString stringWithFormat:@"%@%@?", SERVER_ADDRESS, [NSString stringWithFormat:@"share_%@", UPLOAD_IMAGE]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    // username
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"username\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[username dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // filename
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"filename\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[filename dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // image data
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [self showProgress:NO];
                               if (self.otherProfileController != nil)
                                   [self.otherProfileController hideShareView];
                               else if (self.tabBarController != nil)
                                   [self.tabBarController hideShareView];
                               else if (self.parentViewController != nil) {
                                   if ([self.parentViewController isKindOfClass:[TrainingViewController class]])
                                       [((TrainingViewController*)self.parentViewController) hideShareView];
                                   else if ([self.parentViewController isKindOfClass:[DietPlanViewController class]])
                                       [((DietPlanViewController*)self.parentViewController) hideShareView];
                                   else if ([self.parentViewController isKindOfClass:[SupplementPlanViewController class]])
                                       [((SupplementPlanViewController*)self.parentViewController) hideShareView];
                               }
                               
                               NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                              NSLocalizedString(@"I just shared my Fit-Tab on SternFit, check it out: ", nil), @"name",
                                                              @"Sternfit.com", @"caption",
                                                              NSLocalizedString(@"Chat with people who train near you, share your Fit-Tab.", nil), @"description",
                                                              @"http://www.sternfit.com", @"link",
                                                              [NSString stringWithFormat:@"%@%@_%@", SHARE_IMAGE_URL, username, filename], @"picture",
                                                              nil];
                               
                               // Show the feed dialog
                               [FBWebDialogs presentFeedDialogModallyWithSession:appDelegate.session
                                                                      parameters:params
                                                                         handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                                             if (error) {
                                                                                 // An error occurred, we need to handle the error
                                                                                 // See: https://developers.facebook.com/docs/ios/errors
                                                                                 NSLog(@"Error publishing story: %@", error.description);
                                                                             } else {
                                                                                 if (result == FBWebDialogResultDialogNotCompleted) {
                                                                                     // User canceled.
                                                                                     NSLog(@"User cancelled.");
                                                                                 } else {
                                                                                     // Handle the publish feed callback
                                                                                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Successfully shared", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] ;
                                                                                     [alertView show];
                                                                                 }
                                                                             }
                                                                         }];
                           }];
}

@end

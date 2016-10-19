//
//  SplashViewController.m
//  SternFit
//
//  Created by MacOS on 1/9/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import "SplashViewController.h"
#import "AppDelegate.h"
#import "TrainingPlan.h"
#import "DBManager.h"
#import "DietPlan.h"
#import "SupplementPlan.h"
#import "ASScroll.h"

@interface SplashViewController () {
    int loadingProgress;
    BOOL isFirst;
    int loadIndex;
    
    AppDelegate *appDelegate;
    NSUserDefaults *defaults;
    ASScroll *asScroll;
}

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated {
    asScroll.animateDirection = -1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    defaults = [NSUserDefaults standardUserDefaults];
    
    isFirst = YES;
    
    [self.btnSignin setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateNormal];
    [self.btnRegister setTitle:NSLocalizedString(@"REGISTER", nil) forState:UIControlStateNormal];
    
    self.btnRegister.hidden = YES;
    self.btnSignin.hidden = YES;
    self.imgBg.hidden = YES;
    self.imgLogo.hidden = YES;
    self.btnRegister.alpha = 0.0f;
    self.btnSignin.alpha = 0.0f;
    self.imgLogo.alpha = 0.0f;
    self.imgBg.alpha = 0.0f;
    self.scrollView.hidden = YES;
    self.backView.hidden = YES;
    self.backView.alpha = 0.0f;
    
    [defaults setObject:@"0" forKey:@"weekday"];
    [defaults synchronize];
    
    asScroll = [[ASScroll alloc]initWithFrame:CGRectMake(0.0,0.0,320.0,568.0)];
    
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableArray * imagesArray = [[NSMutableArray alloc]init];
    int noOfImages = 4 ;
    for (int imageCount = 0; imageCount < noOfImages; imageCount++)
    {
        [imagesArray addObject:[NSString stringWithFormat:@"slider%d.jpg",imageCount+1]];
    }
    [asScroll setArrOfImages:imagesArray];
    [self.backView addSubview:asScroll];
    
    self.imgLogo1.frame = CGRectMake(126, 170, 68, 102);
    //self.imgBg.frame = CGRectMake(-100, -100, 520, 768);
    
    if ([defaults objectForKey:@"isLogin"] && [[defaults objectForKey:@"isLogin"] isEqual:@"1"]) {
        
        appDelegate.tabIndex = 0;
        loadingProgress = 0;
        
        if (appDelegate.currentLocation.coordinate.latitude != 0.0f) {
           // [appDelegate.locationManager stopUpdatingLocation];
            NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@&lat=%f&long=%f", SERVER_ADDRESS, UPDATE_USER, [defaults objectForKey:@"name"], appDelegate.currentLocation.coordinate.latitude, appDelegate.currentLocation.coordinate.longitude]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
            
            [request setHTTPMethod:@"POST"];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
             
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   }];
        }
        
        //[self refreshFriends];
        [self refreshNotifications];
        [self loadPlans];
        [self loadDietPlans];
        [self loadSupplementPlans];
        
        return;
    }
    
    [UIView animateWithDuration:1.0f
                          delay:1.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.imgLogo1.frame = CGRectMake(135, 187, 50, 72);
                         //self.imgBg.hidden = NO;
                         self.backView.hidden = NO;
                         self.imgBg.frame = CGRectMake(-70, -70, 460, 708);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    [UIView animateWithDuration:2.0f
                          delay:1.7f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.imgLogo.hidden = NO;
                         self.imgLogo.alpha = 1.0f;
                         //self.imgBg.alpha = 1.0f;
                         self.backView.alpha = 1.0f;
                         //self.imgBg.frame = CGRectMake(0, 0, 320, 568);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    [UIView animateWithDuration:1.0f
                          delay:3.6f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.btnRegister.hidden = NO;
                         self.btnSignin.hidden = NO;
                         self.btnRegister.alpha = 1.0f;
                         self.btnSignin.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         //self.scrollView.hidden = NO;
                         self.imgLogo.hidden = YES;
                         self.imgLogo1.hidden = YES;
                     }];
    
    
    appDelegate.friends = nil;
    appDelegate.nearbyUsers = nil;
    appDelegate.plans = nil;
    appDelegate.notifications = nil;
    
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void) viewWillAppear:(BOOL)animated {
    if (isFirst == NO) {
        self.btnRegister.hidden = NO;
        self.btnSignin.hidden = NO;
        //self.imgBg.hidden = NO;
        self.imgLogo.hidden = YES;
        self.imgLogo1.hidden = YES;
        self.btnRegister.alpha = 1.0f;
        self.btnSignin.alpha = 1.0f;
        self.imgLogo.alpha = 1.0f;
        self.imgBg.alpha = 1.0f;
        
        self.backView.hidden = NO;
        self.backView.alpha = 1.0f;
        
        asScroll.animateDirection = 1;
        [asScroll startAnimation];
        
        self.imgLogo1.hidden = YES;
        self.imgBg.frame = CGRectMake(0, 0, 320, 568);
        
        
        appDelegate.friends = nil;
        appDelegate.nearbyUsers = nil;
        appDelegate.plans = nil;
        appDelegate.notifications = nil;
        
    }
    
    isFirst = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSigninClicked:(id)sender {
    [self performSegueWithIdentifier:@"gotoSigninFromSplash" sender:self];
}

- (IBAction)btnRegisterClicked:(id)sender {
    [self performSegueWithIdentifier:@"gotoRegisterFromSplash" sender:self];
}

- (void) refreshNotifications {
    
    appDelegate.notifications = [[NSMutableArray alloc] init];
    
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?ID=%@", SERVER_ADDRESS, GET_NOTIFICATIONS, [defaults objectForKey:@"userID"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               appDelegate.notificationNum = 0;
                               @try {
                                   if (data != nil) {
                                       NSMutableArray *result = (NSMutableArray*) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       
                                       if (result != nil && [result count] > 0) {
                                           for (int i = 0; i < [result count]; i++) {
                                               NSMutableDictionary *notification = [[NSMutableDictionary alloc] init];
                                               NSMutableDictionary *temp = (NSMutableDictionary*) [result objectAtIndex:i];
                                               [notification setObject:[temp objectForKey:@"image"] forKey:@"image"];
                                               [notification setObject:[temp objectForKey:@"ID"] forKey:@"userid"];
                                               [notification setObject:[temp objectForKey:@"username"] forKey:@"name"];
                                               [notification setObject:[temp objectForKey:@"onlinestatus"] forKey:@"onlinestatus"];
                                               [notification setObject:[temp objectForKey:@"status"] forKey:@"status"];
                                               [notification setObject:[[temp objectForKey:@"updated_at"] substringToIndex:10] forKey:@"sharetime"];
                                               [notification setObject:[temp objectForKey:@"notificationID"] forKey:@"ID"];
                                               if ([[temp objectForKey:@"gender"] intValue] == 1)
                                                   [notification setObject:@"male" forKey:@"gender"];
                                               else
                                                   [notification setObject:@"female" forKey:@"gender"];
                                               if ([[temp objectForKey:@"type"] intValue] == 0)
                                                   [notification setObject:@"1" forKey:@"friendrequest"];
                                               else
                                                   [notification setObject:@"0" forKey:@"friendrequest"];
                                               //[notification setObject:@"Hey Nice to meet you" forKey:@"message"];
                                               
                                               [appDelegate.notifications addObject:notification];
                                               
                                               if ([[temp objectForKey:@"status"] intValue] == 0)
                                                   appDelegate.notificationNum++;
                                           }
                                       }
                                   }
                                   
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   loadingProgress++;
                                   if (loadingProgress == 4) {
                                       [self refreshFriends];
                                   }
                               }
                               
                           }];
    
}

- (void) checkChatRoom:(int) index {
    
    Friend *friend;
    //long secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
    friend = (Friend*) [appDelegate.friends objectAtIndex:index];
    loadIndex = index;
    NSString *lastupdatetime = [[DBManager getSharedInstance] getLastUpdateTime:friend.chatroomID];
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?cID=%@&lastupdatetime=%@&userID=%@", SERVER_ADDRESS, GET_PRIVATE_MESSAGE, friend.chatroomID, lastupdatetime, [defaults objectForKey:@"userID"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               @try {
                                   if (data != nil) {
                                       NSMutableArray *result = (NSMutableArray*) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       
                                       if (result != nil && [result count] > 0) {
                                           NSMutableDictionary *temp;
                                           for (int i = 0; i < [result count]; i++) {
                                               temp = (NSMutableDictionary*) [result objectAtIndex:i];
                                               
                                               long time = [[temp objectForKey:@"lastupdatetime"] longValue];// + secondsFromGMT;
                                               NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:time];
                                               NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                               [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
                                               NSString *date = [dateFormatter stringFromDate: currentTime];
                                               
                                               [[DBManager getSharedInstance] addMessage:[temp objectForKey:@"chatroomID"] senderID:[temp objectForKey:@"senderID"] message:[temp objectForKey:@"message"] type:[temp objectForKey:@"type"] lastupdatetime:[temp objectForKey:@"lastupdatetime"] created_at:date updated_at:date status:@"0"];
                                               
                                               appDelegate.messageNum++;
                                           }
                                       }
                                   }
                                   
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   loadIndex++;
                                   if (loadIndex >= [appDelegate.friends count]) {
                                       if ([appDelegate.groupChatIDs count] > 0) {
                                           [self checkGroupChatRoom:0];
                                       } else {
                                           UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                           MHCustomTabBarController *controller = (MHCustomTabBarController *)[storyboard instantiateViewControllerWithIdentifier:@"MHCustomTabBarController"];
                                           [self.navigationController pushViewController:controller animated:NO];
                                       }
                                   } else {
                                       [self checkChatRoom:loadIndex];
                                   }
                               }
                               
                           }];
}

- (void) checkGroupChatRoom:(int) index {
   // long secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSMutableDictionary *group = (NSMutableDictionary*) [appDelegate.groupChatIDs objectAtIndex:index];
    loadIndex = index;
    NSString *lastupdatetime = [[DBManager getSharedInstance] getLastUpdateTime:[group objectForKey:@"ID"]];
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?cID=%@&lastupdatetime=%@&userID=%@", SERVER_ADDRESS, GET_PRIVATE_MESSAGE, [group objectForKey:@"ID"], lastupdatetime, [defaults objectForKey:@"userID"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               @try {
                                   if (data != nil) {
                                       NSMutableArray *result = (NSMutableArray*) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       
                                       if (result != nil && [result count] > 0) {
                                           NSMutableDictionary *temp;
                                           for (int i = 0; i < [result count]; i++) {
                                               temp = (NSMutableDictionary*) [result objectAtIndex:i];
                                               
                                               long time = [[temp objectForKey:@"lastupdatetime"] longValue];// + secondsFromGMT;
                                               NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:time];
                                               NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                               [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
                                               NSString *date = [dateFormatter stringFromDate: currentTime];
                                               
                                               [[DBManager getSharedInstance] addMessage:[temp objectForKey:@"chatroomID"] senderID:[temp objectForKey:@"senderID"] message:[temp objectForKey:@"message"] type:[temp objectForKey:@"type"] lastupdatetime:[temp objectForKey:@"lastupdatetime"] created_at:date updated_at:date status:@"0"];
                                               
                                               appDelegate.messageNum++;
                                           }
                                       }
                                   }
                                   
                                   
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   loadIndex++;
                                   if (loadIndex >= [appDelegate.groupChatIDs count]) {
                                       UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                       MHCustomTabBarController *controller = (MHCustomTabBarController *)[storyboard instantiateViewControllerWithIdentifier:@"MHCustomTabBarController"];
                                       [self.navigationController pushViewController:controller animated:NO];
                                   } else {
                                       [self checkGroupChatRoom:loadIndex];
                                   }
                               }
                               
                           }];
}

- (void) refreshFriends {
    
    
    appDelegate.friends = [[NSMutableArray alloc] init];
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?ID=%@&lat=%f&lon=%f", SERVER_ADDRESS, GET_FRIENDS, [defaults objectForKey:@"userID"], appDelegate.currentLocation.coordinate.latitude, appDelegate.currentLocation.coordinate.longitude]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               @try {
                                   if (data != nil) {
                                       appDelegate.messageNum = 0;
                                       
                                       NSMutableDictionary *result1 = (NSMutableDictionary*) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       NSMutableArray *result = (NSMutableArray*) [result1 objectForKey:@"friends"];
                                       
                                       appDelegate.groupChatIDs = (NSMutableArray*) [result1 objectForKey:@"group"];
                                       
                                       if (result != nil && [result count] > 0) {
                                           NSMutableDictionary *temp;
                                           for (int i = 0; i < [result count]; i++) {
                                               temp = (NSMutableDictionary*) [result objectAtIndex:i];
                                               Friend *user = [[Friend alloc] init];
                                               user.image = [temp objectForKey:@"image"];
                                               user.photo1 = [temp objectForKey:@"photo1"];
                                               user.photo2 = [temp objectForKey:@"photo2"];
                                               user.photo3 = [temp objectForKey:@"photo3"];
                                               user.photo4 = [temp objectForKey:@"photo4"];
                                               user.photo5 = [temp objectForKey:@"photo5"];
                                               user.distance = [[temp objectForKey:@"distance"] doubleValue] * 1.60934f;
                                               user.userId = [[temp objectForKey:@"ID"] intValue];
                                               user.name = [temp objectForKey:@"username"];
                                               user.message = [temp objectForKey:@"quote"];
                                               user.status = [[temp objectForKey:@"status"] intValue];
                                               user.chatroomID = [temp objectForKey:@"chatroomID"];
                                               user.lastupdatetime = (int)([[temp objectForKey:@"lastupdatetime"] intValue] / 60);
                                               if ([[temp objectForKey:@"gender"] intValue] == 1)
                                                   user.gender = YES;
                                               else
                                                   user.gender = NO;
                                               
                                               user.isFriend = [[temp objectForKey:@"isFriend"] intValue];
                                               
                                               int birthYear = [[[temp objectForKey:@"birthday"] substringToIndex:4] intValue];
                                               NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                               [formatter setDateFormat:@"yyyy"];
                                               int currentYear = [[formatter stringFromDate:[NSDate date]] intValue];
                                               int age = currentYear - birthYear;
                                               user.age = age;
                                               
                                               user.height = [[temp objectForKey:@"height"] intValue];
                                               user.weight = [[temp objectForKey:@"weight"] intValue];
                                               
                                               [appDelegate.friends addObject:user];
                                               
                                               appDelegate.messageNum += [[DBManager getSharedInstance] getLastUnreadMessageNum:user.chatroomID];
                                           }
                                       }
                                   }
                                   
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   if ([appDelegate.friends count] > 0) {
                                       [self checkChatRoom:0];
                                   } else {
                                       if ([appDelegate.groupChatIDs count] > 0) {
                                           [self checkGroupChatRoom:0];
                                       } else {
                                           UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                           MHCustomTabBarController *controller = (MHCustomTabBarController *)[storyboard instantiateViewControllerWithIdentifier:@"MHCustomTabBarController"];
                                           [self.navigationController pushViewController:controller animated:NO];
                                       }
                                       
                                   }
                               }
                               
                           }];
}

- (void) loadPlans {
    
    appDelegate.plans = [[NSMutableArray alloc] init];
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?uID=%@", SERVER_ADDRESS, GET_TRAININGPLANS, [defaults objectForKey:@"userID"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               @try {
                                   if (data != nil) {
                                       NSMutableArray *result = (NSMutableArray*) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       
                                       if (result != nil && [result count] > 0) {
                                           NSMutableArray *weekTemp;
                                           NSMutableDictionary *temp;
                                           for (int i = 0; i < [result count]; i++) {
                                               weekTemp = (NSMutableArray*) [result objectAtIndex:i];
                                               NSMutableArray *week = [[NSMutableArray alloc] init];
                                               for (int j = 0; j < [weekTemp count]; j++) {
                                                   temp = (NSMutableDictionary*) [weekTemp objectAtIndex:j];
                                                   
                                                   TrainingPlan *plan = [[TrainingPlan alloc] init];
                                                   plan.ID = [temp objectForKey:@"ID"];
                                                   plan.weekday = [[temp objectForKey:@"weekday"] intValue];
                                                   plan.detail = [temp objectForKey:@"detail"];
                                                   plan.notes = [temp objectForKey:@"notes"];
                                                   Exercise *exercise = [[Exercise alloc] init];
                                                   exercise.ID = [temp objectForKey:@"eID"];
                                                   exercise.name = [temp objectForKey:@"name"];
                                                   exercise.image = [temp objectForKey:@"image"];
                                                   exercise.type = [[temp objectForKey:@"type"] intValue];
                                                   exercise.categoryID = [temp objectForKey:@"categoryID"];
                                                   plan.exercise = exercise;
                                                   
                                                   [week addObject:plan];
                                               }
                                               
                                               [appDelegate.plans addObject:week];
                                           }
                                       }
                                   }
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   
                                   loadingProgress++;
                                   if (loadingProgress == 4) {
                                       [self refreshFriends];
                                   }
                               }
                               
                           }];
}

- (void) loadDietPlans {
    
    appDelegate.dietplans = [[NSMutableArray alloc] init];
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?uID=%@", SERVER_ADDRESS, GET_DIETPLANS, [defaults objectForKey:@"userID"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               @try {
                                   if (data != nil) {
                                       NSMutableArray *result = (NSMutableArray*) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       
                                       if (result != nil && [result count] > 0) {
                                           NSMutableArray *weekTemp;
                                           NSMutableDictionary *temp;
                                           for (int i = 0; i < [result count]; i++) {
                                               weekTemp = (NSMutableArray*) [result objectAtIndex:i];
                                               NSMutableArray *week = [[NSMutableArray alloc] init];
                                               for (int j = 0; j < [weekTemp count]; j++) {
                                                   temp = (NSMutableDictionary*) [weekTemp objectAtIndex:j];
                                                   
                                                   DietPlan *plan = [[DietPlan alloc] init];
                                                   plan.ID = [temp objectForKey:@"ID"];
                                                   plan.weekday = [[temp objectForKey:@"weekday"] intValue];
                                                   plan.notes = [temp objectForKey:@"notes"];
                                                   Exercise *exercise = [[Exercise alloc] init];
                                                   exercise.ID = [temp objectForKey:@"eID"];
                                                   exercise.name = [temp objectForKey:@"name"];
                                                   exercise.image = [temp objectForKey:@"image"];
                                                   exercise.categoryID = @"8";
                                                   exercise.type = 4;
                                                   plan.exercise = exercise;
                                                   
                                                   [week addObject:plan];
                                               }
                                               
                                               [appDelegate.dietplans addObject:week];
                                           }
                                       }
                                   }
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   
                                   loadingProgress++;
                                   if (loadingProgress == 4) {
                                       [self refreshFriends];
                                   }
                               }
                               
                           }];
}

- (void) loadSupplementPlans {
    
    appDelegate.supplementplans = [[NSMutableArray alloc] init];
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?uID=%@", SERVER_ADDRESS, GET_SUPPLEMENTPLANS, [defaults objectForKey:@"userID"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               @try {
                                   if (data != nil) {
                                       NSMutableArray *result = (NSMutableArray*) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       
                                       if (result != nil && [result count] > 0) {
                                           NSMutableArray *weekTemp;
                                           NSMutableDictionary *temp;
                                           for (int i = 0; i < [result count]; i++) {
                                               weekTemp = (NSMutableArray*) [result objectAtIndex:i];
                                               NSMutableArray *week = [[NSMutableArray alloc] init];
                                               for (int j = 0; j < [weekTemp count]; j++) {
                                                   temp = (NSMutableDictionary*) [weekTemp objectAtIndex:j];
                                                   
                                                   SupplementPlan *plan = [[SupplementPlan alloc] init];
                                                   plan.ID = [temp objectForKey:@"ID"];
                                                   plan.weekday = [[temp objectForKey:@"weekday"] intValue];
                                                   plan.notes = [temp objectForKey:@"notes"];
                                                   Exercise *exercise = [[Exercise alloc] init];
                                                   exercise.ID = [temp objectForKey:@"eID"];
                                                   exercise.name = [temp objectForKey:@"name"];
                                                   exercise.image = [temp objectForKey:@"image"];
                                                   exercise.categoryID = @"9";
                                                   exercise.type = 5;
                                                   plan.exercise = exercise;
                                                   
                                                   [week addObject:plan];
                                               }
                                               
                                               [appDelegate.supplementplans addObject:week];
                                           }
                                       }
                                   }
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   
                                   loadingProgress++;
                                   if (loadingProgress == 4) {
                                       [self refreshFriends];
                                   }
                               }
                               
                           }];
}


@end

//
//  NearbyViewController.m
//  SternFit
//
//  Created by MacOS on 12/10/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "NearbyViewController.h"
#import "MessageViewController.h"
#import "NotificationViewController.h"
#import "AppDelegate.h"
#import "SideMenuViewController.h"
#import "MBProgressHUD.h"
#import "NearbyTableViewCell.h"
#import "TrainingPlan.h"
#import "SVPullToRefresh.h"
#import "DBManager.h"
#import "DietPlan.h"
#import "SupplementPlan.h"

@interface NearbyViewController () {
    BOOL isRetina;
    NSMutableArray *tempNearbyUsers;
    AppDelegate *appDelegate;
    Friend *selectFriend;
    int loadingProgress;
    NSUserDefaults *defaults;
    MBProgressHUD *HUD;
}

@end

@implementation NearbyViewController

//@synthesize labelExtramenu, labelFittab, labelMessage, labelMessageNum, labelNearby, labelNotification, labelNotificationNum, navView;

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
    defaults = [NSUserDefaults standardUserDefaults];
    
    UITapGestureRecognizer *tapView8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editViewTap:)];
    tapView8.delegate = self;
    [self.nearbyView1 addGestureRecognizer:tapView8];
    
    UITapGestureRecognizer *tapView1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editViewTap:)];
    tapView1.delegate = self;
    [self.nearbyView2 addGestureRecognizer:tapView1];
    
    UITapGestureRecognizer *tapView2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoViewTap:)];
    tapView2.delegate = self;
    [self.imgProfile addGestureRecognizer:tapView2];
    [self.imgProfile setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapView3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoViewTap:)];
    tapView3.delegate = self;
    [self.imgPhoto1 addGestureRecognizer:tapView3];
    [self.imgPhoto1 setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapView4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoViewTap:)];
    tapView4.delegate = self;
    [self.imgPhoto2 addGestureRecognizer:tapView4];
    [self.imgPhoto2 setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapView5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoViewTap:)];
    tapView5.delegate = self;
    [self.imgPhoto3 addGestureRecognizer:tapView5];
    [self.imgPhoto3 setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapView6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoViewTap:)];
    tapView6.delegate = self;
    [self.imgPhoto4 addGestureRecognizer:tapView6];
    [self.imgPhoto4 setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapView7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoViewTap:)];
    tapView7.delegate = self;
    [self.imgPhoto5 addGestureRecognizer:tapView7];
    [self.imgPhoto5 setUserInteractionEnabled:YES];
    
    UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    self.imgProfile.layer.borderColor = borderColor.CGColor;
    self.imgProfile.layer.borderWidth = 2.0f;
    self.imgProfile.layer.cornerRadius = 47.0f;
    self.imgProfile.layer.masksToBounds = YES;
    self.imgPhoto1.layer.masksToBounds = YES;
    self.imgPhoto2.layer.masksToBounds = YES;
    self.imgPhoto3.layer.masksToBounds = YES;
    self.imgPhoto4.layer.masksToBounds = YES;
    self.imgPhoto5.layer.masksToBounds = YES;
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == 480)
        isRetina = true;
    else
        isRetina = false;
    
    self.labelUsername.font = [UIFont fontWithName:@"Lato-Bold" size:16.0f];
    self.labelQuote.font = [UIFont fontWithName:@"Lato-Regular" size:13.0f];
    self.labelAge.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    self.labelWeight.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    self.labelHeight.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    self.labelNearbyTitle.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    //[self redirectToTab];
    //self->appDelegate.selectOtherUser = nil;
    self.txtSearch.text = @"";
    self->appDelegate.currentViewController = self;
    if (self->appDelegate.tabIndex == 2) {
        if ([self.parentViewController isKindOfClass:[MHCustomTabBarController class]]) {
            [((MHCustomTabBarController*) self.parentViewController) moveToFittab];
        }
        return;
    }
    [self loadLabelForBottomMenu];
    
    [self showProgress:YES text:@""];
    
    __weak typeof(self) weakSelf = self;
    [self.friendsTableView addPullToRefreshWithActionHandler:^{
        weakSelf.pullToRefreshFlag = YES;
        [weakSelf refreshUsers];
    }];
    
    if (appDelegate.friends == nil) {
        loadingProgress = 10;
        [self loadPlans];
        [self refreshNotifications];
        [self refreshFriends];
        [self loadDietPlans];
        [self loadSupplementPlans];
    } else {
        loadingProgress = 0;
        [((MHCustomTabBarController*) self.parentViewController) updateMessageNum:appDelegate.messageNum];
        [((MHCustomTabBarController*) self.parentViewController) updateNotificationNum:appDelegate.notificationNum];
    }
    [self refreshUsers];
    
    
    UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    self.labelStatus.layer.borderColor = borderColor.CGColor;
    self.labelStatus.layer.borderWidth = 2.0f;
    self.labelStatus.layer.cornerRadius = 7.5f;
    if ([[defaults objectForKey:@"visibleMode"] intValue] == 2) {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
    } else {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:227.0f/255.0f blue:54.0f/255.0f alpha:1];
    }
}

- (void) refreshNotifications {
    
    self->appDelegate.notifications = [[NSMutableArray alloc] init];
    
    
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
                                               
                                               [self->appDelegate.notifications addObject:notification];
                                               
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
                                   if (loadingProgress == 16)
                                       [self showProgress:NO text:@""];
                                   
                                   [((MHCustomTabBarController*) self.parentViewController) updateNotificationNum:appDelegate.notificationNum];
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
                                   loadingProgress++;
                                   if (loadingProgress == 16)
                                       [self showProgress:NO text:@""];
                                   
                                   [((MHCustomTabBarController*) self.parentViewController) updateMessageNum:appDelegate.messageNum];
                               }
                               
                           }];
}

- (void) loadPlans {
    
    self->appDelegate.plans = [[NSMutableArray alloc] init];
    
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
                                   if (loadingProgress == 16)
                                       [self showProgress:NO text:@""];
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
                                   if (loadingProgress == 16) {
                                       [self showProgress:NO text:@""];
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
                                   if (loadingProgress == 16) {
                                       [self showProgress:NO text:@""];
                                   }
                               }
                               
                           }];
}

- (void) refreshUsers {
    if (![self.txtSearch.text isEqual:@""]) {
        [self searchUsers:self.txtSearch.text];
        return;
    }
    self->appDelegate.nearbyUsers = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *filters = (NSMutableDictionary*) [defaults objectForKey:@"nearby_filters"];

    double distance = [[filters objectForKey:@"distance"] doubleValue];
    int appear_time = [[filters objectForKey:@"appear_time"] intValue];
    switch (appear_time) {
        case 0:
            appear_time = 30;
            break;
        case 1:
            appear_time = 60;
            break;
        case 2:
            appear_time = 24 * 60;
            break;
        case 3:
            appear_time = 3 * 24 * 60;
            break;
    }
    if (distance == 0.0f) {
        if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
            distance = 0.5f;
        } else {
            distance = 0.5f * 1.60934f;
        }
    } else if (distance == 1.0f) {
        if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
            distance = 1.0f;
        } else {
            distance = 1.0f * 1.60934f;
        }
    } else if (distance == 2.0f) {
        if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
            distance = 5.0f;
        } else {
            distance = 5.0f * 1.60934f;
        }
    }
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@&lat=%.3f&lon=%.3f&distance=%f&age_start=%@&age_end=%@&appear=%d&gender=%@&isFilter=1&userID=%@", SERVER_ADDRESS, NEARBY_USERS, [defaults objectForKey:@"name"], self->appDelegate.currentLocation.coordinate.latitude, self->appDelegate.currentLocation.coordinate.longitude, distance, [filters objectForKey:@"age_start"], [filters objectForKey:@"age_end"], appear_time, [filters objectForKey:@"gender"], [defaults objectForKey:@"userID"]]];
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
                                               
                                               [self->appDelegate.nearbyUsers addObject:user];
                                           }
                                       }
                                   }
                                   
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   if (self.pullToRefreshFlag == NO) {
                                       loadingProgress++;
                                       if (loadingProgress == 1 || loadingProgress == 16)
                                           [self showProgress:NO text:@""];
                                   } else {
                                       self.pullToRefreshFlag = NO;
                                       [self.friendsTableView.pullToRefreshView stopAnimating];
                                   }
                                   self->tempNearbyUsers = self->appDelegate.nearbyUsers;
                                   [self.friendsTableView reloadData];
                               }
                               
                           }];
}

- (void) loadLabelForBottomMenu {
    self.labelNearbyTitle.text = NSLocalizedString(@"Nearby", nil);
    //[self.btnFilter setTitle:[NSString stringWithFormat:@"  %@", NSLocalizedString(@"FILTER", nil)] forState:UIControlStateNormal];
    
    
    self.labelUsername.text = [defaults objectForKey:@"name"];
    self.labelQuote.text = [defaults objectForKey:@"quote"];
    self.labelAge.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Age", nil), [defaults objectForKey:@"age"]];
    /*int height = [[defaults objectForKey:@"height"] intValue];
    int weight = [[defaults objectForKey:@"weight"] intValue];
    self.labelHeight.text = [NSString stringWithFormat:@"%@: %dm%d", NSLocalizedString(@"Height", nil), height / 100, height % 100];
    self.labelWeight.text = [NSString stringWithFormat:@"%@: %dkg", NSLocalizedString(@"Weight", nil), weight];*/
    double height = [[defaults objectForKey:@"height"] doubleValue];
    int weight = [[defaults objectForKey:@"weight"] intValue];
    if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
        height = height * 0.0328084f;
        weight = (int)((double)weight * 2.20462f);
        self.labelHeight.text = [NSString stringWithFormat:@"%@: %d'%d\"", NSLocalizedString(@"Height", nil), (int)height, (int)(height * 10) % 10];
        self.labelWeight.text = [NSString stringWithFormat:@"%@: %dlbs", NSLocalizedString(@"Weight", nil), weight];
    } else {
        self.labelHeight.text = [NSString stringWithFormat:@"%@: %dcm", NSLocalizedString(@"Height", nil), (int)height];
        self.labelWeight.text = [NSString stringWithFormat:@"%@: %dkg", NSLocalizedString(@"Weight", nil), weight];
    }
    
    //self.txtSearch.text = NSLocalizedString(@"SEARCH SOMEONE", nil);
    
    if ([[defaults objectForKey:@"gender"] isEqual:@"male"]) {
        UIColor *borderColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
        self.imgProfile.layer.borderColor = borderColor.CGColor;
    } else {
        UIColor *borderColor = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:90.0f/255.0f alpha:1];
        self.imgProfile.layer.borderColor = borderColor.CGColor;
    }
    
    if ([defaults objectForKey:@"profile"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"profile.jpg"];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
        [self.imgProfile setImage:image];
        /*if ([self.imgProfile isKindOfClass:[AsyncImageView class]]) {
            [self.imgProfile setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self.imgProfile setImageURL: [NSURL URLWithString:@"http://192.168.0.76/sternfit/uploads/test1_profile.jpg"]];
            //[self.imgProfile setImage:image];
        }*/
        
    }
    if ([defaults objectForKey:@"photo1"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"photo1.jpg"];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
        [self.imgPhoto1 setImage:image];
    }
    
    if ([defaults objectForKey:@"photo2"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"photo2.jpg"];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
        [self.imgPhoto2 setImage:image];
    }
    
    if ([defaults objectForKey:@"photo3"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"photo3.jpg"];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
        [self.imgPhoto3 setImage:image];
    }
    
    if ([defaults objectForKey:@"photo4"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"photo4.jpg"];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
        [self.imgPhoto4 setImage:image];
    }
    
    if ([defaults objectForKey:@"photo5"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"photo5.jpg"];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
        [self.imgPhoto5 setImage:image];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnFilterClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FilterViewController *controller = (FilterViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FilterViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma - mark TextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //if ([textField.text isEqual:NSLocalizedString(@"SEARCH SOMEONE", nil)]) {
    //    textField.text = @"";
    //}
    
    if (isRetina) {
        [UIView animateWithDuration:0.1f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = self.view.frame;
                             frame.origin.y = -30;
                             self.view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //if ([textField.text isEqual:@""]) {
   //     textField.text = NSLocalizedString(@"SEARCH SOMEONE", nil);
    //}
}

- (void) searchUsers:(NSString *) search {
    if ([search isEqual:@""]) {
        self->appDelegate.nearbyUsers = self->tempNearbyUsers;
    } else {
        if (self.pullToRefreshFlag == NO)
            [self showProgress:YES text:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Searching for", nil), search]];
        appDelegate.nearbyUsers = [[NSMutableArray alloc] init];
        
        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@&lat=%f&lon=%f&isFilter=0&userID=%@", SERVER_ADDRESS, NEARBY_USERS, search, self->appDelegate.currentLocation.coordinate.latitude, self->appDelegate.currentLocation.coordinate.longitude, [defaults objectForKey:@"userID"]]];
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
                                                   
                                                   [self->appDelegate.nearbyUsers addObject:user];
                                               }
                                           }
                                       }
                                       
                                       
                                   }
                                   @catch (NSException *exception) {
                                       
                                   }
                                   @finally {
                                       if (self.pullToRefreshFlag == NO) {
                                           [self showProgress:NO text:@""];
                                       } else {
                                           self.pullToRefreshFlag = NO;
                                           [self.friendsTableView.pullToRefreshView stopAnimating];
                                       }
                                       //self->tempNearbyUsers = self->appDelegate.nearbyUsers;
                                       [self.friendsTableView reloadData];
                                   }
                               }];
    }
    [self.friendsTableView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {  // return NO to not change text
    /*NSString *search = self.txtSearch.text;
    
    if ([string isEqual:@"\n"]) {
        [self.txtSearch resignFirstResponder];
        return NO;
    } else if ([string isEqual:@""]) {
        if ([search length] >= 1) {
            search = [search substringToIndex:([search length] - 1)];
        }
    } else {
        search = [NSString stringWithFormat:@"%@%@", search, string];
    }
    
    [self searchUsers:search];*/
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ([self.txtSearch.text isEqual:@""]) {
        self->appDelegate.nearbyUsers = self->tempNearbyUsers;
    } else {
        /*self->appDelegate.nearbyUsers = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self->tempNearbyUsers count]; i++) {
            Friend *friend = (Friend*) [self->tempNearbyUsers objectAtIndex:i];
            if ([[friend.name lowercaseString] rangeOfString:[self.txtSearch.text lowercaseString]].location != NSNotFound) {
                [self->appDelegate.nearbyUsers addObject:friend];
            }
        }*/
        [self searchUsers:self.txtSearch.text];
    }
    [self.friendsTableView reloadData];
    
    [self.txtSearch resignFirstResponder];
    if (isRetina) {
        [UIView animateWithDuration:0.1f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = self.view.frame;
                             frame.origin.y = 0;
                             self.view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    return YES;
}

- (IBAction)editViewTap:(UITapGestureRecognizer*)recognizer {
    [self.txtSearch resignFirstResponder];
    if (isRetina) {
        [UIView animateWithDuration:0.1f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = self.view.frame;
                             frame.origin.y = 0;
                             self.view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void) showProgress:(BOOL) flag text:(NSString*)text {
    if (flag) {
        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [HUD setLabelFont:[UIFont fontWithName:@"MyriadPro-Regular" size:17.0f]];
        [HUD setLabelText:text];
    } else {
        //[MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
        [HUD hide:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (appDelegate.nearbyUsers == nil)
        return 0;
    
    return [self->appDelegate.nearbyUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"NearbyTableViewCell";
    
    NearbyTableViewCell *cell = (NearbyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //cell.parent = self;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NearbyTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Friend *user = (Friend*) [self->appDelegate.nearbyUsers objectAtIndex:indexPath.row];
    cell.index = (int)indexPath.row;
    cell.parent = self;
    [cell setData:user];
    
    return cell;
}


- (void) gotoOtherProfile:(int) index
{
    self->appDelegate.selectOtherUser = (Friend*) [self->appDelegate.nearbyUsers objectAtIndex:index];

    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherProfileViewController *controller = (OtherProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"OtherProfileViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)addFriend:(int) index {
    self->selectFriend = (Friend*) [self->appDelegate.nearbyUsers objectAtIndex:index];
    if (selectFriend.isFriend == 1) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChatViewController *controller = (ChatViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
        controller.isPrivateChat = 1;
        controller.users = [[NSMutableArray alloc] init];
        [controller.users addObject:selectFriend];
        controller.chatroomID = selectFriend.chatroomID;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        NSString *message = NSLocalizedString(@"Are you sure to add her as your friend?", nil);
        if (self->selectFriend.gender == YES)
            message = NSLocalizedString(@"Are you sure to add him as your friend?", nil);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] ;
        alertView.tag = index;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)localAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 	1) {
        self->selectFriend.isFriend = 2;
        [self.friendsTableView reloadData];
        
        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?fromUserID=%@&fromUsername=%@&toUserID=%d&toUsername=%@&type=0", SERVER_ADDRESS, SEND_PUSH, [defaults objectForKey:@"userID"], [defaults objectForKey:@"name"], self->selectFriend.userId, self->selectFriend.name]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
        
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
         
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath      *)indexPath;
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)photoViewTap:(UITapGestureRecognizer*)recognizer {
    [self.txtSearch resignFirstResponder];
    if (isRetina) {
        [UIView animateWithDuration:0.1f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = self.view.frame;
                             frame.origin.y = 0;
                             self.view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    
    NSString *filename = @"";
    
    if (recognizer.view == self.imgProfile) {
        if ([defaults objectForKey:@"profile"]) {
            filename = @"profile.jpg";
        }
    }
    if (recognizer.view == self.imgPhoto1) {
        if ([defaults objectForKey:@"photo1"]) {
            filename = @"photo1.jpg";
        }
    }
    
    if (recognizer.view == self.imgPhoto2) {
        if ([defaults objectForKey:@"photo2"]) {
            filename = @"photo2.jpg";
        }
    }
    
    if (recognizer.view == self.imgPhoto3) {
        if ([defaults objectForKey:@"photo3"]) {
            filename = @"photo3.jpg";
        }
    }
    
    if (recognizer.view == self.imgPhoto4) {
        if ([defaults objectForKey:@"photo4"]) {
            filename = @"photo4.jpg";
        }
    }
    
    if (recognizer.view == self.imgPhoto5) {
        if ([defaults objectForKey:@"photo5"]) {
            filename = @"photo5.jpg";
        }
    }
    
    if (![filename isEqual:@""]) {
        if ([self.parentViewController isKindOfClass:[MHCustomTabBarController class]]) {
            [((MHCustomTabBarController*) self.parentViewController) showImageHighlight:filename];
        }
    }
}

@end

//
//  NotificationViewController.m
//  SternFit
//
//  Created by MacOS on 12/10/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "NotificationViewController.h"
#import "MessageViewController.h"
#import "AppDelegate.h"
#import "NotificationTableViewCell.h"
#import "MBProgressHUD.h"

@interface NotificationViewController () {
    NSMutableDictionary *selectFriend;
    NSUserDefaults *defaults;
    AppDelegate *appDelegate;
}

@end

@implementation NotificationViewController

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
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    CGRect frame = self.notificationTableView.frame;
    frame.size.height = iOSDeviceScreenSize.height - 115;
    self.notificationTableView.frame = frame;
    
    [self loadLabelForBottomMenu];
    
    self.labelPageTitle.font = [UIFont fontWithName:@"MyraidPro-Regular" size:17.0f];
}

- (void) viewWillAppear:(BOOL)animated {
    
    appDelegate.currentViewController = self;
    [appDelegate refreshNotifications];
}

- (void) reloadTable {
    [self.notificationTableView reloadData];
}

- (void) loadLabelForBottomMenu {

    self.labelPageTitle.text = NSLocalizedString(@"Notifications", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if (appDelegate.notifications == nil)
        return 0;
    return [appDelegate.notifications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"NotificationTableViewCell";
    
    NotificationTableViewCell *cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //cell.parent = self;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableDictionary *user = (NSMutableDictionary*) [appDelegate.notifications objectAtIndex:indexPath.row];
    
    cell.index = (int) indexPath.row;
    cell.controller = self;
    [cell setData:user];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)deleteNotification:(int) index {
    
    NSMutableDictionary *temp = (NSMutableDictionary*) [appDelegate.notifications objectAtIndex:index];
    
    [self showProgress:YES];
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?ID=%@", SERVER_ADDRESS, DELETE_NOTIFICATION, [temp objectForKey:@"ID"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               @try {
                                   
                                   [appDelegate.notifications removeObjectAtIndex:index];
                                   [appDelegate.tabBarController updateNotificationNum:(int)[appDelegate.notifications count]];
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   [self showProgress:NO];
                                   [self.notificationTableView reloadData];
                               }
                               
                        }];
    
}

- (void)addFriend:(int) index {
    
    appDelegate.fromIndex = 3;
    selectFriend = (NSMutableDictionary*) [appDelegate.notifications objectAtIndex:index];
    if ([[selectFriend objectForKey:@"status"] intValue] == 3) {
        for (int i = 0; i < [appDelegate.friends count]; i++) {
            Friend *friend = (Friend*) [appDelegate.friends objectAtIndex:i];
            if (friend.userId == [[selectFriend objectForKey:@"userid"] intValue]) {
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ChatViewController *controller = (ChatViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
                controller.isPrivateChat = 1;
                controller.users = [[NSMutableArray alloc] init];
                [controller.users addObject:friend];
                controller.chatroomID = friend.chatroomID;
                [self.navigationController pushViewController:controller animated:YES];
                return;
            }
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Are you sure to add your friend?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] ;
        alertView.tag = 1;
        [alertView show];
    }
}

- (void)acceptFriendRequest:(int) index {
    
    selectFriend = (NSMutableDictionary*) [appDelegate.notifications objectAtIndex:index];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Are you sure to accept friend request?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] ;
    alertView.tag = 2;
    [alertView show];
}

- (void)declineFriendRequest:(int) index {
    
    selectFriend = (NSMutableDictionary*) [appDelegate.notifications objectAtIndex:index];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Are you sure to decline friend request?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] ;
    alertView.tag = 3;
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)localAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (localAlertView.tag == 1) {
        if (buttonIndex == 	1) {
            [self showProgress:YES];
            
            
            NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?fromUserID=%@&fromUsername=%@&toUserID=%@&toUsername=%@&type=0", SERVER_ADDRESS, SEND_PUSH, [defaults objectForKey:@"userID"], [defaults objectForKey:@"name"], [selectFriend objectForKey:@"userid"], [selectFriend objectForKey:@"name"]]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
            
            [request setHTTPMethod:@"POST"];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
             
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       @try {
                                           
                                           [appDelegate refreshNotifications];
                                           
                                       }
                                       @catch (NSException *exception) {
                                           
                                       }
                                       @finally {
                                           [self.notificationTableView reloadData];
                                           [self showProgress:NO];
                                       }
                                       
                                   }];
        }
    } else if (localAlertView.tag == 2) {
        if (buttonIndex == 1) {
            
            
            NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?fromUserID=%@&fromUsername=%@&toUserID=%@&toUsername=%@&type=0", SERVER_ADDRESS, SEND_PUSH, [defaults objectForKey:@"userID"], [defaults objectForKey:@"name"], [selectFriend objectForKey:@"userid"], [selectFriend objectForKey:@"name"]]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
            
            [request setHTTPMethod:@"POST"];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
             
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       @try {
                                           
                                           [appDelegate refreshNotifications];
                                           
                                       }
                                       @catch (NSException *exception) {
                                           
                                       }
                                       @finally {
                                           [self.notificationTableView reloadData];
                                           [self showProgress:NO];
                                       }
                                       
                                   }];
        }
    } else if (localAlertView.tag == 3) {
        if (buttonIndex == 1) {
            
            
            NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?fromUserID=%@&fromUsername=%@&toUserID=%@&toUsername=%@&type=2", SERVER_ADDRESS, SEND_PUSH, [defaults objectForKey:@"userID"], [defaults objectForKey:@"name"], [selectFriend objectForKey:@"userid"], [selectFriend objectForKey:@"name"]]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
            
            [request setHTTPMethod:@"POST"];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
             
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       @try {
                                           
                                           [appDelegate refreshNotifications];
                                           
                                       }
                                       @catch (NSException *exception) {
                                           
                                       }
                                       @finally {
                                           [self.notificationTableView reloadData];
                                           [self showProgress:NO];
                                       }
                                       
                                   }];
        }
    }
}

- (void) checkNotification:(int) index {
    
    NSMutableDictionary *temp = (NSMutableDictionary*) [appDelegate.notifications objectAtIndex:index];
    
    if ([[temp objectForKey:@"friendrequest"] isEqual:@"1"] && [[temp objectForKey:@"status"] intValue] == 0) {
        
    } else {
        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?ID=%@", SERVER_ADDRESS, CHECK_NOTIFICATION, [temp objectForKey:@"ID"]]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
        
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
         
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               }];
    }
    
    
    
    
    Friend *friend;
    for (int i = 0; i < [appDelegate.friends count]; i++) {
        friend = (Friend*) [appDelegate.friends objectAtIndex:i];
        if ([friend.name isEqual:[temp objectForKey:@"name"]]) {
            appDelegate.selectOtherUser = friend;
            appDelegate.fromIndex = 3;
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OtherProfileViewController *controller = (OtherProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"OtherProfileViewController"];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
    }
}

- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}

@end

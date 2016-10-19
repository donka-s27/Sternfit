//
//  MessageViewController.m
//  SternFit
//
//  Created by MacOS on 12/10/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "MessageViewController.h"
#import "NearbyViewController.h"
#import "NotificationViewController.h"
#import "AppDelegate.h"
#import "MessageTableViewCell.h"
#import "DBManager.h"
#import "SVPullToRefresh.h"
#import "Message.h"

@interface MessageViewController () {
    NSMutableArray *messages;
    AppDelegate *appDelegate;
    BOOL isFirsttimeLoading;
    int loadIndex;
}

@end

@implementation MessageViewController


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
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    CGRect frame = self.messagesTableView.frame;
    frame.size.height = iOSDeviceScreenSize.height - 120;
    self.messagesTableView.frame = frame;
    
    [self loadLabelForBottomMenu];
    self.labelPageTitle.font = [UIFont fontWithName:@"MyraidPro-Regular" size:17.0f];
}

- (void) viewWillAppear:(BOOL)animated {
    appDelegate.currentViewController = self;
    
    isFirsttimeLoading = YES;
    __weak typeof(self) weakSelf = self;
    [self.messagesTableView addPullToRefreshWithActionHandler:^{
        weakSelf.pullToRefreshFlag = YES;
        [weakSelf loadMessages];
    }];
    [self loadMessages];
    
    [appDelegate.tabBarController updateMessageNum:appDelegate.messageNum];
}

- (void) loadLabelForBottomMenu {
    self.labelPageTitle.text = NSLocalizedString(@"Messages", nil);
}

- (void) loadMessages {
    messages = [[NSMutableArray alloc] init];
    
    if (isFirsttimeLoading == YES)
        [self showProgress:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    appDelegate.friends = [[NSMutableArray alloc] init];
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?ID=%@&lat=%f&lon=%f", SERVER_ADDRESS, GET_FRIENDS, [defaults objectForKey:@"userID"], appDelegate.currentLocation.coordinate.latitude, appDelegate.currentLocation.coordinate.longitude]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               @try {
                                   if (data != nil) {
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
                                           }
                                       }
                                   }
                                   
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   if ([appDelegate.friends count] > 0)
                                       [self checkChatRoom:0];
                                   else {
                                       if ([appDelegate.groupChatIDs count] > 0) {
                                           [self checkGroupChatRoom:0];
                                       } else {
                                           if (isFirsttimeLoading == YES)
                                               [self showProgress:NO];
                                           
                                           if (self.pullToRefreshFlag == YES) {
                                               self.pullToRefreshFlag = NO;
                                               [self.messagesTableView.pullToRefreshView stopAnimating];
                                           }
                                           
                                           [self.messagesTableView reloadData];
                                           
                                           isFirsttimeLoading = NO;
                                       }
                                   }
                               }
                               
                           }];
}

- (void) checkGroupChatRoom:(int) index {
    //long secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSMutableDictionary *group = (NSMutableDictionary*) [appDelegate.groupChatIDs objectAtIndex:index];
    loadIndex = index;
    NSString *lastupdatetime = [[DBManager getSharedInstance] getLastUpdateTime:[group objectForKey:@"ID"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
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
                                   
                                   NSMutableArray *result = (NSMutableArray*) [[DBManager getSharedInstance] getLastUnreadMessage:[group objectForKey:@"ID"]];
                                   
                                   if (result != nil && [result count] > 0) {
                                       NSMutableDictionary *temp = (NSMutableDictionary *) [result objectAtIndex:0];
                                       Message *message = [[Message alloc] init];
                                       message.image = @"";
                                       if ([[group objectForKey:@"name"] isEqual:@"Group"])
                                           message.username = [group objectForKey:@"members"];
                                       else
                                           message.username = [group objectForKey:@"name"];
                                       
                                       int messageType = [[temp objectForKey:@"type"] intValue];
                                       switch (messageType) {
                                           case 1:
                                               message.message = @"[Emoji]";
                                               break;
                                           case 2:
                                               message.message = @"[Image]";
                                               break;
                                           case 3:
                                               message.message = @"[Location]";
                                               break;
                                           case 4:
                                               message.message = @"[Voice Message]]";
                                               break;
                                           case 100:
                                               message.message = [temp objectForKey:@"message"];
                                           case 0:
                                               message.message = [temp objectForKey:@"message"];
                                       }
                                       message.distance = -1;
                                       
                                       message.messagetime = [[temp objectForKey:@"lastupdatetime"] intValue];
                                       message.lastupdatetime = -1;
                                       message.gender = @"male";
                                       message.onlinestatus = -1;
                                       
                                       message.messageNum = [[DBManager getSharedInstance] getLastUnreadMessageNum:[group objectForKey:@"ID"]];
                                       
                                       [messages addObject:message];
                                   }
                                   
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   loadIndex++;
                                   if (loadIndex >= [appDelegate.groupChatIDs count]) {
                                       if (isFirsttimeLoading == YES)
                                           [self showProgress:NO];
                                       
                                       if (self.pullToRefreshFlag == YES) {
                                           self.pullToRefreshFlag = NO;
                                           [self.messagesTableView.pullToRefreshView stopAnimating];
                                       }
                                       
                                       messages = (NSMutableArray*) [messages sortedArrayUsingSelector:@selector(sortByMessageTime:)];
                                       
                                       [self.messagesTableView reloadData];
                                       
                                       isFirsttimeLoading = NO;
                                       
                                       [appDelegate.tabBarController updateMessageNum:appDelegate.messageNum];
                                   } else {
                                       [self checkGroupChatRoom:loadIndex];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
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
                                   
                                   NSMutableArray *result = (NSMutableArray*) [[DBManager getSharedInstance] getLastUnreadMessage:friend.chatroomID];
                                   
                                   if (result != nil && [result count] > 0) {
                                       NSMutableDictionary *temp = (NSMutableDictionary *) [result objectAtIndex:0];
                                       Message *message = [[Message alloc] init];
                                       message.image = friend.image;
                                       message.username = friend.name;
                                       int messageType = [[temp objectForKey:@"type"] intValue];
                                       switch (messageType) {
                                           case 1:
                                               message.message = @"[Emoji]";
                                               break;
                                           case 2:
                                               message.message = @"[Image]";
                                               break;
                                           case 3:
                                               message.message = @"[Location]";
                                               break;
                                           case 4:
                                               message.message = @"[Voice Message]]";
                                               break;
                                           case 0:
                                               message.message = [temp objectForKey:@"message"];
                                       }
                                       message.distance = friend.distance;
                                       
                                       message.messagetime = [[temp objectForKey:@"lastupdatetime"] intValue];
                                       message.lastupdatetime = friend.lastupdatetime;
                                       if (friend.gender == YES)
                                           message.gender = @"male";
                                       else
                                           message.gender = @"female";
                                       if (friend.status == YES)
                                           message.onlinestatus = 1;
                                       else
                                           message.onlinestatus = 0;
                                       
                                       message.messageNum = [[DBManager getSharedInstance] getLastUnreadMessageNum:friend.chatroomID];
                                       
                                       [messages addObject:message];
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
                                           if (isFirsttimeLoading == YES)
                                               [self showProgress:NO];
                                           
                                           if (self.pullToRefreshFlag == YES) {
                                               self.pullToRefreshFlag = NO;
                                               [self.messagesTableView.pullToRefreshView stopAnimating];
                                           }
                                           
                                           messages = (NSMutableArray*) [messages sortedArrayUsingSelector:@selector(sortByMessageTime:)];
                                           
                                           [self.messagesTableView reloadData];
                                           
                                           isFirsttimeLoading = NO;
                                           
                                           [appDelegate.tabBarController updateMessageNum:appDelegate.messageNum];
                                       }
                                   } else {
                                       [self checkChatRoom:loadIndex];
                                   }
                               }
                               
                           }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAddGroupClicked:(id)sender {
    if ([self.parentViewController isKindOfClass:[MHCustomTabBarController class]]) {
        appDelegate.fromIndex = 0;
        [((MHCustomTabBarController*) self.parentViewController) moveToStartGroupViewController];
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
    if (messages == nil)
        return 0;
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MessageTableViewCell";
    
    MessageTableViewCell *cell = (MessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //cell.parent = self;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = (int) indexPath.row;
    cell.parent = self;
    
    Message *message = (Message*) [messages objectAtIndex:indexPath.row];
    [cell setData:message];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath      *)indexPath;
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}

- (void) gotoFittab:(int) index {
    Message *message = (Message*) [messages objectAtIndex:index];
    Friend *friend;
    for (int i = 0; i < [appDelegate.friends count]; i++) {
        friend = (Friend*) [appDelegate.friends objectAtIndex:i];
        if ([friend.name isEqual:message.username]) {
            appDelegate.selectOtherUser = friend;
            appDelegate.fromIndex = 1;
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OtherProfileViewController *controller = (OtherProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"OtherProfileViewController"];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
    }
    
}

- (void) gotoChatroom:(int) index {
    Message *message = (Message*) [messages objectAtIndex:index];
    Friend *friend;
    for (int i = 0; i < [appDelegate.friends count]; i++) {
        friend = (Friend*) [appDelegate.friends objectAtIndex:i];
        if ([friend.name isEqual:message.username]) {
            appDelegate.fromIndex = 1;
            
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
    
    NSMutableDictionary *group;
    for (int i = 0; i < [appDelegate.groupChatIDs count]; i++) {
        group = (NSMutableDictionary*) [appDelegate.groupChatIDs objectAtIndex:i];
        if ([[group objectForKey:@"members" ] isEqual:message.username]) {
            appDelegate.fromIndex = 1;
            
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ChatViewController *controller = (ChatViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
            if ([[group objectForKey:@"owner"] intValue] == 1)
                controller.isPrivateChat = 2; // owner
            else
                controller.isPrivateChat = 3; // not owner
            controller.roomName = [group objectForKey:@"name"];
            controller.memberNames = message.username;
            controller.users = [[NSMutableArray alloc] init];
            controller.chatroomID = [group objectForKey:@"ID"];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
    }
}



- (void) deleteMessage:(int)index {
    Message *message = (Message*) [messages objectAtIndex:index];
    Friend *friend;
    for (int i = 0; i < [appDelegate.friends count]; i++) {
        friend = (Friend*) [appDelegate.friends objectAtIndex:i];
        if ([friend.name isEqual:message.username]) {
            appDelegate.fromIndex = 1;
            
            [[DBManager getSharedInstance] deleteMessages:friend.chatroomID];
            
            [self loadMessages];
            
            return;
        }
    }
}


@end

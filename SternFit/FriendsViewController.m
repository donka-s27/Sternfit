//
//  FriendsViewController.m
//  SternFit
//
//  Created by MacOS on 12/11/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "FriendsViewController.h"
#import "AppDelegate.h"
#import "FriendsTableViewCell.h"
#import "SVPullToRefresh.h"

@interface FriendsViewController () {
    AppDelegate *appDelegate;
    NSUserDefaults *defaults;
}

@end

@implementation FriendsViewController


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
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    CGRect frame = self.friendsTableView.frame;
    frame.size.height = iOSDeviceScreenSize.height - 115;
    self.friendsTableView.frame = frame;
    
    UITapGestureRecognizer *tapView8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sortViewTap:)];
    tapView8.delegate = self;
    [self.sortView addGestureRecognizer:tapView8];
    
    [self loadLabelForBottomMenu];
    self.pullToRefreshFlag = NO;
    
    self.labelPageTitle.font = [UIFont fontWithName:@"MyraidPro-Regular" size:17.0f];
}

- (void) viewWillAppear:(BOOL)animated {
    __weak typeof(self) weakSelf = self;
    [self.friendsTableView addPullToRefreshWithActionHandler:^{
        weakSelf.pullToRefreshFlag = YES;
        [weakSelf refreshFriends];
    }];
    [self refreshFriends];
    
    appDelegate.currentViewController = self;
}

- (void) loadLabelForBottomMenu {
    
    self.labelPageTitle.text = NSLocalizedString(@"Friends List", nil);
    self.labelGroupChat.text = NSLocalizedString(@"Group Chat", nil);
    self.txtSearch.text = NSLocalizedString(@"Search", nil);
    
    self.labelSort1.text = NSLocalizedString(@"Sort by", nil);
    self.labelSort2.text = NSLocalizedString(@"Sort by", nil);
    self.labelSortLocation.text = NSLocalizedString(@"LOCATION UPDATE TIME", nil);
    self.labelSortDistance.text = NSLocalizedString(@"DISTANCE", nil);
    self.labelSortAlpha.text = NSLocalizedString(@"ALPHABET", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSearchClicked:(id)sender {
    [self.txtSearch resignFirstResponder];
}
- (IBAction)btnGroupChatClicked:(id)sender {
    [self.txtSearch resignFirstResponder];
    if ([self.parentViewController isKindOfClass:[MHCustomTabBarController class]]) {
        
        appDelegate.fromIndex = 1;
        [((MHCustomTabBarController*) self.parentViewController) moveToStartGroupViewController];
    }
}

#pragma - mark TextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqual:NSLocalizedString(@"Search", nil)])
        textField.text = @"";
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqual:@""])
        textField.text = NSLocalizedString(@"Search", nil);
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.txtSearch resignFirstResponder];
    return YES;
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
    if (appDelegate.friends == nil)
        return 0;
    return [appDelegate.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FriendsTableViewCell";
    
    FriendsTableViewCell *cell = (FriendsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //cell.parent = self;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Friend *friend = (Friend*) [appDelegate.friends objectAtIndex:indexPath.row];
    cell.index = (int) indexPath.row;
    cell.parent = self;
    [cell setData:friend];
    
    return cell;
}

- (void)tapClick:(int) index
{
    appDelegate.selectOtherUser = (Friend*) [self->appDelegate.friends objectAtIndex:index];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherProfileViewController *controller = (OtherProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"OtherProfileViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath      *)indexPath;
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.txtSearch resignFirstResponder];
}

- (IBAction)btnSortMenuShowClicked:(id)sender {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //self.overlayView1.hidden = NO;
                         self.sortView.hidden = NO;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (IBAction)btnSortMenuHideClicked:(id)sender {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //self.overlayView1.hidden = YES;
                         self.sortView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (IBAction)btnSortByLocationClicked:(id)sender {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //self.overlayView1.hidden = YES;
                         self.sortView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         
                         appDelegate.friends = (NSMutableArray*) [appDelegate.friends sortedArrayUsingSelector:@selector(sortByLocationUpdateTime:)];
                         
                         [self.friendsTableView reloadData];
                     }];
}
- (IBAction)btnSortByDistanceClicked:(id)sender {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //self.overlayView1.hidden = YES;
                         self.sortView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         
                         appDelegate.friends = (NSMutableArray*) [appDelegate.friends sortedArrayUsingSelector:@selector(sortByDistance:)];
                         
                         [self.friendsTableView reloadData];
                     }];
}
- (IBAction)btnSortByAlphaClicked:(id)sender {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //self.overlayView1.hidden = YES;
                         self.sortView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         
                         appDelegate.friends = (NSMutableArray*) [appDelegate.friends sortedArrayUsingSelector:@selector(sortByAlpha:)];
                         
                         [self.friendsTableView reloadData];
                     }];
}

- (IBAction)sortViewTap:(UITapGestureRecognizer*)recognizer {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //self.overlayView1.hidden = YES;
                         self.sortView.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void) refreshFriends {
    
    appDelegate.friends = [[NSMutableArray alloc] init];
    if (self.pullToRefreshFlag == NO)
        [self showProgress:YES];
    
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
                                   
                                   
                                   if (self.pullToRefreshFlag == NO)
                                       [self showProgress:NO];
                                   [self.friendsTableView reloadData];
                                   
                                   if (self.pullToRefreshFlag == YES) {
                                       self.pullToRefreshFlag = NO;
                                       [self.friendsTableView.pullToRefreshView stopAnimating];
                                   }
                               }
                           }];
}

- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}



- (void)deleteFriendClick:(int) index {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Are you sure to remove from friend list?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] ;
    alertView.tag = index;
    [alertView show];
    
}

- (void)chatFriendClick:(int) index {
    Friend *friend = (Friend*) [appDelegate.friends objectAtIndex:index];
    appDelegate.fromIndex = 4;
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController *controller = (ChatViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    controller.isPrivateChat = 1;
    controller.users = [[NSMutableArray alloc] init];
    [controller.users addObject:friend];
    controller.chatroomID = friend.chatroomID;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)alertView:(UIAlertView *)localAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        Friend *friend = (Friend*) [appDelegate.friends objectAtIndex:(int) localAlertView.tag];
        
        
        [self showProgress:YES];
        
        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?uID=%@&fID=%d", SERVER_ADDRESS, DELETE_FRIEND, [defaults objectForKey:@"userID"], friend.userId]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
        
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
         
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   @try {
                                       [appDelegate.friends removeObjectAtIndex:(int) localAlertView.tag];
                                   }
                                   @catch (NSException *exception) {
                                       
                                   }
                                   @finally {
                                       [self showProgress:NO];
                                       [self.friendsTableView reloadData];
                                   }
                               }];
    }
    
}



@end

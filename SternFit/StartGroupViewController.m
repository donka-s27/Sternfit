//
//  StartGroupViewController.m
//  SternFit
//
//  Created by MacOS on 12/18/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "StartGroupViewController.h"
#import "StartGroupTableViewCell.h"
#import "DBManager.h"

@interface StartGroupViewController () {
    NSMutableArray *selectedIndexes;
    AppDelegate *appDelegate;
    NSMutableArray *tempFriends;
}

@end

@implementation StartGroupViewController

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
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    self.groupLabelTitle.font = [UIFont fontWithName:@"MyraidPro-Regular" size:17.0f];
    // Do any additional setup after loading the view.
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    CGRect frame = self.groupUsersTableView.frame;
    frame.size.height = iOSDeviceScreenSize.height - 155;
    self.groupUsersTableView.frame = frame;

    selectedIndexes = [[NSMutableArray alloc] init];
    
    [self loadLabelForBottomMenu];
    
    self.groupLabelTitle.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18.0f];
    
    tempFriends = appDelegate.friends;
}

- (void) viewWillAppear:(BOOL)animated {
    
    appDelegate.currentViewController = self;
}

- (void) loadLabelForBottomMenu {
    self.groupLabelTitle.text = NSLocalizedString(@"START GROUP CHAT", nil);
    [self.groupBtnCancel setTitle:NSLocalizedString(@"CANCEL", nil) forState:UIControlStateNormal];
    [self.groupBtnOK setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    self.groupTxtSearch.text = NSLocalizedString(@"Search", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSearchClicked:(id)sender {
    
}
- (IBAction)btnCancelClicked:(id)sender {
    if ([self.parentViewController isKindOfClass:[MHCustomTabBarController class]]) {
        [((MHCustomTabBarController*) self.parentViewController) moveFromStartGroupViewController];
    }
}
- (IBAction)btnOKClicked:(id)sender {
    if ([selectedIndexes count] <= 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Please select 2 friends at least to create group chat.", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] ;
        [alertView show];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    Friend *friend = (Friend*) [appDelegate.friends objectAtIndex:[[selectedIndexes objectAtIndex:0] intValue]];
    NSString *ids = [NSString stringWithFormat:@"%d", friend.userId];
    NSString *roomName = friend.name;
    for (int i = 1; i < [selectedIndexes count]; i++) {
        friend = (Friend*) [appDelegate.friends objectAtIndex:[[selectedIndexes objectAtIndex:i] intValue]];
        ids = [NSString stringWithFormat:@"%@;%d", ids, friend.userId];
        roomName = [NSString stringWithFormat:@"%@,%@", roomName, friend.name];
    }
    
    long lastupdatetime = [[NSDate date] timeIntervalSince1970];
    //lastupdatetime -= [[NSTimeZone localTimeZone] secondsFromGMT];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSString *date = [dateFormatter stringFromDate: [NSDate date]];
   
    [self showProgress:YES];
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?userID=%@&username=%@&ids=%@&time=%ld&names=%@", SERVER_ADDRESS, CREATE_GROUP_CHAT, [defaults objectForKey:@"userID"], [defaults objectForKey:@"name"], ids, lastupdatetime, @"Group"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               @try {
                                   if (data != nil) {
                                       NSMutableDictionary *result1 = (NSMutableDictionary*) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       
                                       if (result1 != nil) {
                                           NSString *chatroomID = [result1 objectForKey:@"chatroomID"];
                                           [[DBManager getSharedInstance] addMessage:chatroomID senderID:[defaults objectForKey:@"userID"] message:[NSString stringWithFormat:@"You invited %@ to join the group.", roomName] type:@"100" lastupdatetime:[NSString stringWithFormat:@"%ld", lastupdatetime] created_at:date updated_at:date status:@"1"];
                                           
                                           appDelegate.fromIndex = 1;
                                           
                                           UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                           ChatViewController *controller = (ChatViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
                                           controller.isPrivateChat = 2;
                                           controller.roomName = [NSString stringWithFormat:@"Group(%d)", (int)[selectedIndexes count] + 1];
                                           controller.memberNames = roomName;
                                           controller.users = [[NSMutableArray alloc] init];
                                           controller.chatroomID = chatroomID;
                                           [self.navigationController pushViewController:controller animated:YES];
                                       }
                                   }
                                   
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   [self showProgress:NO];
                               }
                               
                           }];
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
    [self.groupTxtSearch resignFirstResponder];
    return YES;
}

- (void) searchUsers:(NSString *) search {
    if ([search isEqual:@""]) {
        self->appDelegate.friends = tempFriends;
    } else {
        self->appDelegate.friends = [[NSMutableArray alloc] init];
        for (int i = 0; i < [tempFriends count]; i++) {
            Friend *friend = (Friend*) [tempFriends objectAtIndex:i];
            if ([[friend.name lowercaseString] rangeOfString:[search lowercaseString]].location != NSNotFound) {
                [self->appDelegate.friends addObject:friend];
            }
        }
    }
    [self.groupUsersTableView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {  // return NO to not change text
    NSString *search = self.groupTxtSearch.text;
    
    if ([string isEqual:@"\n"]) {
        [self.groupTxtSearch resignFirstResponder];
        return NO;
    } else if ([string isEqual:@""]) {
        if ([search length] >= 1) {
            search = [search substringToIndex:([search length] - 1)];
        }
    } else {
        search = [NSString stringWithFormat:@"%@%@", search, string];
    }
    
    [self searchUsers:search];
    
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
    return [appDelegate.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    static NSString *simpleTableIdentifier = @"StartGroupTableViewCell";
    
    StartGroupTableViewCell *cell = (StartGroupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //cell.parent = self;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StartGroupTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Friend *user = (Friend*) [appDelegate.friends objectAtIndex:indexPath.row];
    if ([user.image isEqual:@""]) {
        [cell.imgAvator setImage:[UIImage imageNamed:@"avator.png"]];
    } else {
        [cell.imgAvator setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [cell.imgAvator setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, user.image]]];
    }
    UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    cell.imgAvator.layer.borderColor = borderColor.CGColor;
    cell.imgAvator.layer.borderWidth = 3.0f;
    cell.imgAvator.layer.cornerRadius = 30.0f;
    cell.imgAvator.layer.masksToBounds = YES;
    if (user.gender == YES) {
        UIColor *borderColor1 = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
        cell.imgAvator.layer.borderColor = borderColor1.CGColor;
    } else {
        UIColor *borderColor1 = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:90.0f/255.0f alpha:1];
        cell.imgAvator.layer.borderColor = borderColor1.CGColor;
    }
    
    cell.labelStatus.layer.borderColor = borderColor.CGColor;
    cell.labelStatus.layer.borderWidth = 2.0f;
    cell.labelStatus.layer.cornerRadius = 7.5f;
    if (user.status == NO) {
        cell.labelStatus.backgroundColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
    } else {
        cell.labelStatus.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:227.0f/255.0f blue:54.0f/255.0f alpha:1];
    }
    
    cell.labelUsername.text = user.name;
    cell.labelMessage.text = user.message;
    double distance = user.distance;
    if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
        distance = distance / 1610;
        cell.labelDistance.text = [NSString stringWithFormat:@"%.1f mi", distance];
    } else {
        distance = distance / 1000;
        cell.labelDistance.text = [NSString stringWithFormat:@"%.1f km", distance];
    }
    
    int mins = user.lastupdatetime;
    if (mins / 60 == 0)
        cell.labelTimer.text = [NSString stringWithFormat:@"%dmins ago", mins, NSLocalizedString(@"ago", nil)];
    else if (mins / 60 < 24)
        cell.labelTimer.text = [NSString stringWithFormat:@"%dh %dm ago", mins / 60, mins % 60, NSLocalizedString(@"ago", nil)];
    else {
        cell.labelTimer.text = [NSString stringWithFormat:@"%d %@ %@", (mins / 60 / 24) + 1, NSLocalizedString(@"days", nil), NSLocalizedString(@"ago", nil)];
    }
    
    [cell.imgCheck setImage:[UIImage imageNamed:@"group_unchecked.png"]];
    for (int i = 0; i < [selectedIndexes count]; i++) {
        int index = [[selectedIndexes objectAtIndex:i] intValue];
        if (index == indexPath.row) {
            [cell.imgCheck setImage:[UIImage imageNamed:@"group_checked.png"]];
            break;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath      *)indexPath;
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.groupTxtSearch resignFirstResponder];
    StartGroupTableViewCell *cell = (StartGroupTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    for (int i = 0; i < [selectedIndexes count]; i++) {
        int index = [[selectedIndexes objectAtIndex:i] intValue];
        if (index == indexPath.row) {
            [cell.imgCheck setImage:[UIImage imageNamed:@"group_unchecked.png"]];
            [selectedIndexes removeObjectAtIndex:i];
            return;
        }
    }
    [cell.imgCheck setImage:[UIImage imageNamed:@"group_checked.png"]];
    [selectedIndexes addObject:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
}

- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}

@end

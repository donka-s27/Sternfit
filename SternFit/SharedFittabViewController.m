//
//  FriendsViewController.m
//  SternFit
//
//  Created by MacOS on 12/11/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "SharedFittabViewController.h"
#import "AppDelegate.h"
#import "SharedFittabTableViewCell.h"

@interface SharedFittabViewController () {
    AppDelegate *appDelegate;
    NSUserDefaults *defaults;
}

@end

@implementation SharedFittabViewController


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
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.labelPageTitle.font = [UIFont fontWithName:@"MyraidPro-Regular" size:17.0f];
    // Do any additional setup after loading the view.
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    CGRect frame = self.friendsTableView.frame;
    frame.size.height = iOSDeviceScreenSize.height - 115;
    self.friendsTableView.frame = frame;
    
    UITapGestureRecognizer *tapView8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sortViewTap:)];
    tapView8.delegate = self;
    [self.sortView addGestureRecognizer:tapView8];
    
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    [self loadLabelForBottomMenu];
}

- (void) viewWillAppear:(BOOL)animated {
    appDelegate.currentViewController = self;
    
    [self refreshFriends];
}

- (void) loadLabelForBottomMenu {
    
    self.labelPageTitle.text = NSLocalizedString(@"Shared Fit-Tab", nil);

    self.labelSortLocation.text = NSLocalizedString(@"LOCATION UPDATE TIME", nil);
    self.labelSortDistance.text = NSLocalizedString(@"DISTANCE", nil);
    self.labelSortAlpha.text = NSLocalizedString(@"ALPHABET", nil);
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
    
    return [appDelegate.sharedFittabUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *simpleTableIdentifier = @"SharedFittabTableViewCell";
    
    SharedFittabTableViewCell *cell = (SharedFittabTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //cell.parent = self;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SharedFittabTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Friend *friend = (Friend*) [appDelegate.sharedFittabUsers objectAtIndex:indexPath.row];
    if ([friend.image isEqual:@""]) {
        [cell.imgAvator setImage:[UIImage imageNamed:@"avator.png"]];
    } else {
        [cell.imgAvator setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [cell.imgAvator setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, friend.image]]];
    }
    UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    cell.imgAvator.layer.borderColor = borderColor.CGColor;
    cell.imgAvator.layer.borderWidth = 3.0f;
    cell.imgAvator.layer.cornerRadius = 30.0f;
    cell.imgAvator.layer.masksToBounds = YES;
    if (friend.gender == YES) {
        UIColor *borderColor1 = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
        cell.imgAvator.layer.borderColor = borderColor1.CGColor;
    } else {
        UIColor *borderColor1 = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:90.0f/255.0f alpha:1];
        cell.imgAvator.layer.borderColor = borderColor1.CGColor;
    }
    
    cell.labelStatus.layer.borderColor = borderColor.CGColor;
    cell.labelStatus.layer.borderWidth = 2.0f;
    cell.labelStatus.layer.cornerRadius = 7.5f;
    if (friend.status == NO) {
        cell.labelStatus.backgroundColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
    } else {
        cell.labelStatus.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:227.0f/255.0f blue:54.0f/255.0f alpha:1];
    }
    
    cell.labelUsername.text = [NSString stringWithFormat:@"%@'s Fit-Tab", friend.name];
    cell.labelTimer.text = [NSString stringWithFormat:@"%@/%@/%@", [friend.updatedAt substringWithRange:NSMakeRange(5, 2)], [friend.updatedAt substringWithRange:NSMakeRange(8, 2)], [friend.updatedAt substringToIndex:4]];
    
    UITapGestureRecognizer *btntap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnhandlegesture:)];
    cell.btnTap.tag = indexPath.row;
    [cell.btnTap addGestureRecognizer:btntap];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    [cell addGestureRecognizer:swiperight];

    UITapGestureRecognizer *btntap31 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnDeleteClicked:)];
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addGestureRecognizer:btntap31];
    
    return cell;
}

- (void)btnhandlegesture:(UITapGestureRecognizer*)recognizer
{
    CGRect frame = recognizer.view.superview.superview.frame;
    if (frame.origin.x == -50) {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = recognizer.view.superview.superview.frame;
                             frame.origin.x = 0;
                             recognizer.view.superview.superview.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        return;
    }
    
    appDelegate.selectOtherUser = (Friend*) [appDelegate.sharedFittabUsers objectAtIndex:recognizer.view.tag];
    /*appDelegate.tabIndex = 2;
    if ([self.parentViewController isKindOfClass:[MHCustomTabBarController class]]) {
        [((MHCustomTabBarController*) self.parentViewController) moveToFittab];
    }*/
    appDelegate.fromIndex = 13;
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherProfileViewController *controller = (OtherProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"OtherProfileViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath      *)indexPath;
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)swipeleft:(UISwipeGestureRecognizer*)recognizer {
    
    CGRect frame = recognizer.view.frame;
    if (frame.origin.x == 0) {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = recognizer.view.frame;
                             recognizer.view.frame = CGRectMake(-50, frame.origin.y, frame.size.width +50, frame.size.height);
                         }
         
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)swiperight:(UISwipeGestureRecognizer*)recognizer {
    CGRect frame = recognizer.view.frame;
    if (frame.origin.x == -45) {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = recognizer.view.frame;
                             frame.origin.x = 0;
                             recognizer.view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
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
                         
                         appDelegate.sharedFittabUsers = (NSMutableArray*) [appDelegate.sharedFittabUsers sortedArrayUsingSelector:@selector(sortByLocationUpdateTime:)];
                         
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
                         
                         appDelegate.sharedFittabUsers = (NSMutableArray*) [appDelegate.sharedFittabUsers sortedArrayUsingSelector:@selector(sortByDistance:)];
                         
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
                         
                         appDelegate.sharedFittabUsers = (NSMutableArray*) [appDelegate.sharedFittabUsers sortedArrayUsingSelector:@selector(sortByAlpha:)];
                         
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

- (void)btnDeleteClicked:(UITapGestureRecognizer*)recognizer {
    
    Friend *temp = (Friend*) [appDelegate.sharedFittabUsers objectAtIndex:recognizer.view.tag];
    
    [self showProgress:YES];
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?ID=%@", SERVER_ADDRESS, DELETE_SHARED_FITTAB, temp.shareID]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               @try {
                                   
                                   [appDelegate.sharedFittabUsers removeObjectAtIndex:recognizer.view.tag];
                                   
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   [self showProgress:NO];
                                   [self.friendsTableView reloadData];
                               }
                               
                           }];
    
}

- (void) refreshFriends {
    
    appDelegate.sharedFittabUsers = [[NSMutableArray alloc] init];
    [self showProgress:YES];
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?ID=%@&lat=%f&lon=%f", SERVER_ADDRESS, SHARED_FITTAB_USERS, [defaults objectForKey:@"userID"], appDelegate.currentLocation.coordinate.latitude, appDelegate.currentLocation.coordinate.longitude]];
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
                                               //user.lastupdatetime = (int)([[temp objectForKey:@"lastupdatetime"] intValue] / 60);
                                               user.updatedAt = [[temp objectForKey:@"updated_at"] substringToIndex:10];
                                               user.shareID = [temp objectForKey:@"shareID"];
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
                                               
                                               [appDelegate.sharedFittabUsers addObject:user];
                                           }
                                       }
                                   }
                                   
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   [self showProgress:NO];
                                   [self.friendsTableView reloadData];
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


@end

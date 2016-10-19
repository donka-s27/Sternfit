//
//  SideMenuViewController.m
//  SternFit
//
//  Created by MacOS on 12/10/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "SideMenuViewController.h"
#import "AppDelegate.h"
#import "SideMenuTableViewCell.h"

@interface SideMenuViewController () {
    NSMutableArray *menus;
    NSMutableArray *imgNames;
    
    AppDelegate *appDelegate;
    NSUserDefaults *defaults;
}

@end

@implementation SideMenuViewController

@synthesize imgAvator, menuTableView, labelSubtitle, labelTitle, parentViewController;

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
    
    menus = [[NSMutableArray alloc] init];
    [menus addObject:NSLocalizedString(@"Friends", nil)];
    [menus addObject:NSLocalizedString(@"Shared Fit-Tab", nil)];
    [menus addObject:NSLocalizedString(@"Training Plan", nil)];
    [menus addObject:NSLocalizedString(@"Diet Plan", nil)];
    [menus addObject:NSLocalizedString(@"Supplement Plan", nil)];
    [menus addObject:NSLocalizedString(@"Settings", nil)];
    [menus addObject:NSLocalizedString(@"Logout", nil)];
    
    imgNames = [[NSMutableArray alloc] init];
    [imgNames addObject:@"side_menu_friend"];
    [imgNames addObject:@"side_menu_trainingplan"];
    [imgNames addObject:@"side_menu_trainingplan"];
    [imgNames addObject:@"side_menu_trainingplan"];
    [imgNames addObject:@"side_menu_trainingplan"];
    [imgNames addObject:@"side_menu_settings"];
    [imgNames addObject:@"side_menu_logout"];
}

- (void) viewWillAppear:(BOOL)animated {
    UIColor *borderColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
    self.imgAvator.layer.borderColor = borderColor.CGColor;
    self.imgAvator.layer.borderWidth = 3.0f;
    self.imgAvator.layer.cornerRadius = 50.0f;
    self.imgAvator.layer.masksToBounds = YES;
    
    
    
    self.labelTitle.text = [defaults objectForKey:@"name"];
    self.labelSubtitle.text = [defaults objectForKey:@"quote"];
    if ([[defaults objectForKey:@"gender"] isEqual:@"female"]) {
        borderColor = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:90.0f/255.0f alpha:1];
        self.imgAvator.layer.borderColor = borderColor.CGColor;
    }
    self.labelSubtitle.hidden = YES;
    
    if ([defaults objectForKey:@"profile"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"profile.jpg"];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
        [self.imgAvator setImage:image];
    }
    
    borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    self.labelStatus.layer.borderColor = borderColor.CGColor;
    self.labelStatus.layer.borderWidth = 2.0f;
    self.labelStatus.layer.cornerRadius = 7.5f;
    if ([[defaults objectForKey:@"visibleMode"] intValue] == 2) {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
    } else {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:227.0f/255.0f blue:54.0f/255.0f alpha:1];
    }
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
    return [menus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SideMenuTableViewCell";
    
    SideMenuTableViewCell *cell = (SideMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //cell.parent = self;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SideMenuTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.labelName.text = [menus objectAtIndex:indexPath.row];
    cell.labelName.textColor = [UIColor colorWithRed:137.0f/255.0f green:137.0f/255.0f blue:137.0f/255.0f alpha:1.0f];
    
    [cell.imgIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_deselect.png", [imgNames objectAtIndex:indexPath.row]]]];
    
    cell.highlightView.backgroundColor = [UIColor clearColor];
    
    
    if (appDelegate.tabIndex == 4 && indexPath.row == 0) {
        cell.labelName.textColor = [UIColor colorWithRed:214.0f/255.0f green:79.0f/255.0f blue:78.0f/255.0f alpha:1.0f];
        [cell.imgIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_select.png", [imgNames objectAtIndex:indexPath.row]]]];
        cell.highlightView.backgroundColor = [UIColor colorWithRed:214.0f/255.0f green:79.0f/255.0f blue:78.0f/255.0f alpha:1.0f];
    }
    else if (appDelegate.tabIndex != 7 && appDelegate.tabIndex != 3 && appDelegate.tabIndex - 3 == indexPath.row && appDelegate.tabIndex != 4) {
        cell.labelName.textColor = [UIColor colorWithRed:214.0f/255.0f green:79.0f/255.0f blue:78.0f/255.0f alpha:1.0f];
        [cell.imgIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_select.png", [imgNames objectAtIndex:indexPath.row]]]];
        cell.highlightView.backgroundColor = [UIColor colorWithRed:214.0f/255.0f green:79.0f/255.0f blue:78.0f/255.0f alpha:1.0f];
    }
    if (appDelegate.tabIndex == 13 && indexPath.row == 1) {
        cell.labelName.textColor = [UIColor colorWithRed:214.0f/255.0f green:79.0f/255.0f blue:78.0f/255.0f alpha:1.0f];
        [cell.imgIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_select.png", [imgNames objectAtIndex:indexPath.row]]]];
        cell.highlightView.backgroundColor = [UIColor colorWithRed:214.0f/255.0f green:79.0f/255.0f blue:78.0f/255.0f alpha:1.0f];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath;{
    return 36;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Are you sure to log out?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] ;
        [alertView show];
        return;
    }
    
    for (int i = 0; i < [menus count]; i++) {
        NSIndexPath *currentPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        SideMenuTableViewCell *cell = (SideMenuTableViewCell*) [tableView cellForRowAtIndexPath:currentPath];
        if (indexPath.row == i) {
            cell.labelName.textColor = [UIColor colorWithRed:214.0f/255.0f green:79.0f/255.0f blue:78.0f/255.0f alpha:1.0f];
            [cell.imgIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_select.png", [imgNames objectAtIndex:i]]]];
            cell.highlightView.backgroundColor = [UIColor colorWithRed:214.0f/255.0f green:79.0f/255.0f blue:78.0f/255.0f alpha:1.0f];
            if (i == 3) {
                appDelegate.tabIndex = 15;
            } else if (i == 4) {
                appDelegate.tabIndex = 16;
            } else if (i == 0)
                appDelegate.tabIndex = 4;
            else if (i == 1)
                appDelegate.tabIndex = 13;
            else if (i == 2)
                appDelegate.tabIndex = 5;
            else if (i == 5)
                appDelegate.tabIndex = 6;
        } else {
            cell.labelName.textColor = [UIColor colorWithRed:137.0f/255.0f green:137.0f/255.0f blue:137.0f/255.0f alpha:1.0f];
            [cell.imgIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_deselect.png", [imgNames objectAtIndex:i]]]];
            cell.highlightView.backgroundColor = [UIColor clearColor];
        }
    }
    
    if ([self.parentViewController isKindOfClass:[MHCustomTabBarController class]]) {
        [((MHCustomTabBarController*) self.parentViewController) hideSideMenu];
    }
}

- (void)alertView:(UIAlertView *)localAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        appDelegate.tabIndex = 7;
        
        if ([self.parentViewController isKindOfClass:[MHCustomTabBarController class]]) {
            [((MHCustomTabBarController*) self.parentViewController) hideSideMenu];
        }
    }
}

- (IBAction)btnProfileClicked:(id)sender {
    [((MHCustomTabBarController*) self.parentViewController) hideSideMenu];
    
    
    Friend *friend = [[Friend alloc] init];
    friend.image = [NSString stringWithFormat:@"%@_%@", [defaults objectForKey:@"name"], [defaults objectForKey:@"profile"]];
    friend.photo1 = [NSString stringWithFormat:@"%@_%@", [defaults objectForKey:@"name"], [defaults objectForKey:@"photo1"]];
    friend.photo2 = [NSString stringWithFormat:@"%@_%@", [defaults objectForKey:@"name"], [defaults objectForKey:@"photo2"]];
    friend.photo3 = [NSString stringWithFormat:@"%@_%@", [defaults objectForKey:@"name"], [defaults objectForKey:@"photo3"]];
    friend.photo4 = [NSString stringWithFormat:@"%@_%@", [defaults objectForKey:@"name"], [defaults objectForKey:@"photo4"]];
    friend.photo5 = [NSString stringWithFormat:@"%@_%@", [defaults objectForKey:@"name"], [defaults objectForKey:@"photo5"]];
    friend.userId = [[defaults objectForKey:@"userID"] intValue];
    friend.name = [defaults objectForKey:@"name"];
    friend.message = [defaults objectForKey:@"quote"];
    if ([[defaults objectForKey:@"visibleMode"] intValue] == 2)
        friend.status = 0;
    else
        friend.status = 1;
   // friend.chatroomID = [defaults objectForKey:@"chatroomID"];
    //friend.lastupdatetime = (int)([[defaults objectForKey:@"lastupdatetime"] intValue] / 60);
    if ([[defaults objectForKey:@"gender"] isEqual:@"male"])
        friend.gender = YES;
    else
        friend.gender = NO;
    
    
    friend.age = [[defaults objectForKey:@"age"] intValue];
    
    friend.height = [[defaults objectForKey:@"height"] intValue];
    friend.weight = [[defaults objectForKey:@"weight"] intValue];
    
    
    appDelegate.selectOtherUser = friend;
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherProfileViewController *controller = (OtherProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"OtherProfileViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

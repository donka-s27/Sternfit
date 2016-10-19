//
//  TrainingViewController.m
//  SternFit
//
//  Created by MacOS on 12/11/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "TrainingViewController.h"
#import "AppDelegate.h"
#import "TrainingPlanTableViewCell.h"
#import "TrainingPlan.h"
#import "DetailViewController.h"

@interface TrainingViewController () {
    int selectedWeekday;
    NSMutableArray *planImgs;
    BOOL isEditMode;
    int editableIndex;
    int expandIndex;
    NSUserDefaults *defaults;
    AppDelegate *appDelegate;
}

@end

@implementation TrainingViewController

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
    
    selectedWeekday = 0;
    defaults = [NSUserDefaults standardUserDefaults];
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    // Do any additional setup after loading the view.
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    CGRect frame = self.planView.frame;
    frame.size.height = iOSDeviceScreenSize.height - 153;
    self.planView.frame = frame;
    
    frame = self.planTableView.frame;
    frame.size.height = iOSDeviceScreenSize.height - 183;
    self.planTableView.frame = frame;
    
    frame = self.btnSave.frame;
    frame.origin.y = iOSDeviceScreenSize.height - 80;
    self.btnSave.frame = frame;
    
    frame = self.btnShare.frame;
    frame.origin.y = iOSDeviceScreenSize.height - 80;
    self.btnShare.frame = frame;
    
    planImgs = [[NSMutableArray alloc] init];
    [planImgs addObject:[UIImage imageNamed:@"profile_running.png"]];
    [planImgs addObject:[UIImage imageNamed:@"profile_weight.png"]];
    [planImgs addObject:[UIImage imageNamed:@"profile_walking.png"]];
    [planImgs addObject:[UIImage imageNamed:@"profile_other.png"]];
    
    UITapGestureRecognizer *tapView1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weekdayLabelTap:)];
    tapView1.delegate = self;
    [self.labelWeekday1 addGestureRecognizer:tapView1];
    
    UITapGestureRecognizer *tapView2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weekdayLabelTap:)];
    tapView2.delegate = self;
    [self.labelWeekday2 addGestureRecognizer:tapView2];
    
    UITapGestureRecognizer *tapView3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weekdayLabelTap:)];
    tapView3.delegate = self;
    [self.labelWeekday3 addGestureRecognizer:tapView3];
    
    UITapGestureRecognizer *tapView4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weekdayLabelTap:)];
    tapView4.delegate = self;
    [self.labelWeekday4 addGestureRecognizer:tapView4];
    
    UITapGestureRecognizer *tapView5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weekdayLabelTap:)];
    tapView5.delegate = self;
    [self.labelWeekday5 addGestureRecognizer:tapView5];
    
    UITapGestureRecognizer *tapView6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weekdayLabelTap:)];
    tapView6.delegate = self;
    [self.labelWeekday6 addGestureRecognizer:tapView6];
    
    UITapGestureRecognizer *tapView7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weekdayLabelTap:)];
    tapView7.delegate = self;
    [self.labelWeekday7 addGestureRecognizer:tapView7];
    
    isEditMode = NO;
    
    self.labelPageTitle.font = [UIFont fontWithName:@"MyraidPro-Regular" size:17.0f];
}

- (void) viewWillAppear:(BOOL)animated {
    self.overlayView1.hidden = YES;
    self.shareView.hidden = YES;
    [self loadLabelForBottomMenu];
    [self highlightWeekday];
    
    editableIndex = -1;
    expandIndex = -1;
    
    
    appDelegate.currentViewController = self;
    [self.planTableView reloadData];
    self.btnShare.hidden = YES;
    
    if (isEditMode == YES)
    {
        self.btnShare.hidden = NO;
    }
}

- (void) loadLabelForBottomMenu {
    self.labelPageTitle.text = NSLocalizedString(@"Training plan", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)weekdayLabelTap:(UITapGestureRecognizer*)recognizer {
    if (recognizer.view == self.labelWeekday1) {
        selectedWeekday = 0;
    } else if (recognizer.view == self.labelWeekday2) {
        selectedWeekday = 1;
    } else if (recognizer.view == self.labelWeekday3) {
        selectedWeekday = 2;
    } else if (recognizer.view == self.labelWeekday4) {
        selectedWeekday = 3;
    } else if (recognizer.view == self.labelWeekday5) {
        selectedWeekday = 4;
    } else if (recognizer.view == self.labelWeekday6) {
        selectedWeekday = 5;
    } else if (recognizer.view == self.labelWeekday7) {
        selectedWeekday = 6;
    }
    
    expandIndex = -1;
    
    
    [defaults setObject:[NSString stringWithFormat:@"%d", selectedWeekday] forKey:@"weekday"];
    [defaults synchronize];
    
    [self highlightWeekday];
    [self.planTableView reloadData];
}

- (void) highlightWeekday {
    self.labelWeekdayHighlight1.hidden = YES;
    self.labelWeekdayHighlight2.hidden = YES;
    self.labelWeekdayHighlight3.hidden = YES;
    self.labelWeekdayHighlight4.hidden = YES;
    self.labelWeekdayHighlight5.hidden = YES;
    self.labelWeekdayHighlight6.hidden = YES;
    self.labelWeekdayHighlight7.hidden = YES;
    
    switch (selectedWeekday) {
        case 0:
            self.labelWeekdayHighlight1.hidden = NO;
            break;
        case 1:
            self.labelWeekdayHighlight2.hidden = NO;
            break;
        case 2:
            self.labelWeekdayHighlight3.hidden = NO;
            break;
        case 3:
            self.labelWeekdayHighlight4.hidden = NO;
            break;
        case 4:
            self.labelWeekdayHighlight5.hidden = NO;
            break;
        case 5:
            self.labelWeekdayHighlight6.hidden = NO;
            break;
        case 6:
            self.labelWeekdayHighlight7.hidden = NO;
            break;
    }
}

- (IBAction)btnAddPlanClicked:(id)sender {
    
    [defaults setObject:[NSString stringWithFormat:@"%d", selectedWeekday] forKey:@"weekday"];
    [defaults synchronize];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoryViewController *controller = (CategoryViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CategoryViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnBackClicked:(id)sender {
    if (isEditMode == NO)
        [self.navigationController popViewControllerAnimated:YES];
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Do you want to save changes?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] ;
        alertView.tag = 10001;
        [alertView show];
    }
}

- (IBAction)btnSaveClicked:(id)sender {
    
}

- (IBAction)btnShareClicked:(id)sender {
    if (isEditMode == NO) {
        self.overlayView1.alpha = 0.0f;
        self.shareView.alpha = 0.0f;
        
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SharePopupViewController *controller = (SharePopupViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SharePopupViewController"];
        controller.parentViewController = self;
        controller.tabBarController = appDelegate.tabBarController;
        controller.otherProfileController = nil;
        
        
        controller.content = NSLocalizedString(@"I just shared my Fit-Tab on SternFit, check it out: ", nil);
        
        [self.shareView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        [self addChildViewController:controller];
        
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.shareView.hidden = NO;
                             self.overlayView1.hidden = NO;
                             self.overlayView1.alpha = 0.7f;
                             self.shareView.alpha = 1.0f;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Do you want to save changes?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] ;
        alertView.tag = 10000;
        [alertView show];
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
    if (appDelegate.plans == nil || [appDelegate.plans count] == 0)
        return 0;
    if ([appDelegate.plans objectAtIndex:selectedWeekday] == nil)
        return 0;
    return [(NSMutableArray*)[appDelegate.plans objectAtIndex:selectedWeekday] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TrainingPlanTableViewCell";
    
    TrainingPlanTableViewCell *cell = (TrainingPlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //cell.parent = self;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TrainingPlanTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSMutableArray *weekday = (NSMutableArray*) [appDelegate.plans objectAtIndex:selectedWeekday];
    cell.controller = self;
    cell.index = (int) indexPath.row;
    [cell setData:weekday];
    
    UITapGestureRecognizer *btntap21 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipeback:)];
    cell.btnTap.tag = indexPath.row;
    cell.btnTap.hidden = YES;
    [cell.btnTap addGestureRecognizer:btntap21];
    
    UITapGestureRecognizer *btntap41 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnViewTrainingPlanClicked:)];
    cell.btnTap1.tag = indexPath.row;
    [cell.btnTap1 addGestureRecognizer:btntap41];
    
    UITapGestureRecognizer *btntap31 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnDeleteTrainingPlanClicked:)];
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addGestureRecognizer:btntap31];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
    cell.tag = (int) indexPath.row;
    [cell addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    [cell addGestureRecognizer:swiperight];

    
     if (editableIndex == (int) indexPath.row) {
         cell.btnTap.hidden = NO;
         [UIView animateWithDuration:0.5f
                               delay:0.0f
                             options:UIViewAnimationOptionCurveEaseIn
                          animations:^{
                              
                          }
          
                          completion:^(BOOL finished) {
                              CGRect frame = cell.frame;
                              cell.frame = CGRectMake(-100, frame.origin.y, frame.size.width +100, frame.size.height);
                          }];
     }
     
     if (expandIndex == indexPath.row) {
         cell.imgSeperate.hidden = YES;
         cell.imgSeperate1.hidden = NO;
         cell.labelDetail2.hidden = YES;
         cell.labelDetail3.hidden = NO;
         
         CGRect frame = cell.labelDetail1.frame;
         frame.origin.y = 50;
         cell.labelDetail1.frame = frame;
         
         frame = cell.imgIcon.frame;
         frame.origin.y = 56;
         cell.imgIcon.frame = frame;
         
         frame = cell.labelTitle.frame;
         frame.origin.y = 50;
         cell.labelTitle.frame = frame;
     }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath      *)indexPath;
{
    if (expandIndex == indexPath.row)
        return 162;
    else
        return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)btnFacebookClicked:(id)sender {
    
}
- (IBAction)btnTwitterClicked:(id)sender {
    
}

- (void) hideShareView {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.overlayView1.alpha = 0.0f;
                         self.shareView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.shareView.hidden = YES;
                         self.overlayView1.hidden = YES;
                     }];
}

- (void)swipeleft:(UISwipeGestureRecognizer*)recognizer {
    if (isEditMode == YES) {
        CGRect frame = recognizer.view.frame;
        //[self.planTableView reloadData];
        if (frame.origin.x == 0) {
            //((TrainingPlanTableViewCell*)recognizer.view).btnTap.hidden = NO;
            editableIndex = (int)recognizer.view.tag;
            [self.planTableView setEditing:YES animated:NO];
            [self.planTableView reloadData];
        }

    }
}

- (void)swiperight:(UISwipeGestureRecognizer*)recognizer {
    if (isEditMode == YES) {
        CGRect frame = recognizer.view.frame;
        if (frame.origin.x == -100) {
            //((TrainingPlanTableViewCell*)recognizer.view).btnTap.hidden = YES;
            editableIndex = -1;
            [self.planTableView setEditing:NO animated:NO];
            [self.planTableView reloadData];
        }
    }
}

- (void)btnDeleteTrainingPlanClicked:(UITapGestureRecognizer*)recognizer {
    if (isEditMode == YES) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Are you sure to delete training plan?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] ;
        alertView.tag = recognizer.view.tag;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)localAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ((int)localAlertView.tag == 10000) {
        editableIndex = -1;
        if (buttonIndex == 1) {
            [self showProgress:YES];
            
            NSString *ids = @"0:0";
            NSMutableArray *weekday;
            TrainingPlan *plan;
            for (int i = 0; i < 7; i++) {
                weekday = (NSMutableArray*) [appDelegate.plans objectAtIndex:i];
                for (int j = 0; j < [weekday count]; j++) {
                    plan = (TrainingPlan*) [weekday objectAtIndex:j];
                    ids = [NSString stringWithFormat:@"%@;%@:%d", ids, plan.ID, j];
                }
            }
            
            NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?ID=%@&confirm=1&Ids=%@", SERVER_ADDRESS, DELETE_TRAININGPLAN, [defaults objectForKey:@"userID"], ids]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
            
            [request setHTTPMethod:@"POST"];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
             
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       [self showProgress:NO];
                                       isEditMode = NO;
                                       [self.imgEditMode setImage:[UIImage imageNamed:@"trainingplan_edit1.png"]];
                                       self.btnShare.hidden = YES;
                                   }];
            
            return;
        } else {
            
            //appDelegate.plans = appDelegate.editPlans;
            //[self copyArray:appDelegate.editPlans destination:appDelegate.plans];
            appDelegate.plans = [self copyArray:appDelegate.editPlans];
            [self.planTableView reloadData];
            
            [self showProgress:YES];
            
 
            NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?ID=%@&confirm=2", SERVER_ADDRESS, DELETE_TRAININGPLAN, [defaults objectForKey:@"userID"]]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
            
            [request setHTTPMethod:@"POST"];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
             
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       [self showProgress:NO];
                                   }];
        }
        isEditMode = NO;
        [self.imgEditMode setImage:[UIImage imageNamed:@"trainingplan_edit1.png"]];
        //[self.btnShare setBackgroundImage:[UIImage imageNamed:@"trainingplan_share.png"] forState:UIControlStateNormal];
        self.btnShare.hidden = YES;
    } else if ((int)localAlertView.tag == 10001) {
        editableIndex = -1;
        if (buttonIndex == 0) {
            [self showProgress:YES];
            
            
            //appDelegate.plans = appDelegate.editPlans;
            //[self copyArray:appDelegate.editPlans destination:appDelegate.plans];
            appDelegate.plans = [self copyArray:appDelegate.editPlans];
            
            NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?ID=%@&confirm=2", SERVER_ADDRESS, DELETE_TRAININGPLAN, [defaults objectForKey:@"userID"]]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
            
            [request setHTTPMethod:@"POST"];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
             
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       [self showProgress:NO];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
        } else {
            [self showProgress:YES];
            
            NSString *ids = @"0:0";
            NSMutableArray *weekday;
            TrainingPlan *plan;
            for (int i = 0; i < 7; i++) {
                weekday = (NSMutableArray*) [appDelegate.plans objectAtIndex:i];
                for (int j = 0; j < [weekday count]; j++) {
                    plan = (TrainingPlan*) [weekday objectAtIndex:j];
                    ids = [NSString stringWithFormat:@"%@;%@:%d", ids, plan.ID, j];
                }
            }
            
            NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?ID=%@&confirm=1&Ids=%@", SERVER_ADDRESS, DELETE_TRAININGPLAN, [defaults objectForKey:@"userID"], ids]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
            
            [request setHTTPMethod:@"POST"];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
             
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       [self showProgress:NO];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
        }
    } else {
        if (buttonIndex == 1) {
            
            NSMutableArray *weekday = [(NSMutableArray*)[appDelegate.plans objectAtIndex:selectedWeekday] mutableCopy];
            TrainingPlan *plan = (TrainingPlan*) [weekday objectAtIndex:(int)localAlertView.tag];
            
            editableIndex = -1;
            [self.planTableView setEditing:NO animated:NO];
            
            [self showProgress:YES];
            
            NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?ID=%@", SERVER_ADDRESS, DELETE_TRAININGPLAN, plan.ID]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
            
            [request setHTTPMethod:@"POST"];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
             
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       @try {
                                           [weekday removeObjectAtIndex:(int)localAlertView.tag];
                                           [appDelegate.plans removeObjectAtIndex:selectedWeekday];
                                           [appDelegate.plans insertObject:weekday atIndex:selectedWeekday];
                                       }
                                       @catch (NSException *exception) {
                                           
                                       }
                                       @finally {
                                           [self showProgress:NO];
                                           [self.planTableView reloadData];
                                       }
                                       
                                   }];
        }
    }
}

- (void)swipeback:(UITapGestureRecognizer*)recognizer {
    if (isEditMode == YES) {
        //((TrainingPlanTableViewCell*)recognizer.view).btnTap.hidden = YES;
        editableIndex = -1;
        [self.planTableView setEditing:NO animated:NO];
        [self.planTableView reloadData];
    }
}

- (void)btnViewTrainingPlanClicked:(UITapGestureRecognizer*)recognizer {
    if (isEditMode == YES) {
        
        NSMutableArray *weekday = (NSMutableArray*)[appDelegate.plans objectAtIndex:selectedWeekday];
        TrainingPlan *plan = (TrainingPlan*) [weekday objectAtIndex:(int)recognizer.view.tag];
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailViewController *controller = (DetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        controller.exercise = plan.exercise;
        controller.notes = plan.notes;
        controller.planIndex = (int) recognizer.view.tag;
        controller.planId = [plan.ID intValue];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        if (expandIndex == (int) recognizer.view.tag)
            expandIndex = -1;
        else
            expandIndex = (int) recognizer.view.tag;
        [self.planTableView reloadData];
    }
}

- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}

- (NSMutableArray* ) copyArray:(NSMutableArray *) source {
    NSMutableArray *destination = [[NSMutableArray alloc] init];
    for (int i = 0; i < [source count]; i++) {
        NSMutableArray *week = (NSMutableArray*) [source objectAtIndex:i];
        NSMutableArray *newWeek = [[NSMutableArray alloc] init];
        for (int j = 0; j < [week count]; j++) {
            [newWeek addObject:[week objectAtIndex:j]];
        }
        [destination addObject:newWeek];
    }
    
    return destination;
}

- (IBAction)btnEditModeClicked:(id)sender {
    
    //appDelegate.editPlans = [[NSMutableArray alloc] initWithArray:appDelegate.plans copyItems:YES];
    appDelegate.editPlans = [self copyArray:appDelegate.plans];
    
    expandIndex = -1;
    isEditMode = YES;
    [self.imgEditMode setImage:[UIImage imageNamed:@"trainingplan_edit2.png"]];
    //[self.btnShare setBackgroundImage:[UIImage imageNamed:@"trainingplan_save.png"] forState:UIControlStateNormal];
    self.btnShare.hidden = NO;
    [self.planTableView reloadData];
}

// reorderig
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
/*    if (indexPath.row == 0) // Don't move the first row
        return NO;
*/
    if (editableIndex == (int) indexPath.row)
        return YES;
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    /*NSString *stringToMove = [self.reorderingRows objectAtIndex:sourceIndexPath.row];
    [self.reorderingRows removeObjectAtIndex:sourceIndexPath.row];
    [self.reorderingRows insertObject:stringToMove atIndex:destinationIndexPath.row];*/
    
    
    NSMutableArray *weekday = (NSMutableArray*) [appDelegate.plans objectAtIndex:selectedWeekday];
    TrainingPlan *plan1 = (TrainingPlan*) [weekday objectAtIndex:sourceIndexPath.row];
    [weekday removeObjectAtIndex:sourceIndexPath.row];
    [weekday insertObject:plan1 atIndex:destinationIndexPath.row];
    editableIndex = -1;
    [self.planTableView reloadData];
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    /*NSDictionary *section = [data objectAtIndex:sourceIndexPath.section];
    NSUInteger sectionCount = [[section valueForKey:@"content"] count];
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSUInteger rowInSourceSection =
        (sourceIndexPath.section > proposedDestinationIndexPath.section) ?
        0 : sectionCount - 1;
        return [NSIndexPath indexPathForRow:rowInSourceSection inSection:sourceIndexPath.section];
    } else if (proposedDestinationIndexPath.row >= sectionCount) {
        return [NSIndexPath indexPathForRow:sectionCount - 1 inSection:sourceIndexPath.section];
    }*/
    // Allow the proposed destination.
    return proposedDestinationIndexPath;
}

@end

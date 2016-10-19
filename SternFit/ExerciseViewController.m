//
//  ExerciseViewController.m
//  SternFit
//
//  Created by MacOS on 12/22/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "ExerciseViewController.h"
#import "AppDelegate.h"
#import "ExerciseTableViewCell.h"
#import "Exercise.h"
#import "DetailViewController.h"

@interface ExerciseViewController () {
    NSMutableArray *imageFilenames;
    int selectedType;
    NSMutableArray *sportNotes;
    NSMutableArray *limits;
    NSMutableArray *exerciseList;
    CGRect keyboardRect;
    BOOL isKeyboardOpen;
}

@end

@implementation ExerciseViewController

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
    
    self.exerciseLabelTitle.font = [UIFont fontWithName:@"MyraidPro-Regular" size:17.0f];
    // Do any additional setup after loading the view.
    [self loadLabelForBottomMenu];
    [self registerForKeyboardNotifications];
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    CGRect frame = self.exerciseTableView.frame;
    frame.size.height = iOSDeviceScreenSize.height - 100;
    self.exerciseTableView.frame = frame;
    
}

- (void) viewWillAppear:(BOOL)animated {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.currentViewController = self;
    isKeyboardOpen = NO;
    
    if (exerciseList == nil) {
        exerciseList = [[NSMutableArray alloc] init];
        [self searchExercises:@"" isCatSearch:YES];
    }
}

- (void) searchExercises:(NSString *) searchKey isCatSearch:(BOOL) isCatSearch {
    if (self.selectCatId == 8) {
        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?key=%@", SERVER_ADDRESS, SEARCH_DIETEXERCISES, searchKey]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
        
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
         
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   @try {
                                       NSMutableArray *result = (NSMutableArray*) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       
                                       if (result != nil && [result count] > 0) {
                                           NSMutableDictionary *temp;
                                           for (int i = 0; i < [result count]; i++) {
                                               temp = (NSMutableDictionary*) [result objectAtIndex:i];
                                               Exercise *exercise = [[Exercise alloc] init];
                                               exercise.name = [temp objectForKey:@"name"];
                                               exercise.image = [temp objectForKey:@"image"];
                                               exercise.ID = [temp objectForKey:@"ID"];
                                               exercise.categoryID = @"8";
                                               exercise.type = 4;
                                               
                                               [exerciseList addObject:exercise];
                                           }
                                       }
                                   }
                                   @catch (NSException *exception) {
                                       
                                   }
                                   @finally {
                                       [self.exerciseTableView reloadData];
                                   }
                               }];
    } else if (self.selectCatId == 9) {
        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?key=%@", SERVER_ADDRESS, SEARCH_SUPPLEMENTEXERCISES, searchKey]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
        
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
         
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   @try {
                                       NSMutableArray *result = (NSMutableArray*) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       
                                       if (result != nil && [result count] > 0) {
                                           NSMutableDictionary *temp;
                                           for (int i = 0; i < [result count]; i++) {
                                               temp = (NSMutableDictionary*) [result objectAtIndex:i];
                                               Exercise *exercise = [[Exercise alloc] init];
                                               exercise.name = [temp objectForKey:@"name"];
                                               exercise.image = [temp objectForKey:@"image"];
                                               exercise.ID = [temp objectForKey:@"ID"];
                                               exercise.categoryID = @"9";
                                               exercise.type = 5;
                                               
                                               [exerciseList addObject:exercise];
                                           }
                                       }
                                   }
                                   @catch (NSException *exception) {
                                       
                                   }
                                   @finally {
                                       [self.exerciseTableView reloadData];
                                   }
                               }];
    } else {
        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?key=%@&cID=%d", SERVER_ADDRESS, SEARCH_EXERCISES, searchKey, self.selectCatId]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
        
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
         
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   @try {
                                       NSMutableArray *result = (NSMutableArray*) [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                       
                                       if (result != nil && [result count] > 0) {
                                           NSMutableDictionary *temp;
                                           for (int i = 0; i < [result count]; i++) {
                                               temp = (NSMutableDictionary*) [result objectAtIndex:i];
                                               Exercise *exercise = [[Exercise alloc] init];
                                               exercise.type = [[temp objectForKey:@"type"] intValue];
                                               exercise.name = [temp objectForKey:@"name"];
                                               exercise.image = [temp objectForKey:@"image"];
                                               exercise.ID = [temp objectForKey:@"ID"];
                                               exercise.categoryID = [temp objectForKey:@"categoryID"];
                                               
                                               [exerciseList addObject:exercise];
                                           }
                                       }
                                   }
                                   @catch (NSException *exception) {
                                       
                                   }
                                   @finally {
                                       [self.exerciseTableView reloadData];
                                   }
                               }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadLabelForBottomMenu {
    self.exerciseLabelTitle.text = self.exerciseName;
    self.exerciseTxtSearch.text = NSLocalizedString(@"Search", nil);
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - mark TextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqual:NSLocalizedString(@"Search", nil)])
        textField.text = @"";
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqual:@""]) {
        textField.text = NSLocalizedString(@"Search", nil);
        exerciseList = [[NSMutableArray alloc] init];
        [self.exerciseTableView reloadData];
        
        [self searchExercises:@"" isCatSearch:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {  // return NO to not change text
    NSString *search = self.exerciseTxtSearch.text;
    
    if ([string isEqual:@"\n"]) {
        [self.exerciseTxtSearch resignFirstResponder];
        isKeyboardOpen = NO;
        return NO;
    } else if ([string isEqual:@""]) {
        if ([search length] >= 1) {
            search = [search substringToIndex:([search length] - 1)];
        }
    } else {
        search = [NSString stringWithFormat:@"%@%@", search, string];
    }

    exerciseList = [[NSMutableArray alloc] init];
    [self.exerciseTableView reloadData];
    
    [self searchExercises:[search stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isCatSearch:YES];
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.exerciseTxtSearch resignFirstResponder];
    isKeyboardOpen = NO;
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
    return [exerciseList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ExerciseTableViewCell";
    
    ExerciseTableViewCell *cell = (ExerciseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //cell.parent = self;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExerciseTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Exercise *exercise;
    exercise = (Exercise*) [exerciseList objectAtIndex:indexPath.row];
    cell.labelExerciseName.text = exercise.name;
    
    UIColor *borderColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
    cell.imgExercise.layer.borderColor = borderColor.CGColor;
    cell.imgExercise.layer.borderWidth = 3.0f;
    cell.imgExercise.layer.cornerRadius = 30.0f;
    cell.imgExercise.layer.masksToBounds = YES;
    
    [cell.imgExercise setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [cell.imgExercise setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@cat0%@/%@", EXERCISE_ICON_URL, exercise.categoryID, exercise.image]]];

    //[cell.imgExercise setImage:[UIImage imageNamed:[imageFilenames objectAtIndex:type]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath      *)indexPath;
{
    return 82;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isKeyboardOpen == YES) {
        [self.exerciseTxtSearch resignFirstResponder];
        isKeyboardOpen = NO;
        return;
    }

    Exercise *exercise = (Exercise*) [exerciseList objectAtIndex:indexPath.row];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *controller = (DetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    controller.exercise = exercise;
    controller.notes = @"";
    controller.planIndex = -1;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)UIKeyboardWillShowNotification:(NSNotification*)notification
{
    isKeyboardOpen = YES;
}

@end

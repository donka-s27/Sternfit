//
//  ExerciseViewController.m
//  SternFit
//
//  Created by MacOS on 12/22/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "ExerciseTableViewCell.h"
#import "Exercise.h"
#import "NotesEditViewController.h"
#import "TrainingPlan.h"
#import "DietPlan.h"
#import "SupplementPlan.h"

@interface DetailViewController () {
    NSMutableArray *imageFilenames;
    int selectedType;
    NSMutableArray *limits;
    
    AppDelegate *appDelegate;
    NSUserDefaults *defaults;
}

@end

@implementation DetailViewController

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
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.detailLabelTitle.font = [UIFont fontWithName:@"MyraidPro-Regular" size:17.0f];
    // Do any additional setup after loading the view.
    [self loadLabelForBottomMenu];
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;

    CGRect frame = self.pickerView1.frame;
    frame.size.height = iOSDeviceScreenSize.height - 353;
    self.pickerView1.frame = frame;
    
    frame = self.btnSave.frame;
    if (iOSDeviceScreenSize.height == 480)
        frame.origin.y = iOSDeviceScreenSize.height - 82;
    else
        frame.origin.y = iOSDeviceScreenSize.height - 100;
    self.btnSave.frame = frame;
    
    self.detailSubView1.hidden = YES;
    self.detailSubView2.hidden = YES;
    self.detailSubView3.hidden = YES;
    self.detailSubView4.hidden = YES;
    
    [self initValues];
    
    UITapGestureRecognizer *tapView8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editNotesTap:)];
    tapView8.delegate = self;
    [self.detailSummary addGestureRecognizer:tapView8];
    [self.detailSummary setUserInteractionEnabled:YES];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    appDelegate.currentViewController = self;
    
    selectedType = self.exercise.type;
    self.detailLabelTitle.text = self.exercise.name;
    //selectedType = 0;
    //[self.detailSummary setText:[[sportNotes objectAtIndex:selectedType] description]];
    if ([self.notes isEqual:@""])
        self.detailSummary.text = NSLocalizedString(@"Enter Notes Here", nil);
    else
        self.detailSummary.text = self.notes;
    self.detailSummary.textColor = [UIColor whiteColor];
    self.detailSubView1.hidden = YES;
    self.detailSubView2.hidden = YES;
    self.detailSubView3.hidden = YES;
    self.detailSubView4.hidden = YES;
    switch (selectedType) {
        case 3:
            self.detailSubView1.hidden = NO;
            break;
        case 2:
            self.detailSubView2.hidden = NO;
            break;
        case 0:
            self.detailSubView3.hidden = NO;
            break;
        case 1:
            self.detailSubView4.hidden = NO;
            break;
    }
    
    if (selectedType <= 3) {
        [self.pickerView1 reloadAllComponents];
        [self.pickerView1 selectRow:0 inComponent:0 animated:NO];
        [self.pickerView1 selectRow:0 inComponent:1 animated:NO];
        if (selectedType == 0 || selectedType == 1)
            [self.pickerView1 selectRow:0 inComponent:2 animated:NO];
    } else {
        self.pickerView1.hidden = YES;
        
        CGRect frame = self.btnSave.frame;
        frame.origin.y = 190;
        self.btnSave.frame = frame;
    }
    
    UIColor *borderColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
    self.detailImage.layer.borderColor = borderColor.CGColor;
    self.detailImage.layer.borderWidth = 5.0f;
    self.detailImage.layer.cornerRadius = 55.0f;
    self.detailImage.layer.masksToBounds = YES;
    
    [self.detailImage setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.detailImage setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@cat0%@/%@", EXERCISE_ICON_URL, self.exercise.categoryID, self.exercise.image]]];
    
    if (self.planIndex != -1) {
        
        if (selectedType <= 3) {
            TrainingPlan *plan;
            if (appDelegate.selectOtherUser == nil) {
                NSMutableArray *weekday = (NSMutableArray*)[appDelegate.plans objectAtIndex:[[defaults objectForKey:@"weekday"] intValue]];
                plan = (TrainingPlan*) [weekday objectAtIndex:self.planIndex];
            } else {
                plan = self.tPlan;
            }
            
            
            if ([self.notes isEqual:@""]) {
                self.notes = plan.notes;
                if ([self.notes isEqual:@""])
                    self.detailSummary.text = NSLocalizedString(@"Enter Notes Here", nil);
                else
                    self.detailSummary.text = self.notes;
            }
            self.detailSummary.textColor = [UIColor whiteColor];
            @try {
                NSArray *details = [plan.detail componentsSeparatedByString:@":"];
                switch (plan.exercise.type) {
                    case 2:
                        [self.pickerView1 selectRow:([[details objectAtIndex:0] intValue]) inComponent:0 animated:NO];
                        [self.pickerView1 selectRow:([[details objectAtIndex:1] intValue]) inComponent:1 animated:NO];
                        break;
                    case 0:
                        [self.pickerView1 selectRow:([[details objectAtIndex:0] intValue] - 1) inComponent:0 animated:NO];
                        [self.pickerView1 selectRow:([[details objectAtIndex:1] intValue] - 1) inComponent:1 animated:NO];
                        [self.pickerView1 selectRow:([[details objectAtIndex:2] intValue] - 1) inComponent:2 animated:NO];
                        break;
                    case 1:
                        [self.pickerView1 selectRow:([[details objectAtIndex:0] intValue] - 1) inComponent:0 animated:NO];
                        [self.pickerView1 selectRow:([[details objectAtIndex:1] intValue]) inComponent:1 animated:NO];
                        [self.pickerView1 selectRow:([[details objectAtIndex:2] intValue]) inComponent:2 animated:NO];
                        break;
                    case 3:
                        [self.pickerView1 selectRow:([[details objectAtIndex:0] intValue] - 1) inComponent:0 animated:NO];
                        [self.pickerView1 selectRow:([[details objectAtIndex:1] intValue] - 1) inComponent:1 animated:NO];
                        break;
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        } else if (selectedType == 4) {
            DietPlan *plan;
            if (appDelegate.selectOtherUser == nil) {
                NSMutableArray *weekday = (NSMutableArray*)[appDelegate.dietplans objectAtIndex:[[defaults objectForKey:@"weekday"] intValue]];
                plan = (DietPlan*) [weekday objectAtIndex:self.planIndex];
            } else {
                plan = self.dPlan;
            }
            
            
            if ([self.notes isEqual:@""]) {
                self.notes = plan.notes;
                if ([self.notes isEqual:@""])
                    self.detailSummary.text = NSLocalizedString(@"Enter Notes Here", nil);
                else
                    self.detailSummary.text = self.notes;
            }
            self.detailSummary.textColor = [UIColor whiteColor];
        } else if (selectedType == 5) {
            SupplementPlan *plan;
            if (appDelegate.selectOtherUser == nil) {
                NSMutableArray *weekday = (NSMutableArray*)[appDelegate.supplementplans objectAtIndex:[[defaults objectForKey:@"weekday"] intValue]];
                plan = (SupplementPlan*) [weekday objectAtIndex:self.planIndex];
            } else {
                plan = self.sPlan;
            }
            
            
            if ([self.notes isEqual:@""]) {
                self.notes = plan.notes;
                if ([self.notes isEqual:@""])
                    self.detailSummary.text = NSLocalizedString(@"Enter Notes Here", nil);
                else
                    self.detailSummary.text = self.notes;
            }
            self.detailSummary.textColor = [UIColor whiteColor];
        }
        
        
    }
    
    if (appDelegate.selectOtherUser == nil) {
        self.btnSave.hidden = NO;
        [self.detailSummary setUserInteractionEnabled:YES];
        [self.pickerView1 setUserInteractionEnabled:YES];
    } else {
        self.btnSave.hidden = YES;
        [self.detailSummary setUserInteractionEnabled:NO];
        [self.pickerView1 setUserInteractionEnabled:NO];
    }
}

- (void) initValues {
    imageFilenames = [[NSMutableArray alloc] init];
    [imageFilenames addObject:@"profile_running.png"];
    [imageFilenames addObject:@"profile_weight.png"];
    [imageFilenames addObject:@"profile_walking.png"];
    [imageFilenames addObject:@"profile_other.png"];
    
    limits = [[NSMutableArray alloc] init];
    NSMutableArray *limit1 = [[NSMutableArray alloc] init];
    [limit1 addObject:@"1"];
    [limit1 addObject:@"1000"];
    [limit1 addObject:@"1"];
    [limit1 addObject:@"100"];
    [limit1 addObject:@"1"];
    [limit1 addObject:@"100"];
    [limits addObject:limit1];
    
    limit1 = [[NSMutableArray alloc] init];
    [limit1 addObject:@"1"];
    [limit1 addObject:@"100"];
    [limit1 addObject:@"0"];
    [limit1 addObject:@"59"];
    [limit1 addObject:@"0"];
    [limit1 addObject:@"59"];
    [limits addObject:limit1];
    
    limit1 = [[NSMutableArray alloc] init];
    [limit1 addObject:@"0"];
    [limit1 addObject:@"23"];
    [limit1 addObject:@"0"];
    [limit1 addObject:@"59"];
    [limits addObject:limit1];
    
    limit1 = [[NSMutableArray alloc] init];
    [limit1 addObject:@"1"];
    [limit1 addObject:@"100"];
    [limit1 addObject:@"1"];
    [limit1 addObject:@"100"];
    [limits addObject:limit1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadLabelForBottomMenu {
    self.detailLabelTitle.text = self.exercise.name;
    [self.btnSave setTitle:NSLocalizedString(@"SAVE", nil) forState:UIControlStateNormal];
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSaveClicked:(id)sender {
    [self showProgress:YES];
    
    if (selectedType == 4) {
        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?uID=%@&weekday=%@&eID=%@&notes=%@&planIndex=-1", SERVER_ADDRESS, ADD_DIETPLAN, [defaults objectForKey:@"userID"], [defaults objectForKey:@"weekday"], self.exercise.ID, [self.notes stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
        if (self.planIndex != -1) {
            myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?uID=%@&weekday=%@&eID=%@&notes=%@&planIndex=%d&pID=%d", SERVER_ADDRESS, ADD_DIETPLAN, [defaults objectForKey:@"userID"], [defaults objectForKey:@"weekday"], self.exercise.ID, [self.notes stringByReplacingOccurrencesOfString:@" " withString:@"%20"], self.planIndex, self.planId]];
        }
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
        
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
         
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   @try {
                                       if (data != nil) {
                                           if (self.planIndex == -1) {
                                               DietPlan *plan = [[DietPlan alloc] init];
                                               plan.ID = [NSString stringWithUTF8String:[data bytes]];
                                               plan.weekday = [[defaults objectForKey:@"weekday"] intValue];
                                               plan.notes = self.notes;
                                               plan.exercise = self.exercise;
                                               
                                               NSMutableArray *weekday = (NSMutableArray*) [appDelegate.dietplans objectAtIndex:plan.weekday];
                                               [weekday addObject:plan];
                                           } else {
                                               
                                               NSMutableArray *weekday = (NSMutableArray*)[appDelegate.dietplans objectAtIndex:[[defaults objectForKey:@"weekday"] intValue]];
                                               DietPlan *plan = (DietPlan*) [weekday objectAtIndex:self.planIndex];
                                               plan.weekday = [[defaults objectForKey:@"weekday"] intValue];
                                               plan.notes = self.notes;
                                               plan.exercise = self.exercise;
                                               
                                               [weekday removeObjectAtIndex:self.planIndex];
                                               [weekday insertObject:plan atIndex:self.planIndex];
                                           }
                                       }
                                   }
                                   @catch (NSException *exception) {
                                       
                                   }
                                   @finally {
                                       [self showProgress:NO];
                                       NSArray *array = [self.navigationController viewControllers];
                                       for (int i = (int)[array count] - 1; i >= 0; i--) {
                                           if ([[array objectAtIndex:i] isKindOfClass:[DietPlanViewController class]]) {
                                               [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                                               return;
                                           }
                                           if ([[array objectAtIndex:i] isKindOfClass:[MHCustomTabBarController class]]) {
                                               
                                               [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                                               
                                               return;
                                           }
                                       }
                                   }
                                   
                               }];
    } else if (selectedType == 5) {
        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?uID=%@&weekday=%@&eID=%@&notes=%@&planIndex=-1", SERVER_ADDRESS, ADD_SUPPLEMENTPLAN, [defaults objectForKey:@"userID"], [defaults objectForKey:@"weekday"], self.exercise.ID, [self.notes stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
        if (self.planIndex != -1) {
            myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?uID=%@&weekday=%@&eID=%@&notes=%@&planIndex=%d&pID=%d", SERVER_ADDRESS, ADD_SUPPLEMENTPLAN, [defaults objectForKey:@"userID"], [defaults objectForKey:@"weekday"], self.exercise.ID, [self.notes stringByReplacingOccurrencesOfString:@" " withString:@"%20"], self.planIndex, self.planId]];
        }
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
        
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
         
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   @try {
                                       if (data != nil) {
                                           if (self.planIndex == -1) {
                                               SupplementPlan *plan = [[SupplementPlan alloc] init];
                                               plan.ID = [NSString stringWithUTF8String:[data bytes]];
                                               plan.weekday = [[defaults objectForKey:@"weekday"] intValue];
                                               plan.notes = self.notes;
                                               plan.exercise = self.exercise;
                                               
                                               NSMutableArray *weekday = (NSMutableArray*) [appDelegate.supplementplans objectAtIndex:plan.weekday];
                                               [weekday addObject:plan];
                                           } else {
                                               
                                               NSMutableArray *weekday = (NSMutableArray*)[appDelegate.supplementplans objectAtIndex:[[defaults objectForKey:@"weekday"] intValue]];
                                               SupplementPlan *plan = (SupplementPlan*) [weekday objectAtIndex:self.planIndex];
                                               plan.weekday = [[defaults objectForKey:@"weekday"] intValue];
                                               plan.notes = self.notes;
                                               plan.exercise = self.exercise;
                                               
                                               [weekday removeObjectAtIndex:self.planIndex];
                                               [weekday insertObject:plan atIndex:self.planIndex];
                                           }
                                       }
                                   }
                                   @catch (NSException *exception) {
                                       
                                   }
                                   @finally {
                                       [self showProgress:NO];
                                       NSArray *array = [self.navigationController viewControllers];
                                       for (int i = (int)[array count] - 1; i >= 0; i--) {
                                           if ([[array objectAtIndex:i] isKindOfClass:[SupplementPlanViewController class]]) {
                                               [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                                               return;
                                           }
                                           if ([[array objectAtIndex:i] isKindOfClass:[MHCustomTabBarController class]]) {
                                               
                                               [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                                               
                                               return;
                                           }
                                       }
                                   }
                                   
                               }];
    } else {
        NSString *detail;
        
        switch (selectedType) {
            case 3:
                detail = [NSString stringWithFormat:@"%d:%d", (int)([self.pickerView1 selectedRowInComponent:0] + 1), (int)([self.pickerView1 selectedRowInComponent:1] + 1)];
                break;
            case 2:
                detail = [NSString stringWithFormat:@"%d:%d", (int)([self.pickerView1 selectedRowInComponent:0]), (int)([self.pickerView1 selectedRowInComponent:1])];
                break;
            case 0:
                detail = [NSString stringWithFormat:@"%d:%d:%d", (int)([self.pickerView1 selectedRowInComponent:0] + 1), (int)([self.pickerView1 selectedRowInComponent:1] + 1), (int)([self.pickerView1 selectedRowInComponent:2] + 1)];
                break;
            case 1:
                detail = [NSString stringWithFormat:@"%d:%d:%d", (int)([self.pickerView1 selectedRowInComponent:0] + 1), (int)([self.pickerView1 selectedRowInComponent:1]), (int)([self.pickerView1 selectedRowInComponent:2])];
                break;
        }
        
        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?uID=%@&weekday=%@&eID=%@&detail=%@&notes=%@&planIndex=-1", SERVER_ADDRESS, ADD_TRAININGPLAN, [defaults objectForKey:@"userID"], [defaults objectForKey:@"weekday"], self.exercise.ID, detail, [self.notes stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
        if (self.planIndex != -1) {
            myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?uID=%@&weekday=%@&eID=%@&detail=%@&notes=%@&planIndex=%d&pID=%d", SERVER_ADDRESS, ADD_TRAININGPLAN, [defaults objectForKey:@"userID"], [defaults objectForKey:@"weekday"], self.exercise.ID, detail, [self.notes stringByReplacingOccurrencesOfString:@" " withString:@"%20"], self.planIndex, self.planId]];
        }
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
        
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
         
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   @try {
                                       if (data != nil) {
                                           if (self.planIndex == -1) {
                                               TrainingPlan *plan = [[TrainingPlan alloc] init];
                                               plan.ID = [NSString stringWithUTF8String:[data bytes]];
                                               plan.weekday = [[defaults objectForKey:@"weekday"] intValue];
                                               plan.detail = detail;
                                               plan.notes = self.notes;
                                               plan.exercise = self.exercise;
                                               
                                               
                                               NSMutableArray *weekday = (NSMutableArray*) [appDelegate.plans objectAtIndex:plan.weekday];
                                               [weekday addObject:plan];
                                           } else {
                                               
                                               NSMutableArray *weekday = (NSMutableArray*)[appDelegate.plans objectAtIndex:[[defaults objectForKey:@"weekday"] intValue]];
                                               TrainingPlan *plan = (TrainingPlan*) [weekday objectAtIndex:self.planIndex];
                                               plan.weekday = [[defaults objectForKey:@"weekday"] intValue];
                                               plan.detail = detail;
                                               plan.notes = self.notes;
                                               plan.exercise = self.exercise;
                                               
                                               [weekday removeObjectAtIndex:self.planIndex];
                                               [weekday insertObject:plan atIndex:self.planIndex];
                                           }
                                       }
                                   }
                                   @catch (NSException *exception) {
                                       
                                   }
                                   @finally {
                                       [self showProgress:NO];
                                       NSArray *array = [self.navigationController viewControllers];
                                       for (int i = (int)[array count] - 1; i >= 0; i--) {
                                           if ([[array objectAtIndex:i] isKindOfClass:[TrainingViewController class]]) {
                                               [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                                               return;
                                           }
                                           if ([[array objectAtIndex:i] isKindOfClass:[MHCustomTabBarController class]]) {
                                               
                                               [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                                               
                                               return;
                                           }
                                       }
                                   }
                                   
                               }];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (selectedType >= 4)
        return 0;
    NSMutableArray *limit = [limits objectAtIndex:selectedType];
    int size = [[limit objectAtIndex:component * 2 + 1] intValue] - [[limit objectAtIndex:component * 2] intValue] + 1;
    return size;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *tView = (UILabel *)view;
    if (!tView) {
        tView = [[UILabel alloc] init];
       // tView.minimumFontSize = 8.0f;
        tView.adjustsFontSizeToFitWidth = YES;
    }
    
    NSMutableArray *limit = [limits objectAtIndex:selectedType];
    tView.text = [NSString stringWithFormat:@"%d", (int)([[limit objectAtIndex:component * 2] intValue] + row)];
    tView.textAlignment = NSTextAlignmentCenter;
    
    return tView;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (selectedType >= 4)
        return 1;
    NSMutableArray *limit = [limits objectAtIndex:selectedType];
    return [limit count] / 2;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"";
    
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (selectedType >= 4)
        return 285;
    NSMutableArray *limit = [limits objectAtIndex:selectedType];
    return 285 / ([limit count] / 2);
}

- (IBAction)editNotesTap:(UITapGestureRecognizer*)recognizer {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NotesEditViewController *controller = (NotesEditViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NotesEditViewController"];
    controller.notes = self.notes;
    controller.customParent = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}

@end

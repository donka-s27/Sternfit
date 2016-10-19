//
//  ProfileViewController.m
//  SternFit
//
//  Created by MacOS on 12/11/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "OtherProfileViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "TrainingPlanTableViewCell.h"
#import "TrainingPlan.h"
#import "Exercise.h"
#import "DetailViewController.h"
#import "PlanCategoryTableViewCell.h"
#import "DietPlan.h"
#import "SupplementPlan.h"
#import "DietPlanTableViewCell.h"
#import "SupplementPlanTableViewCell.h"

@interface OtherProfileViewController () {
    int selectedWeekday;
    int photoIndex;
    UIImage *bmImage;
    BOOL isRetina;
    NSString *strHeight, *strWeight;
    AppDelegate *appDelegate;
    NSUserDefaults *defaults;
    NSMutableArray *tPlans;
    int expandIndex;
    NSMutableArray *planCategories;
    int planIndex;
}

//@property (nonatomic) UIImagePickerController *imagePickerController;
//@property (nonatomic) UIImagePickerController *imagePickerCameraController;
@property (nonatomic) UIActionSheet *actionSheet;

@end

@implementation OtherProfileViewController

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
    [self loadLabelForBottomMenu];
    
    defaults = [NSUserDefaults standardUserDefaults];
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    selectedWeekday = 0;
    
    UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    self.imgProfile.layer.borderColor = borderColor.CGColor;
    self.imgProfile.layer.borderWidth = 3.0f;
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
    
    
    UITapGestureRecognizer *tapView21 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoViewTap:)];
    tapView2.delegate = self;
    [self.imgProfile addGestureRecognizer:tapView21];
    [self.imgProfile setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapView31 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoViewTap:)];
    tapView3.delegate = self;
    [self.imgPhoto1 addGestureRecognizer:tapView31];
    [self.imgPhoto1 setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapView41 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoViewTap:)];
    tapView4.delegate = self;
    [self.imgPhoto2 addGestureRecognizer:tapView41];
    [self.imgPhoto2 setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapView51 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoViewTap:)];
    tapView5.delegate = self;
    [self.imgPhoto3 addGestureRecognizer:tapView51];
    [self.imgPhoto3 setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapView61 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoViewTap:)];
    tapView6.delegate = self;
    [self.imgPhoto4 addGestureRecognizer:tapView61];
    [self.imgPhoto4 setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapView71 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoViewTap:)];
    tapView7.delegate = self;
    [self.imgPhoto5 addGestureRecognizer:tapView71];
    [self.imgPhoto5 setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapView32 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(overlayImageViewTap:)];
    tapView32.delegate = self;
    [self.overlayImageView addGestureRecognizer:tapView32];
    
    self.labelTitle.font = [UIFont fontWithName:@"Lato-Bold" size:16.0f];
    self.labelSubtitle.font = [UIFont fontWithName:@"Lato-Regular" size:13.0f];
    self.labelAge.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    self.labelWeight.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    self.labelHeight.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];

    self.labelTrainingPlan.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17.0f];
    self.labelWeekday1.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12.0f];
    self.labelWeekday2.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12.0f];
    self.labelWeekday3.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12.0f];
    self.labelWeekday4.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12.0f];
    self.labelWeekday5.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12.0f];
    self.labelWeekday6.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12.0f];
    self.labelWeekday7.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12.0f];
    
    planCategories = [[NSMutableArray alloc] init];
    [planCategories addObject:NSLocalizedString(@"Training Plan", nil)];
    [planCategories addObject:NSLocalizedString(@"Diet Plan", nil)];
    [planCategories addObject:NSLocalizedString(@"Supplement Plan", nil)];
    
    UITapGestureRecognizer *tapView91 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(overlayViewTap:)];
    tapView91.delegate = self;
    [self.overlayView addGestureRecognizer:tapView91];
    
    planIndex = 0;
}


- (void) viewWillAppear:(BOOL)animated {
    
    UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    self.labelStatus.layer.borderColor = borderColor.CGColor;
    self.labelStatus.layer.borderWidth = 2.0f;
    self.labelStatus.layer.cornerRadius = 7.5f;
    if (appDelegate.selectOtherUser.status == NO) {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
    } else {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:227.0f/255.0f blue:54.0f/255.0f alpha:1];
    }
}

- (void) refreshData {
    [self.imgPhoto1 setImage:nil];
    [self.imgPhoto2 setImage:nil];
    [self.imgPhoto3 setImage:nil];
    [self.imgPhoto4 setImage:nil];
    [self.imgPhoto5 setImage:nil];
    [self.imgProfile setImage:nil];
    
     {
        tPlans = [[NSMutableArray alloc] init];
        [self loadPlans];
        
        self.labelTitle.text = self->appDelegate.selectOtherUser.name;
        self.labelSubtitle.text = self->appDelegate.selectOtherUser.message;
        self.labelAge.text = [NSString stringWithFormat:@"%@: %d", NSLocalizedString(@"Age", nil), self->appDelegate.selectOtherUser.age];
        double height = (double) self->appDelegate.selectOtherUser.height;
        int weight = self->appDelegate.selectOtherUser.weight;
        if ([[self->defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
            strHeight = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"HEIGHT", nil), NSLocalizedString(@"feet", nil)];
            strWeight = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"WEIGHT", nil), NSLocalizedString(@"lbs", nil)];
            height = height * 0.0328084f;
            weight = (int)((double)weight * 2.20462f);
            self.labelHeight.text = [NSString stringWithFormat:@"%@: %d'%d\"", NSLocalizedString(@"Height", nil), (int)height, (int)(height * 10) % 10];
            self.labelWeight.text = [NSString stringWithFormat:@"%@: %dlbs", NSLocalizedString(@"Weight", nil), weight];
        } else {
            strHeight = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"HEIGHT", nil), NSLocalizedString(@"cm", nil)];
            strWeight = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"WEIGHT", nil), NSLocalizedString(@"kg", nil)];
            self.labelHeight.text = [NSString stringWithFormat:@"%@: %dcm", NSLocalizedString(@"Height", nil), (int)height];
            self.labelWeight.text = [NSString stringWithFormat:@"%@: %dkg", NSLocalizedString(@"Weight", nil), weight];
        }
        
        if (self->appDelegate.selectOtherUser.gender == YES) {
            UIColor *borderColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
            self.imgProfile.layer.borderColor = borderColor.CGColor;
        } else {
            UIColor *borderColor = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:90.0f/255.0f alpha:1];
            self.imgProfile.layer.borderColor = borderColor.CGColor;
        }
        
        if ([self->appDelegate.selectOtherUser.image isEqual:@""]) {
            [self.imgProfile setImage:[UIImage imageNamed:@"avator.png"]];
        } else {
            [self.imgProfile setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self.imgProfile setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, self->appDelegate.selectOtherUser.image]]];
        }
        
        if (![self->appDelegate.selectOtherUser.photo1 isEqual:@""]) {
            [self.imgPhoto1 setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self.imgPhoto1 setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, self->appDelegate.selectOtherUser.photo1]]];
        }
        
        if (![self->appDelegate.selectOtherUser.photo2 isEqual:@""]) {
            [self.imgPhoto2 setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self.imgPhoto2 setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, self->appDelegate.selectOtherUser.photo2]]];
        }
        
        if (![self->appDelegate.selectOtherUser.photo3 isEqual:@""]) {
            [self.imgPhoto3 setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self.imgPhoto3 setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, self->appDelegate.selectOtherUser.photo3]]];
        }
        
        if (![self->appDelegate.selectOtherUser.photo4 isEqual:@""]) {
            [self.imgPhoto4 setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self.imgPhoto4 setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, self->appDelegate.selectOtherUser.photo4]]];
        }
        
        if (![self->appDelegate.selectOtherUser.photo5 isEqual:@""]) {
            [self.imgPhoto5 setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self.imgPhoto5 setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, self->appDelegate.selectOtherUser.photo5]]];
        }
    }
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

- (void) loadLabelForBottomMenu {

    self.labelAge.text = [NSString stringWithFormat:@"%@: %d", NSLocalizedString(@"Age", nil), 24];
    self.labelHeight.text = [NSString stringWithFormat:@"%@: %dm%d", NSLocalizedString(@"Height", nil), 1, 75];
    self.labelWeight.text = [NSString stringWithFormat:@"%@: %dkg", NSLocalizedString(@"Weight", nil), 64];
    self.labelTrainingPlan.text = NSLocalizedString(@"Training Plan", nil);
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.planCategoryTableView) {
        return [planCategories count];
    } else {
        // Return the number of rows in the section.
        if (tPlans == nil || [tPlans count] == 0)
            return 0;
        if ([tPlans count] == 0)
            return 0;
        else
            return [(NSMutableArray*)[tPlans objectAtIndex:selectedWeekday] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.planCategoryTableView) {
        static NSString *simpleTableIdentifier = @"PlanCategoryTableViewCell";
        
        PlanCategoryTableViewCell *cell = (PlanCategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        //cell.parent = self;
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PlanCategoryTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSString *value = [planCategories objectAtIndex:(int) indexPath.row];
        [cell setData:value];
        
        return cell;
    } else {
        if (planIndex == 0) {
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
            
            NSMutableArray *weekday = (NSMutableArray*) [tPlans objectAtIndex:selectedWeekday];
            cell.index = (int) indexPath.row;
            cell.controller = nil;
            [cell setData:weekday];
            
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
            
            UITapGestureRecognizer *btntap41 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnViewTrainingPlanClicked:)];
            cell.btnTap1.tag = indexPath.row;
            cell.btnTap1.hidden = NO;
            cell.btnTap.hidden = YES;
            [cell.btnTap1 addGestureRecognizer:btntap41];
            
            return cell;
        } else if (planIndex == 1) {
            static NSString *simpleTableIdentifier = @"DietPlanTableViewCell";
            
            DietPlanTableViewCell *cell = (DietPlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            //cell.parent = self;
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DietPlanTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            [cell setBackgroundColor:[UIColor clearColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSMutableArray *weekday = (NSMutableArray*) [tPlans objectAtIndex:selectedWeekday];
            cell.index = (int) indexPath.row;
            cell.controller = nil;
            [cell setData:weekday];
            
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
            
            UITapGestureRecognizer *btntap41 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnViewTrainingPlanClicked:)];
            cell.btnTap1.tag = indexPath.row;
            cell.btnTap1.hidden = NO;
            cell.btnTap.hidden = YES;
            [cell.btnTap1 addGestureRecognizer:btntap41];
            
            return cell;
        } else if (planIndex == 2) {
            static NSString *simpleTableIdentifier = @"SupplementPlanTableViewCell";
            
            SupplementPlanTableViewCell *cell = (SupplementPlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            //cell.parent = self;
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SupplementPlanTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            [cell setBackgroundColor:[UIColor clearColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSMutableArray *weekday = (NSMutableArray*) [tPlans objectAtIndex:selectedWeekday];
            cell.index = (int) indexPath.row;
            cell.controller = nil;
            [cell setData:weekday];
            
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
            
            UITapGestureRecognizer *btntap41 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnViewTrainingPlanClicked:)];
            cell.btnTap1.tag = indexPath.row;
            cell.btnTap1.hidden = NO;
            cell.btnTap.hidden = YES;
            [cell.btnTap1 addGestureRecognizer:btntap41];
            
            return cell;
        }
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath      *)indexPath;
{
    if (tableView == self.planCategoryTableView) {
        return 35;
    } else {
        if (expandIndex == indexPath.row)
            return 162;
        else
            return 62;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.planCategoryTableView) {
        [self.imgPlanScroll setImage:[UIImage imageNamed:@"settings_visible_down.png"]];
        self.overlayView.hidden = YES;
        self.planCategoryView.hidden = YES;
        
        self.labelTrainingPlan.text = [planCategories objectAtIndex:(int)indexPath.row];
        planIndex = (int) indexPath.row;
        
        switch (planIndex) {
            case 0:
                tPlans = [[NSMutableArray alloc] init];
                [self loadPlans];
                break;
            case 1:
                tPlans = [[NSMutableArray alloc] init];
                [self loadDietPlans];
                break;
            case 2:
                tPlans = [[NSMutableArray alloc] init];
                [self loadSupplementPlans];
                break;
        }
        
        [self.planTableView reloadData];
    }
}

- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
	
    //[self changeUploadButtonPosition];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}

- (IBAction)btnShareClicked:(id)sender {
   // [((MHCustomTabBarController*) self.parentViewController) showShareView];
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    appDelegate.imageFittab = img;
    
    self.overlayImageView.alpha = 0.0f;
    self.shareView.alpha = 0.0f;
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SharePopupViewController *controller = (SharePopupViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SharePopupViewController"];
    controller.tabBarController = appDelegate.tabBarController;
    controller.otherProfileController = self;
    controller.parentViewController = nil;
    
    
    controller.content = [NSString stringWithFormat:@"%@ shared %@\'s Fit-Tab on SternFit. Check it out!", [defaults objectForKey:@"name"], appDelegate.selectOtherUser.name];
    
    [self.shareView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
    [self addChildViewController:controller];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.shareView.hidden = NO;
                         self.overlayImageView.hidden = NO;
                         self.overlayImageView.alpha = 0.7f;
                         self.shareView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)alertView:(UIAlertView *)localAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        NSMutableArray *weekday = (NSMutableArray*)[tPlans objectAtIndex:selectedWeekday];
        TrainingPlan *plan = (TrainingPlan*) [weekday objectAtIndex:(int)localAlertView.tag];
        
        [self showProgress:YES];
        
        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?ID=%@", SERVER_ADDRESS, DELETE_TRAININGPLAN, plan.ID]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
        
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
         
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   @try {
                                       [weekday removeObjectAtIndex:(int)localAlertView.tag];
                                       
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self highlightWeekday];
    
    expandIndex = -1;
    
    [self refreshData];
    
    
    appDelegate.currentViewController = self;
    
    [self.planTableView reloadData];

}

- (void)btnViewTrainingPlanClicked:(UITapGestureRecognizer*)recognizer {
    /*
    NSMutableArray *weekday = (NSMutableArray*)[tPlans objectAtIndex:selectedWeekday];
    TrainingPlan *plan = (TrainingPlan*) [weekday objectAtIndex:(int)recognizer.view.tag];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    controller.exercise = plan.exercise;
    controller.notes = plan.notes;
    controller.planIndex = (int) recognizer.view.tag;
    controller.planId = [plan.ID intValue];
    controller.tPlan = plan;
    [self.navigationController pushViewController:controller animated:YES];*/
    if (expandIndex == (int) recognizer.view.tag)
        expandIndex = -1;
    else
        expandIndex = (int) recognizer.view.tag;
    [self.planTableView reloadData];
}

- (void) loadPlans {
    [self showProgress:YES];
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?uID=%d", SERVER_ADDRESS, GET_TRAININGPLANS, appDelegate.selectOtherUser.userId]];
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
                                               
                                               [tPlans addObject:week];
                                           }
                                       }
                                   }
                                   
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   [self showProgress:NO];
                                   [self.planTableView reloadData];
                               }
                               
                           }];
}

- (void) loadDietPlans {
    [self showProgress:YES];
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?uID=%d", SERVER_ADDRESS, GET_DIETPLANS, appDelegate.selectOtherUser.userId]];
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
                                                   exercise.type = 4;
                                                   exercise.categoryID = @"8";
                                                   plan.exercise = exercise;
                                                   
                                                   [week addObject:plan];
                                               }
                                               
                                               [tPlans addObject:week];
                                           }
                                       }
                                   }
                                   
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   [self showProgress:NO];
                                   [self.planTableView reloadData];
                               }
                               
                           }];
}

- (void) loadSupplementPlans {
    [self showProgress:YES];
    
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?uID=%d", SERVER_ADDRESS, GET_SUPPLEMENTPLANS, appDelegate.selectOtherUser.userId]];
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
                                                   exercise.type = 5;
                                                   exercise.categoryID = @"9";
                                                   plan.exercise = exercise;
                                                   
                                                   [week addObject:plan];
                                               }
                                               
                                               [tPlans addObject:week];
                                           }
                                       }
                                   }
                                   
                                   
                               }
                               @catch (NSException *exception) {
                                   
                               }
                               @finally {
                                   [self showProgress:NO];
                                   [self.planTableView reloadData];
                               }
                               
                           }];
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)photoViewTap:(UITapGestureRecognizer*)recognizer {
    if (appDelegate.selectOtherUser != nil) {
        NSString *filename = @"";
        
        if (recognizer.view == self.imgProfile) {
            if (![appDelegate.selectOtherUser.image isEqual:@""]) {
                filename = appDelegate.selectOtherUser.image;
            }
        }
        if (recognizer.view == self.imgPhoto1) {
            if (![appDelegate.selectOtherUser.photo1 isEqual:@""]) {
                filename = appDelegate.selectOtherUser.photo1;
            }
        }
        
        if (recognizer.view == self.imgPhoto2) {
            if (![appDelegate.selectOtherUser.photo2 isEqual:@""]) {
                filename = appDelegate.selectOtherUser.photo2;
            }
        }
        
        if (recognizer.view == self.imgPhoto3) {
            if (![appDelegate.selectOtherUser.photo3 isEqual:@""]) {
                filename = appDelegate.selectOtherUser.photo3;
            }
        }
        
        if (recognizer.view == self.imgPhoto4) {
            if (![appDelegate.selectOtherUser.photo4 isEqual:@""]) {
                filename = appDelegate.selectOtherUser.photo4;
            }
        }
        
        if (recognizer.view == self.imgPhoto5) {
            if (![appDelegate.selectOtherUser.photo5 isEqual:@""]) {
                filename = appDelegate.selectOtherUser.photo5;
            }
        }
        
        if (![filename isEqual:@""]) {
            
            
            [self.imageHighlight setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self.imageHighlight setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, filename]]];
            
            self.overlayImageView.hidden = NO;
            self.imageContainerView.hidden = NO;
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.overlayImageView.alpha = 0.6f;
                                 self.imageContainerView.alpha = 1.0f;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        }
    }
}

- (void) hideShareView {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.overlayImageView.alpha = 0.0f;
                         self.shareView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.shareView.hidden = YES;
                         self.overlayImageView.hidden = YES;
                     }];
}

- (IBAction)overlayImageViewTap:(UITapGestureRecognizer*)recognizer {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayImageView.alpha = 0.0f;
                         self.imageContainerView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.overlayImageView.hidden = YES;
                         self.imageContainerView.hidden = YES;
                         [self.imageHighlight setImage:nil];
                     }];
}

- (IBAction)btnPlanCategoryClicked:(id)sender {
    [self.imgPlanScroll setImage:[UIImage imageNamed:@"settings_visible_up.png"]];
    self.overlayView.hidden = NO;
    self.planCategoryView.hidden = NO;
}

- (IBAction)overlayViewTap:(UITapGestureRecognizer*)recognizer {
    [self.imgPlanScroll setImage:[UIImage imageNamed:@"settings_visible_down.png"]];
    self.overlayView.hidden = YES;
    self.planCategoryView.hidden = YES;
}

@end

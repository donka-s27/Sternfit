//
//  ProfileViewController.m
//  SternFit
//
//  Created by MacOS on 12/11/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "TrainingPlanTableViewCell.h"
#import "TrainingPlan.h"
#import "Exercise.h"
#import "DetailViewController.h"
#import "PlanCategoryTableViewCell.h"
#import "DietPlanTableViewCell.h"
#import "DietPlan.h"
#import "SupplementPlan.h"
#import "SupplementPlanTableViewCell.h"

@interface ProfileViewController () {
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

@implementation ProfileViewController

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
    if ([[defaults objectForKey:@"visibleMode"] intValue] == 2) {
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
    self.btnUploadPhoto4.hidden = NO;
    self.imgUpload4.hidden = NO;
    self.btnUploadPhoto5.hidden = NO;
    self.imgUpload5.hidden = NO;
    self.btnUploadPhoto3.hidden = NO;
    self.imgUpload3.hidden = NO;
    self.btnUploadPhoto2.hidden = NO;
    self.imgUpload2.hidden = NO;
    self.btnUploadPhoto1.hidden = NO;
    self.imgUpload1.hidden = NO;
    self.imgProfileUpload.hidden = NO;
    self.btnProfileUpload.hidden = NO;
    self.btnEditFitTab.hidden = NO;
    self.btnAdd.hidden = NO;
    
    if (appDelegate.selectOtherUser == nil) {
        if (planIndex == 0)
            tPlans = appDelegate.plans;
        else if (planIndex == 1)
            tPlans = appDelegate.dietplans;
        else if (planIndex == 2)
            tPlans = appDelegate.supplementplans;
        
        self.labelTitle.text = [self->defaults objectForKey:@"name"];
        self.labelSubtitle.text = [self->defaults objectForKey:@"quote"];
        self.labelAge.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Age", nil), [self->defaults objectForKey:@"age"]];
        double height = [[self->defaults objectForKey:@"height"] doubleValue];
        int weight = [[self->defaults objectForKey:@"weight"] intValue];
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
        
        if ([[self->defaults objectForKey:@"gender"] isEqual:@"male"]) {
            UIColor *borderColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
            self.imgProfile.layer.borderColor = borderColor.CGColor;
        } else {
            UIColor *borderColor = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:90.0f/255.0f alpha:1];
            self.imgProfile.layer.borderColor = borderColor.CGColor;
        }
        
        if ([self->defaults objectForKey:@"profile"]) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"profile.jpg"];
            
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
            [self.imgProfile setImage:image];
            
            CGRect frame = self.imgProfileUpload.frame;
            frame.origin.y = 105;
            self.imgProfileUpload.frame = frame;
            
            frame = self.btnProfileUpload.frame;
            frame.origin.y = 105;
            self.btnProfileUpload.frame = frame;
        }
        if ([self->defaults objectForKey:@"photo1"]) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"photo1.jpg"];
            
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
            [self.imgPhoto1 setImage:image];
            
            CGRect frame = self.imgPhoto1.frame;
            frame.origin.x = frame.size.width - 30;
            frame.origin.y = frame.size.height - 30;
            frame.size.width = 28;
            frame.size.height = 28;
            self.imgUpload1.frame = frame;
            
            frame = self.imgPhoto1.frame;
            frame.origin.x = frame.size.width - 40;
            frame.origin.y = frame.size.height - 40;
            frame.size.width = 40;
            frame.size.height = 40;
            self.btnUploadPhoto1.frame = frame;
        }
        
        if ([self->defaults objectForKey:@"photo2"]) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"photo2.jpg"];
            
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
            [self.imgPhoto2 setImage:image];
            
            CGRect frame = self.imgPhoto2.frame;
            frame.origin.x = frame.size.width - 30;
            frame.origin.y = frame.size.height - 30;
            frame.size.width = 28;
            frame.size.height = 28;
            self.imgUpload2.frame = frame;
            
            frame = self.imgPhoto2.frame;
            frame.origin.x = frame.size.width - 40;
            frame.origin.y = frame.size.height - 40;
            frame.size.width = 40;
            frame.size.height = 40;
            self.btnUploadPhoto2.frame = frame;
        }
        
        if ([self->defaults objectForKey:@"photo3"]) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"photo3.jpg"];
            
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
            [self.imgPhoto3 setImage:image];
            
            CGRect frame = self.imgPhoto3.frame;
            frame.origin.x = frame.size.width - 30;
            frame.origin.y = frame.size.height - 30;
            frame.size.width = 28;
            frame.size.height = 28;
            self.imgUpload3.frame = frame;
            
            frame = self.imgPhoto3.frame;
            frame.origin.x = frame.size.width - 40;
            frame.origin.y = frame.size.height - 40;
            frame.size.width = 40;
            frame.size.height = 40;
            self.btnUploadPhoto3.frame = frame;
        }
        
        if ([self->defaults objectForKey:@"photo4"]) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"photo4.jpg"];
            
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
            [self.imgPhoto4 setImage:image];
            
            CGRect frame = self.imgPhoto4.frame;
            frame.origin.x = frame.size.width - 30;
            frame.origin.y = frame.size.height - 30;
            frame.size.width = 28;
            frame.size.height = 28;
            self.imgUpload4.frame = frame;
            
            frame = self.imgPhoto4.frame;
            frame.origin.x = frame.size.width - 40;
            frame.origin.y = frame.size.height - 40;
            frame.size.width = 40;
            frame.size.height = 40;
            self.btnUploadPhoto4.frame = frame;
        }
        
        if ([self->defaults objectForKey:@"photo5"]) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"photo5.jpg"];
            
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
            [self.imgPhoto5 setImage:image];
            
            CGRect frame = self.imgPhoto5.frame;
            frame.origin.x = frame.size.width - 30;
            frame.origin.y = frame.size.height - 30;
            frame.size.width = 28;
            frame.size.height = 28;
            self.imgUpload5.frame = frame;
            
            frame = self.imgPhoto5.frame;
            frame.origin.x = frame.size.width - 40;
            frame.origin.y = frame.size.height - 40;
            frame.size.width = 40;
            frame.size.height = 40;
            self.btnUploadPhoto5.frame = frame;
        }
    } else {
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
            self.labelHeight.text = [NSString stringWithFormat:@"%@: %dm%d", NSLocalizedString(@"Height", nil), (int)height / 100, (int)height % 100];
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
        self.btnUploadPhoto4.hidden = YES;
        self.imgUpload4.hidden = YES;
        self.btnUploadPhoto5.hidden = YES;
        self.imgUpload5.hidden = YES;
        self.btnUploadPhoto3.hidden = YES;
        self.imgUpload3.hidden = YES;
        self.btnUploadPhoto2.hidden = YES;
        self.imgUpload2.hidden = YES;
        self.btnUploadPhoto1.hidden = YES;
        self.imgUpload1.hidden = YES;
        self.imgProfileUpload.hidden = YES;
        self.btnProfileUpload.hidden = YES;
        self.btnEditFitTab.hidden = YES;
        self.btnAdd.hidden = YES;
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
    [self.btnEditFitTab setTitle:NSLocalizedString(@"Edit Fit-Tab", nil) forState:UIControlStateNormal];
    self.labelTrainingPlan.text = NSLocalizedString(@"Training Plan", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPhotoUpload1Clicked:(id)sender {
    photoIndex = 1;
    bmImage = nil;
    [self.actionSheet showInView:self.view];
}

- (IBAction)btnPhotoUpload2Clicked:(id)sender {
    photoIndex = 2;
    bmImage = nil;
    [self.actionSheet showInView:self.view];
}

- (IBAction)btnPhotoUpload3Clicked:(id)sender {
    photoIndex = 3;
    bmImage = nil;
    [self.actionSheet showInView:self.view];
}
- (IBAction)btnPhotoUpload4Clicked:(id)sender {
    photoIndex = 4;
    bmImage = nil;
    [self.actionSheet showInView:self.view];
}
- (IBAction)btnPhotoUpload5Clicked:(id)sender {
    photoIndex = 5;
    bmImage = nil;
    [self.actionSheet showInView:self.view];
}

- (IBAction)btnProfilePhotoUploadClicked:(id)sender {
    photoIndex = 0;
    bmImage = nil;
    [self.actionSheet showInView:self.view];
}

- (IBAction)btnEditFitTabClicked:(id)sender {
    
    self->appDelegate.fromIndex = 2;
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditFittabViewController *controller = (EditFittabViewController *)[storyboard instantiateViewControllerWithIdentifier:@"EditFittabViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)btnAddPlanClicked:(id)sender {
    
    [defaults setObject:[NSString stringWithFormat:@"%d", selectedWeekday] forKey:@"weekday"];
    [defaults synchronize];
    
    self->appDelegate.fromIndex = 2;
    if (planIndex == 0) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CategoryViewController *controller = (CategoryViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CategoryViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (planIndex == 1) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ExerciseViewController *controller = (ExerciseViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ExerciseViewController"];
        controller.selectCatId = 8;
        controller.exerciseName = NSLocalizedString(@"Exercises", nil);
        [self.navigationController pushViewController:controller animated:YES];
    } else if (planIndex == 2) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ExerciseViewController *controller = (ExerciseViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ExerciseViewController"];
        controller.selectCatId = 9;
        controller.exerciseName = NSLocalizedString(@"Exercises", nil);
        [self.navigationController pushViewController:controller animated:YES];
    }
    
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
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:78.0f/255.0f blue:79.0f/255.0f alpha:1.0f];
        cell.selectedBackgroundView = view;
        
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
                tPlans = appDelegate.plans;
                break;
            case 1:
                tPlans = appDelegate.dietplans;
                break;
            case 2:
                tPlans = appDelegate.supplementplans;
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

- (void) changeUploadButtonPosition {
    CGRect frame;
    
    NSString *filename = @"";
   
    if (bmImage != nil) {
        switch (photoIndex) {
            case 0:
                [self.imgProfile setImage:bmImage];
                filename = @"profile.jpg";
                [self->defaults setObject:@"profile.jpg" forKey:@"profile"];
                frame = self.imgProfileUpload.frame;
                frame.origin.y = 85;
                self.imgProfileUpload.frame = frame;
                
                frame = self.btnProfileUpload.frame;
                frame.origin.y = 85;
                self.btnProfileUpload.frame = frame;
                break;
            case 1:
                [self.imgPhoto1 setImage:bmImage];
                frame = self.imgPhoto1.frame;
                frame.origin.x = frame.size.width - 30;
                frame.origin.y = frame.size.height - 30;
                frame.size.width = 28;
                frame.size.height = 28;
                self.imgUpload1.frame = frame;
                
                frame = self.imgPhoto1.frame;
                frame.origin.x = frame.size.width - 40;
                frame.origin.y = frame.size.height - 40;
                frame.size.width = 40;
                frame.size.height = 40;
                self.btnUploadPhoto1.frame = frame;
                filename = @"photo1.jpg";
                [self->defaults setObject:@"photo1.jpg" forKey:@"photo1"];
                break;
            case 2:
                [self.imgPhoto2 setImage:bmImage];
                frame = self.imgPhoto2.frame;
                frame.origin.x = frame.size.width - 30;
                frame.origin.y = frame.size.height - 30;
                frame.size.width = 28;
                frame.size.height = 28;
                self.imgUpload2.frame = frame;
                
                frame = self.imgPhoto2.frame;
                frame.origin.x = frame.size.width - 40;
                frame.origin.y = frame.size.height - 40;
                frame.size.width = 40;
                frame.size.height = 40;
                self.btnUploadPhoto2.frame = frame;
                filename = @"photo2.jpg";
                [self->defaults setObject:@"photo2.jpg" forKey:@"photo2"];
                break;
            case 3:
                [self.imgPhoto3 setImage:bmImage];
                frame = self.imgPhoto3.frame;
                frame.origin.x = frame.size.width - 30;
                frame.origin.y = frame.size.height - 30;
                frame.size.width = 28;
                frame.size.height = 28;
                self.imgUpload3.frame = frame;
                
                frame = self.imgPhoto3.frame;
                frame.origin.x = frame.size.width - 40;
                frame.origin.y = frame.size.height - 40;
                frame.size.width = 40;
                frame.size.height = 40;
                self.btnUploadPhoto3.frame = frame;
                filename = @"photo3.jpg";
                [self->defaults setObject:@"photo3.jpg" forKey:@"photo3"];
                break;
            case 4:
                [self.imgPhoto4 setImage:bmImage];
                frame = self.imgPhoto4.frame;
                frame.origin.x = frame.size.width - 30;
                frame.origin.y = frame.size.height - 30;
                frame.size.width = 28;
                frame.size.height = 28;
                self.imgUpload4.frame = frame;
                
                frame = self.imgPhoto4.frame;
                frame.origin.x = frame.size.width - 40;
                frame.origin.y = frame.size.height - 40;
                frame.size.width = 40;
                frame.size.height = 40;
                self.btnUploadPhoto4.frame = frame;
                filename = @"photo4.jpg";
                [self->defaults setObject:@"photo4.jpg" forKey:@"photo4"];
                break;
            case 5:
                [self.imgPhoto5 setImage:bmImage];
                frame = self.imgPhoto5.frame;
                frame.origin.x = frame.size.width - 30;
                frame.origin.y = frame.size.height - 30;
                frame.size.width = 28;
                frame.size.height = 28;
                self.imgUpload5.frame = frame;
                
                frame = self.imgPhoto5.frame;
                frame.origin.x = frame.size.width - 40;
                frame.origin.y = frame.size.height - 40;
                frame.size.width = 40;
                frame.size.height = 40;
                self.btnUploadPhoto5.frame = frame;
                filename = @"photo5.jpg";
                [self->defaults setObject:@"photo5.jpg" forKey:@"photo5"];
                break;
        }
	}
    
    [self->defaults synchronize];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
    [UIImagePNGRepresentation(bmImage) writeToFile:filePath atomically:YES];
    
    [self uploadImage:bmImage username:[self->defaults objectForKey:@"name"] filename:filename];
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


- (UIImage *)imageRotatedByDegrees:(UIImage*)oldImage deg:(CGFloat)degrees{
    //Calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    //Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    //Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //Rotate the image context
    CGContextRotateCTM(bitmap, (degrees * M_PI / 180));
    
    //Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    if (degrees == 180.0f)
        CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.width / 2, -oldImage.size.height / 2, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    else
        CGContextDrawImage(bitmap, CGRectMake(-oldImage.size.height / 2, -oldImage.size.width / 2, oldImage.size.height, oldImage.size.width), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)uploadImage:(UIImage*)image username:(NSString *)username filename:(NSString *)filename
{
   // [self showProgress:YES];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 90);
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, UPLOAD_IMAGE];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    // username
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"username\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[username dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // filename
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"filename\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[filename dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // image data
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           }];
    
    //[self showProgress:NO];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //if (self.imagePickerController == nil) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            [imagePickerController setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
            [imagePickerController setDelegate: self];
            imagePickerController.allowsEditing = YES;
        //}
        [self presentViewController:imagePickerController animated: YES completion:nil];
    } else if (buttonIndex == 0){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Camera" message:@"Can't use this functionality!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        

        UIImagePickerController *imagePickerCameraController = [[UIImagePickerController alloc] init];
        [imagePickerCameraController setSourceType: UIImagePickerControllerSourceTypeCamera];
        [imagePickerCameraController setDelegate: self];
        imagePickerCameraController.allowsEditing = YES;
        
        [self presentViewController:imagePickerCameraController animated: YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    bmImage = [self imageWithImage:info[UIImagePickerControllerEditedImage] scaledToSize:CGSizeMake(150, 150)];
    //[self.imgProfile setImage:bmImage];
    [self changeUploadButtonPosition];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)btnShareClicked:(id)sender {
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    appDelegate.imageFittab = img;
    
    [((MHCustomTabBarController*) self.parentViewController) showShareView];
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
            if ([self.parentViewController isKindOfClass:[MHCustomTabBarController class]]) {
                [((MHCustomTabBarController*) self.parentViewController) showImageHighlightFromOnline:filename];
            }
        }
    } else {
        NSString *filename = @"";
        
        if (recognizer.view == self.imgProfile) {
            if ([defaults objectForKey:@"profile"]) {
                filename = @"profile.jpg";
            }
        }
        if (recognizer.view == self.imgPhoto1) {
            if ([defaults objectForKey:@"photo1"]) {
                filename = @"photo1.jpg";
            }
        }
        
        if (recognizer.view == self.imgPhoto2) {
            if ([defaults objectForKey:@"photo2"]) {
                filename = @"photo2.jpg";
            }
        }
        
        if (recognizer.view == self.imgPhoto3) {
            if ([defaults objectForKey:@"photo3"]) {
                filename = @"photo3.jpg";
            }
        }
        
        if (recognizer.view == self.imgPhoto4) {
            if ([defaults objectForKey:@"photo4"]) {
                filename = @"photo4.jpg";
            }
        }
        
        if (recognizer.view == self.imgPhoto5) {
            if ([defaults objectForKey:@"photo5"]) {
                filename = @"photo5.jpg";
            }
        }
        
        if (![filename isEqual:@""]) {
            if ([self.parentViewController isKindOfClass:[MHCustomTabBarController class]]) {
                [((MHCustomTabBarController*) self.parentViewController) showImageHighlight:filename];
            }
        }
    }
}

- (void)swipeleft:(UISwipeGestureRecognizer*)recognizer {
    
    CGRect frame = recognizer.view.frame;
    if (frame.origin.x == 0) {
        ((TrainingPlanTableViewCell*)recognizer.view).btnTap.hidden = NO;
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
    if (frame.origin.x == -50) {
        ((TrainingPlanTableViewCell*)recognizer.view).btnTap.hidden = YES;
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

- (void)btnDeleteTrainingPlanClicked:(UITapGestureRecognizer*)recognizer {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Are you sure to delete training plan?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] ;
    alertView.tag = recognizer.view.tag;
    [alertView show];
    
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

- (void)swipeback:(UITapGestureRecognizer*)recognizer {
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = recognizer.view.superview.superview.frame;
                         frame.origin.x = 0;
                         recognizer.view.superview.superview.frame = frame;
                         recognizer.view.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self highlightWeekday];
    
    expandIndex = -1;
    
    [self refreshData];
    
    
    appDelegate.currentViewController = self;
    
    [self.planTableView reloadData];

    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Gallery", nil), nil];
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

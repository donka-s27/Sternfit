//
//  FilterViewController.m
//  SternFit
//
//  Created by MacOS on 1/12/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import "FilterViewController.h"
#import "AppDelegate.h"

@interface FilterViewController () {
    AppDelegate *appDelegate;
    NSUserDefaults *defaults;
}

@end

@implementation FilterViewController

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
    
    self.filterLabelTitle.font = [UIFont fontWithName:@"MyraidPro-Regular" size:17.0f];
    // Do any additional setup after loading the view.
    
    [self.filterSliderAppear setValue:1.0f];
    
    UIImage *image = [UIImage imageNamed:@"filter_progress_min.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    self.filterSliderAge.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:@"filter_progress_max.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    self.filterSliderAge.trackImage = image;
    
    image = [UIImage imageNamed:@"filter_progress_icon.png"];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 2, 1, 2)];
    self.filterSliderAge.lowerHandleImageNormal = image;
    self.filterSliderAge.upperHandleImageNormal = image;
    
    image = [UIImage imageNamed:@"filter_progress_icon.png"];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 2, 1, 2)];
    self.filterSliderAge.lowerHandleImageHighlighted = image;
    self.filterSliderAge.upperHandleImageHighlighted = image;
    
    self.filterSliderAge.backgroundColor = [UIColor clearColor];
    
    [self configureLabelSlider];
    
    
    appDelegate.rootView = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    appDelegate.currentViewController = self;
    
    self.lowerView.alpha = 0.0f;
    self.upperView.alpha = 0.0f;
    
    [self loadLabelForBottomMenu];
    
    [self updateSliderLabels];
    
    //updating values
    
    NSMutableDictionary *filters = (NSMutableDictionary*) [defaults objectForKey:@"nearby_filters"];
    if ([[filters objectForKey:@"gender"] isEqual:@"male"]) {
        [self.filterImgMale setImage:[UIImage imageNamed:@"settings_checked.png"]];
        [self.filterImgFemale setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
        [self.filterImgGenderBoth setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
        self.filterLabelGenderValue.text = @"Male";
        self.gender = @"male";
    } else if ([[filters objectForKey:@"gender"] isEqual:@"female"]) {
        [self.filterImgFemale setImage:[UIImage imageNamed:@"settings_checked.png"]];
        [self.filterImgMale setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
        [self.filterImgGenderBoth setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
        self.filterLabelGenderValue.text = @"Female";
        self.gender = @"female";
    } else {
        [self.filterImgFemale setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
        [self.filterImgMale setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
        [self.filterImgGenderBoth setImage:[UIImage imageNamed:@"settings_checked.png"]];
        self.filterLabelGenderValue.text = @"Female";
        self.gender = @"all";
    }
    
    self.filterLabelAgeValue.text = [NSString stringWithFormat:@"%@ %@ %@ %@", NSLocalizedString(@"From", nil), [filters objectForKey:@"age_start"], NSLocalizedString(@"To", nil), [filters objectForKey:@"age_end"]];
    [self.filterSliderAge setLowerValue:[[[filters objectForKey:@"age_start"] description] intValue] - 10];
    [self.filterSliderAge setUpperValue:[[[filters objectForKey:@"age_end"] description] intValue] - 10];
    self.age_start = [[filters objectForKey:@"age_start"] intValue];
    self.age_end = [[filters objectForKey:@"age_end"] intValue];
    
    self.appear_time = [[filters objectForKey:@"appear_time"] intValue];
    switch (self.appear_time) {
        case 0:
            [self.filterSliderAppear setValue:0.0f];
            self.filterLabelAppearValue.text = [NSString stringWithFormat:@"30 %@", NSLocalizedString(@"mins", nil)];
            break;
        case 1:
            [self.filterSliderAppear setValue:0.34f];
            self.filterLabelAppearValue.text = [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"hour", nil)];
            break;
        case 2:
            [self.filterSliderAppear setValue:0.68f];
            self.filterLabelAppearValue.text = [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"day", nil)];
            break;
        case 3:
            [self.filterSliderAppear setValue:1.0f];
            self.filterLabelAppearValue.text = [NSString stringWithFormat:@"3 %@s", NSLocalizedString(@"day", nil)];
            break;
    }
    
    self.distance = [[filters objectForKey:@"distance"] intValue];
    switch (self.distance) {
        case 0:
            [self.filterImg100 setImage:[UIImage imageNamed:@"settings_checked.png"]];
            [self.filterImg500 setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
            [self.filterImg1000 setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
            if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
                self.filterLabelDistanceValue.text = @"0.5 mi";
            } else {
                self.filterLabelDistanceValue.text = @"0.5 km";
            }
            break;
        case 1:
            [self.filterImg500 setImage:[UIImage imageNamed:@"settings_checked.png"]];
            [self.filterImg100 setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
            [self.filterImg1000 setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
            if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
                self.filterLabelDistanceValue.text = @"1 mile";
            } else {
                self.filterLabelDistanceValue.text = @"1 km";
            }
            break;
        case 2:
            [self.filterImg1000 setImage:[UIImage imageNamed:@"settings_checked.png"]];
            [self.filterImg500 setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
            [self.filterImg100 setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
            if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
                self.filterLabelDistanceValue.text = @"5 mi";
            } else {
                self.filterLabelDistanceValue.text = @"5 km";
            }
            break;
    }
}

- (void) loadLabelForBottomMenu {
    //filterView
    self.filterLabelTitle.text = NSLocalizedString(@"Filters", nil);
    self.filterLabelGender.text = NSLocalizedString(@"Gender", nil);
    if ([[defaults objectForKey:@"gender"] isEqual:@"male"]) {
        self.filterLabelGenderValue.text = @"Male";
    } else {
        self.filterLabelGenderValue.text = @"Female";
    }
    self.filterLabelAge.text = NSLocalizedString(@"Age", nil);
    self.filterLabelAgeValue.text = [NSString stringWithFormat:@"%@ %d %@ %d", NSLocalizedString(@"From", nil), 19, NSLocalizedString(@"To", nil), 36];
    self.filterLabelAppear.text = NSLocalizedString(@"Appear time within", nil);
    self.filterLabelAppearValue.text = [NSString stringWithFormat:@"%d %@s", 3, NSLocalizedString(@"day", nil)];
    self.filterLabelDistance.text = NSLocalizedString(@"Distance Within", nil);
    self.filterLabelDistanceValue.text = @"1000m";
    
    // filter distance
    if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
        [self.filterBtn100 setTitle:@"0.5 mi" forState:UIControlStateNormal];
        [self.filterBtn500 setTitle:@"1 mile" forState:UIControlStateNormal];
        [self.filterBtn1000 setTitle:@"5 mi" forState:UIControlStateNormal];
    } else {
        [self.filterBtn100 setTitle:@"0.5 km" forState:UIControlStateNormal];
        [self.filterBtn500 setTitle:@"1 km" forState:UIControlStateNormal];
        [self.filterBtn1000 setTitle:@"5 km" forState:UIControlStateNormal];
    }
}


- (IBAction)btnFilterMaleClicked:(id)sender {
    [self.filterImgMale setImage:[UIImage imageNamed:@"settings_checked.png"]];
    [self.filterImgFemale setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    [self.filterImgGenderBoth setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    self.filterLabelGenderValue.text = @"Male";
    self.gender = @"male";
}
- (IBAction)btnFilterFemaleClicked:(id)sender {
    [self.filterImgFemale setImage:[UIImage imageNamed:@"settings_checked.png"]];
    [self.filterImgMale setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    [self.filterImgGenderBoth setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    self.filterLabelGenderValue.text = @"Female";
    self.gender = @"female";
}
- (IBAction)btnFilterGenderBothClicked:(id)sender {
    [self.filterImgFemale setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    [self.filterImgMale setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    [self.filterImgGenderBoth setImage:[UIImage imageNamed:@"settings_checked.png"]];
    self.filterLabelGenderValue.text = @"All";
    self.gender = @"all";
}
- (IBAction)btnFilterDistance100Clicked:(id)sender {
    [self.filterImg100 setImage:[UIImage imageNamed:@"settings_checked.png"]];
    [self.filterImg500 setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    [self.filterImg1000 setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    
    
    if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
        self.filterLabelDistanceValue.text = @"0.5 mi";
    } else {
        self.filterLabelDistanceValue.text = @"0.5 km";
    }
    self.distance = 0;
}
- (IBAction)btnFilterDistance500Clicked:(id)sender {
    [self.filterImg500 setImage:[UIImage imageNamed:@"settings_checked.png"]];
    [self.filterImg100 setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    [self.filterImg1000 setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    
    if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
        self.filterLabelDistanceValue.text = @"1 mile";
    } else {
        self.filterLabelDistanceValue.text = @"1 km";
    }
    self.distance = 1;
}
- (IBAction)btnFilterDistance1000Clicked:(id)sender {
    [self.filterImg1000 setImage:[UIImage imageNamed:@"settings_checked.png"]];
    [self.filterImg500 setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    [self.filterImg100 setImage:[UIImage imageNamed:@"settings_unchecked.png"]];
    
    if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
        self.filterLabelDistanceValue.text = @"5 mi";
    } else {
        self.filterLabelDistanceValue.text = @"5 km";
    }
    self.distance = 2;
}
- (IBAction)btnFilterBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnFilterSaveClicked:(id)sender {
    
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];//(NSMutableDictionary*) [defaults objectForKey:@"nearby_filters"];
    [filters setObject:self.gender forKey:@"gender"];
    [filters setObject:[NSString stringWithFormat:@"%d", self.age_start] forKey:@"age_start"];
    [filters setObject:[NSString stringWithFormat:@"%d", self.age_end] forKey:@"age_end"];
    [filters setObject:[NSString stringWithFormat:@"%d", self.appear_time] forKey:@"appear_time"];
    [filters setObject:[NSString stringWithFormat:@"%d", self.distance] forKey:@"distance"];
    [defaults setObject:filters forKey:@"nearby_filters"];
    
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark - Label  Slider

- (void) configureLabelSlider
{
    self.filterSliderAge.minimumValue = 0;
    self.filterSliderAge.maximumValue = 80;
    
    self.filterSliderAge.lowerValue = 9;
    self.filterSliderAge.upperValue = 26;
    
    self.filterSliderAge.minimumRange = 5;
}

- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    CGPoint lowerCenter;
    lowerCenter.x = (self.filterSliderAge.lowerCenter.x + self.filterSliderAge.frame.origin.x);
    lowerCenter.y = (self.filterSliderAge.center.y - 24.0f);
    self.lowerView.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.filterSliderAge.lowerValue + 10];
    
    CGPoint upperCenter;
    upperCenter.x = (self.filterSliderAge.upperCenter.x + self.filterSliderAge.frame.origin.x);
    upperCenter.y = (self.filterSliderAge.center.y - 24.0f);
    self.upperView.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.filterSliderAge.upperValue + 10];
    self.age_start = (int) self.filterSliderAge.lowerValue + 10;
    self.age_end = (int) self.filterSliderAge.upperValue + 10;
}

// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self fadePopupViewInAndOut:YES];
    [self updateSliderLabels];
}

-(void)fadePopupViewInAndOut:(BOOL)aFadeIn {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if (aFadeIn) {
        self.lowerView.alpha = 1.0;
        self.upperView.alpha = 1.0f;
    } else {
        self.upperView.alpha = 0.0f;
        self.lowerView.alpha = 0.0f;
    }
    [UIView commitAnimations];
}


@end

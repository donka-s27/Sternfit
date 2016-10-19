//
//  EditFittabViewController.m
//  SternFit
//
//  Created by MacOS on 1/12/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import "EditFittabViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface EditFittabViewController () {
    NSString *strHeight, *strWeight;
    int selectedType;
    NSMutableArray *limits;
    
    NSUserDefaults *defaults;
    AppDelegate *appDelegate;
}

@end

@implementation EditFittabViewController

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
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    self.editLabelTitle.font = [UIFont fontWithName:@"MyraidPro-Regular" size:17.0f];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapView8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editViewTap:)];
    tapView8.delegate = self;
    [self.editView addGestureRecognizer:tapView8];
    
    limits = [[NSMutableArray alloc] init];
    NSMutableArray *limit1 = [[NSMutableArray alloc] init];
    [limit1 addObject:@"100"];
    [limit1 addObject:@"250"];
    [limits addObject:limit1];
    NSMutableArray *limit2 = [[NSMutableArray alloc] init];
    [limit2 addObject:@"4"];
    [limit2 addObject:@"8"];
    [limit2 addObject:@"0"];
    [limit2 addObject:@"11"];
    [limits addObject:limit2];
    NSMutableArray *limit3 = [[NSMutableArray alloc] init];
    [limit3 addObject:@"40"];
    [limit3 addObject:@"150"];
    [limits addObject:limit3];
    NSMutableArray *limit4 = [[NSMutableArray alloc] init];
    [limit4 addObject:@"80"];
    [limit4 addObject:@"500"];
    [limits addObject:limit4];
}

- (void) viewWillAppear:(BOOL)animated {
    
    appDelegate.currentViewController = self;
    
    [self loadLabelForBottomMenu];
    [self refreshData];
}

- (void) refreshData {
    
    
    double height = [[defaults objectForKey:@"height"] doubleValue];
    int weight = [[defaults objectForKey:@"weight"] intValue];
    if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
        strHeight = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"HEIGHT", nil), NSLocalizedString(@"feet", nil)];
        strWeight = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"WEIGHT", nil), NSLocalizedString(@"lbs", nil)];
        height = height * 0.0328084f;
        weight = (int)((double)weight * 2.20462f);
        self.editTxtHeight.text = [NSString stringWithFormat:@"%d'%d\"", (int)height, (int)(height * 10) % 10];
    } else {
        strHeight = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"HEIGHT", nil), NSLocalizedString(@"cm", nil)];
        strWeight = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"WEIGHT", nil), NSLocalizedString(@"kg", nil)];
        self.editTxtHeight.text = [NSString stringWithFormat:@"%d", (int)height];
    }
    
    self.editLabelHeight.text = strHeight;
    self.editLabelWeight.text = strWeight;
    
    self.editTxtAge.text = [defaults objectForKey:@"age"];
    self.editTxtWeight.text = [NSString stringWithFormat:@"%d", weight];
    self.editTxtQuote.text = [defaults objectForKey:@"quote"];
    
    if ([self.editTxtQuote.text isEqual:@""]) {
        self.editTxtQuote.text = NSLocalizedString(@"WRITE QUOTE", nil);
    } else {
        int length = 30 - (int)self.editTxtQuote.text.length;
        self.labelNum.text = [NSString stringWithFormat:@"%d", length];
    }
}

- (void) loadLabelForBottomMenu {
    self.editLabelTitle.text = NSLocalizedString(@"EDIT FIT-TAB", nil);
    self.editLabelAge.text = NSLocalizedString(@"AGE (year)", nil);
    self.editLabelQuote.text = NSLocalizedString(@"WRITE QUOTE", nil);
    //[self.editBtnSave setTitle:NSLocalizedString(@"SAVE", nil) forState:UIControlStateNormal];
    self.editTxtAge.text = NSLocalizedString(@"AGE (year)", nil);
    self.editTxtHeight.text = strHeight;
    self.editTxtWeight.text = strWeight;
    self.editTxtQuote.text = NSLocalizedString(@"WRITE QUOTE", nil);
    
    self.labelBottomTitle.hidden = YES;
    self.pickerView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editViewTap:(UITapGestureRecognizer*)recognizer {
    [self.editTxtAge resignFirstResponder];
    [self.editTxtHeight resignFirstResponder];
    [self.editTxtWeight resignFirstResponder];
    [self.editTxtQuote resignFirstResponder];
}

- (IBAction)btnEditBackClicked:(id)sender {
    [self.editTxtAge resignFirstResponder];
    [self.editTxtHeight resignFirstResponder];
    [self.editTxtQuote resignFirstResponder];
    [self.editTxtWeight resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)btnEditSaveClicked:(id)sender {
    [self.editTxtAge resignFirstResponder];
    [self.editTxtHeight resignFirstResponder];
    [self.editTxtQuote resignFirstResponder];
    [self.editTxtWeight resignFirstResponder];
    NSString *quote;
    double height;
    int weight;
    
    
    
    
    if (![self.editTxtQuote.text isEqual:NSLocalizedString(@"WRITE QUOTE", nil)]) {
        quote = self.editTxtQuote.text;
        quote = [quote stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [defaults setObject:self.editTxtQuote.text forKey:@"quote"];
    } else {
        quote = @"";
        [defaults setObject:@"" forKey:@"quote"];
    }
    /*
     if (![self.editTxtAge.text isEqual:NSLocalizedString(@"AGE (year)", nil)]) {
     [defaults setObject:self.editTxtAge.text forKey:@"age"];
     }*/
    
    if (![self.editTxtHeight.text isEqual:strHeight]) {
        height = [self.editTxtHeight.text doubleValue];
        if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
            height = height * 30.48f + 1;
        }
        [defaults setObject:[NSString stringWithFormat:@"%d", (int)height] forKey:@"height"];
    }
    
    if (![self.editTxtWeight.text isEqual:strWeight]) {
        weight = [self.editTxtWeight.text intValue];
        if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
            weight = (int)((double)weight * 0.453592f);
        }
        [defaults setObject:[NSString stringWithFormat:@"%d", weight] forKey:@"weight"];
    }
    
    [defaults synchronize];
    
    [self showProgress:YES];
    NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@&height=%d&weight=%d&quote=%@", SERVER_ADDRESS, UPDATE_USER, [defaults objectForKey:@"name"], (int)height, weight, quote]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
    
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [self showProgress:NO];
                               [self refreshData];
                               
                               [self.navigationController popViewControllerAnimated:YES];
                           }];
    
}

- (void) showProgress:(BOOL) flag {
    if (flag) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:true];
    }
}

#pragma - mark TextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqual:strHeight] || [textField.text isEqual:strWeight]) {
        textField.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqual:[NSString stringWithFormat:@"%d", [textField.text intValue]]]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SternFit", nil) message:NSLocalizedString(@"Please type numeric value", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        textField.text = @"";
    }
    
    if ([textField.text isEqual:@""]) {
        if (textField == self.editTxtHeight)
            textField.text = strHeight;
        else if (textField == self.editTxtWeight)
            textField.text = strWeight;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return YES;
}

#pragma - mark TextView Delegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textField
{
    if ([textField.text isEqual:NSLocalizedString(@"WRITE QUOTE", nil)]) {
        textField.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textField
{
    if ([textField.text isEqual:@""]) {
        textField.text = NSLocalizedString(@"WRITE QUOTE", nil);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqual:@""]) {
        int length = 30 - (int)self.editTxtQuote.text.length + 1;
        self.labelNum.text = [NSString stringWithFormat:@"%d", length];
        
        return YES;
    } else if ([text isEqual:@"\n"]) {
        [self.editTxtQuote resignFirstResponder];
        return NO;
    } else if ([textView.text length] == 30) {
        return NO;
    }
    
    int length = 30 - (int)self.editTxtQuote.text.length - 1;
    self.labelNum.text = [NSString stringWithFormat:@"%d", length];
    
    return YES;
}

- (BOOL)textViewShouldReturn:(UITextView *)textField
{
    
    return YES;
}

- (IBAction)btnHeightClicked:(id)sender {
    [self.editTxtQuote resignFirstResponder];
    
    if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
        selectedType = 1;
    } else {
        selectedType = 0;
    }
    self.labelBottomTitle.text = strHeight;
    [self.pickerView reloadAllComponents];
    if (selectedType == 0) {
        int index = [self.editTxtHeight.text intValue] - 100;
        [self.pickerView selectRow:index inComponent:0 animated:NO];
    } else {
        NSString *height = [[self.editTxtHeight.text stringByReplacingOccurrencesOfString:@"'" withString:@"."] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        int index1 = (int)((int)([height doubleValue] * 10) / 10) - 4;
        int index2 = (int)([height doubleValue] * 10) % 10;
        [self.pickerView selectRow:index1 inComponent:0 animated:NO];
        [self.pickerView selectRow:index2 inComponent:1 animated:NO];
    }
    
    self.labelBottomTitle.hidden = NO;
    self.pickerView.hidden = NO;
}

- (IBAction)btnWeightClicked:(id)sender {
    [self.editTxtQuote resignFirstResponder];
    
    if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
        selectedType = 3;
    } else {
        selectedType = 2;
    }
    self.labelBottomTitle.text = strWeight;
    [self.pickerView reloadAllComponents];
    if (selectedType == 2) {
        int index = [self.editTxtWeight.text intValue] - 40;
        [self.pickerView selectRow:index inComponent:0 animated:NO];
    } else {
        int index = [self.editTxtWeight.text intValue] - 80;
        [self.pickerView selectRow:index inComponent:0 animated:NO];
    }
    self.labelBottomTitle.hidden = NO;
    self.pickerView.hidden = NO;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    NSMutableArray *limit = [limits objectAtIndex:selectedType];
    if (selectedType == 0) {
        self.editTxtHeight.text = [NSString stringWithFormat:@"%d", (int)([[limit objectAtIndex:component * 2] intValue] + row)];
    } else if (selectedType == 1) {
        self.editTxtHeight.text = [NSString stringWithFormat:@"%d.%d", (int)([[limit objectAtIndex:0] intValue] + [pickerView selectedRowInComponent:0]), (int)([[limit objectAtIndex:2] intValue] + [pickerView selectedRowInComponent:1])];
    } else {
        self.editTxtWeight.text = [NSString stringWithFormat:@"%d", (int)([[limit objectAtIndex:component * 2] intValue] + row)];
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSMutableArray *limit = [limits objectAtIndex:selectedType];
    int size = [[limit objectAtIndex:component * 2 + 1] intValue] - [[limit objectAtIndex:component * 2] intValue] + 1;
    return size;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *tView = (UILabel *)view;
    if (!tView) {
        tView = [[UILabel alloc] init];
        //tView.minimumFontSize = 8.0f;
        tView.adjustsFontSizeToFitWidth = YES;
    }
    
    NSMutableArray *limit = [limits objectAtIndex:selectedType];
    tView.text = [NSString stringWithFormat:@"%d", (int)([[limit objectAtIndex:component * 2] intValue] + row)];
    tView.textAlignment = NSTextAlignmentCenter;
    
    return tView;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSMutableArray *limit = [limits objectAtIndex:selectedType];
    return [limit count] / 2;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"";
    
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    NSMutableArray *limit = [limits objectAtIndex:selectedType];
    return 285 / ([limit count] / 2);
}


@end

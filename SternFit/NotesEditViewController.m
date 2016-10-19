//
//  NotesEditViewController.m
//  SternFit
//
//  Created by MacOS on 1/10/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import "NotesEditViewController.h"
#import "AppDelegate.h"

@interface NotesEditViewController ()

@end

@implementation NotesEditViewController

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
    
    self.labelTitle.font = [UIFont fontWithName:@"MyraidPro-Regular" size:17.0f];
    // Do any additional setup after loading the view.
    
    self.labelTitle.text = NSLocalizedString(@"Edit Note", nil);
    self.labelTextNum.layer.cornerRadius = 2;
    self.labelTextNum.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapView8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editNotesTap:)];
    tapView8.delegate = self;
    [self.view addGestureRecognizer:tapView8];
    [self.view setUserInteractionEnabled:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.currentViewController = self;
    
    if ([self.notes isEqual:@""])
        self.txtNotes.text = NSLocalizedString(@"Enter Notes Here", nil);
    else {
        self.txtNotes.text = self.notes;
        int length = 150 - (int)self.txtNotes.text.length + 1;
        self.labelTextNum.text = [NSString stringWithFormat:@"%d", length];
    }
    self.txtNotes.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSaveClicked:(id)sender {
    [self.txtNotes resignFirstResponder];
    self.customParent.notes = self.notes;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editNotesTap:(UITapGestureRecognizer*)recognizer {
    [self.txtNotes resignFirstResponder];
}

#pragma - mark TextField Delegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqual:NSLocalizedString(@"Enter Notes Here", nil)])
        textView.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqual:@""]) {
        textView.text = NSLocalizedString(@"Enter Notes Here", nil);
        self.notes = @"";
    } else {
        self.notes = textView.text;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.txtNotes resignFirstResponder];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqual:@""]) {
        int length = 150 - (int)self.txtNotes.text.length + 1;
        self.labelTextNum.text = [NSString stringWithFormat:@"%d", length];
        
        return YES;
    } else if ([text isEqual:@"\n"]) {
        [self.txtNotes resignFirstResponder];
        return NO;
    } else if ([textView.text length] == 150) {
        return NO;
    }
    
    int length = 150 - (int)self.txtNotes.text.length - 1;
    self.labelTextNum.text = [NSString stringWithFormat:@"%d", length];
    
    return YES;
}


@end

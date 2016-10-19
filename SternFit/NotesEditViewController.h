//
//  NotesEditViewController.h
//  SternFit
//
//  Created by MacOS on 1/10/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface NotesEditViewController : UIViewController <UITextViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelTextNum;
@property (nonatomic, strong) IBOutlet UITextView *txtNotes;

@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) DetailViewController *customParent;

- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;

@end

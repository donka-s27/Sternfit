//
//  EditFittabViewController.h
//  SternFit
//
//  Created by MacOS on 1/12/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditFittabViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIView *editView;
@property (nonatomic, strong) IBOutlet UILabel *editLabelTitle;
@property (nonatomic, strong) IBOutlet UILabel *editLabelAge;
@property (nonatomic, strong) IBOutlet UILabel *editLabelHeight;
@property (nonatomic, strong) IBOutlet UILabel *editLabelWeight;
@property (nonatomic, strong) IBOutlet UILabel *editLabelQuote;
@property (nonatomic, strong) IBOutlet UITextField *editTxtAge;
@property (nonatomic, strong) IBOutlet UITextField *editTxtHeight;
@property (nonatomic, strong) IBOutlet UITextField *editTxtWeight;
@property (nonatomic, strong) IBOutlet UITextView *editTxtQuote;
@property (nonatomic, strong) IBOutlet UIButton *editBtnSave;
@property (nonatomic, strong) IBOutlet UIView *quoteView;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) IBOutlet UILabel *labelBottomTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelNum;

- (IBAction)btnEditBackClicked:(id)sender;
- (IBAction)btnEditSaveClicked:(id)sender;
- (IBAction)btnHeightClicked:(id)sender;
- (IBAction)btnWeightClicked:(id)sender;

@end

//
//  TourViewController.h
//  SternFit
//
//  Created by MacOS on 12/9/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TourViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UILabel *firstLabel1;
@property (nonatomic, strong) IBOutlet UILabel *firstLabel2;
@property (nonatomic, strong) IBOutlet UILabel *firstLabel3;
@property (nonatomic, strong) IBOutlet UILabel *firstLabel4;
@property (nonatomic, strong) IBOutlet UILabel *firstLabel5;
@property (nonatomic, strong) IBOutlet UILabel *firstLabel6;
@property (nonatomic, strong) IBOutlet UILabel *firstLabel7;
@property (nonatomic, strong) IBOutlet UILabel *firstLabel8;
@property (nonatomic, strong) IBOutlet UILabel *firstLabel9;
@property (nonatomic, strong) IBOutlet UILabel *secondLabe1;
@property (nonatomic, strong) IBOutlet UILabel *secondLabel2;
@property (nonatomic, strong) IBOutlet UILabel *thirdLabe1;
@property (nonatomic, strong) IBOutlet UILabel *thirdLabel2;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnStartClicked:(id)sender;

@end

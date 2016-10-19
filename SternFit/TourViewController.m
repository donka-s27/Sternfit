//
//  TourViewController.m
//  SternFit
//
//  Created by MacOS on 12/9/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "TourViewController.h"

@interface TourViewController ()

@end

@implementation TourViewController

@synthesize scrollView, firstLabel1, firstLabel2, firstLabel3, firstLabel4, firstLabel5, firstLabel6, firstLabel7, firstLabel8, firstLabel9, secondLabe1, secondLabel2, thirdLabe1, thirdLabel2, pageControl;

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
    
    firstLabel1.text = NSLocalizedString(@"FOR THOSE WHO TRAIN", nil);
    firstLabel2.text = NSLocalizedString(@"NEARBY", nil);
    firstLabel3.text = NSLocalizedString(@"CHAT", nil);
    firstLabel4.text = NSLocalizedString(@"and", nil);
    firstLabel5.text = NSLocalizedString(@"MOTIVATE", nil);
    firstLabel6.text = NSLocalizedString(@"FIT-TAB", nil);
    firstLabel7.text = NSLocalizedString(@"POST", nil);
    firstLabel8.text = NSLocalizedString(@"and", nil);
    firstLabel9.text = NSLocalizedString(@"SHARE", nil);
    secondLabe1.text = NSLocalizedString(@"Create your own Fit-Tab, share your own training plan.", nil);
    secondLabel2.text = NSLocalizedString(@"FIT-TAB", nil);
    thirdLabe1.text = NSLocalizedString(@"Motivate, and become friends with people who train near you", nil);
    thirdLabel2.text = NSLocalizedString(@"NEARBY", nil);
    
    CGRect frame = self.view.frame;
    scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 45);
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height - 45);
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnStartClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1 {
    int width = scrollView1.frame.size.width;
    float xPos = scrollView1.contentOffset.x;
    
    pageControl.currentPage = (int)xPos / width;
}

@end

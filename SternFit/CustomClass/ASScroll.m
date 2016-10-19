//
//  ASScroll.m
//  ScrollView Source control
//
//  Created by Ahmed Salah on 12/14/13.
//  Copyright (c) 2013 Ahmed Salah. All rights reserved.
//

#import "ASScroll.h"

@implementation ASScroll
@synthesize arrOfImages;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
    }
    return self;
}

-(void)setArrOfImages:(NSMutableArray *)arr{

    self.animateDirection = 1;
    
    arrOfImages = arr;
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake((98/[[UIScreen mainScreen] bounds].size.width)*self.frame.size.width,(480/[[UIScreen mainScreen] bounds].size.height)*self.frame.size.height, 122, 36);
    pageControl.numberOfPages = arrOfImages.count;
    pageControl.currentPage = 0;
    
    scrollview = [[UIScrollView alloc]initWithFrame:self.frame];
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width * arrOfImages.count,scrollview.frame.size.height);
    [scrollview setDelegate:self];
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;
    for (int i =0; i<arrOfImages.count ; i++) {
        UIImageView * imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[arrOfImages objectAtIndex:i]]];
        //[imageview setContentMode:UIViewContentModeScaleAspectFit];
        switch (i) {
            case 0:
                imageview.frame = CGRectMake(0.0, 0.0, 506.5f , scrollview.frame.size.height);
                break;
                
            case 1:
                imageview.frame = CGRectMake(-288.5f, 0.0, 608.5f , scrollview.frame.size.height);
                break;
                
            case 2:
                imageview.frame = CGRectMake(0.0, 0.0,386.5f , scrollview.frame.size.height);
                break;
                
            case 3:
                imageview.frame = CGRectMake(-143, 0.0, 463, scrollview.frame.size.height);
                break;
        }
        
        [imageview setTag:i+1];
        if (i !=0) {
            imageview.alpha = 0;
        }
        
        [self addSubview:imageview];
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    view.frame = CGRectMake(0, 0, 320, 568);
    view.alpha = 0.6f;
    
    [self addSubview:view];
    [pageControl addTarget:self
                    action:@selector(pgCntlChanged:)forControlEvents:UIControlEventValueChanged];
    //[self performSelector:@selector(startAnimatingScrl) withObject:nil afterDelay:3.0];
    
    [self initScrollView];

    [self addSubview:scrollview];
    [self addSubview:pageControl];
    
    [self startAnimation];
}

- (void) startAnimation {
    if (self.animateDirection == 0) {
        [UIView animateWithDuration:20.0f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             UIView *view1 = [self viewWithTag:1];
                             view1.frame = CGRectMake(0.0, 0.0, 506.5f , 568);
                             
                             UIView *view2 = [self viewWithTag:2];
                             view2.frame = CGRectMake(-288.5f, 0.0, 608.5f , 568);
                             
                             UIView *view3 = [self viewWithTag:3];
                             view3.frame = CGRectMake(0.0, 0.0,386.5f , 568);
                             
                             UIView *view4 = [self viewWithTag:4];
                             view4.frame = CGRectMake(-143, 0.0, 463.0f, 568);
                         }
                         completion:^(BOOL finished) {
                             if (self.animateDirection != -1) {
                                 self.animateDirection = 1;
                                 [self startAnimation];
                             }
                         }];
    } else if (self.animateDirection == 1) {
        [UIView animateWithDuration:20.0f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             UIView *view1 = [self viewWithTag:1];
                             view1.frame = CGRectMake(-186.5f, 0, 506.5f, 568);
                             
                             UIView *view2 = [self viewWithTag:2];
                             view2.frame = CGRectMake(0.0f, 0, 608.5f, 568);
                             
                             UIView *view3 = [self viewWithTag:3];
                             view3.frame = CGRectMake(-66.5f, 0, 386.5f, 568);
                             
                             UIView *view4 = [self viewWithTag:4];
                             view4.frame = CGRectMake(0.0f, 0, 463.0f, 568);
                         }
                         completion:^(BOOL finished) {
                             if (self.animateDirection != -1) {
                                 self.animateDirection = 0;
                                 [self startAnimation];
                             }
                         }];
    } else {
    }
}

- (void) initScrollView {
    UIView *view1 = [[UIView alloc] init];
    view1.frame = CGRectMake(0, 0, 320, 568);
    
    UIImageView *imageViewLogo = [[UIImageView alloc] init];
    [imageViewLogo setImage:[UIImage imageNamed:@"initial_logo.png"]];
    CGRect frame = CGRectMake(80, 187, 161, 106);
    imageViewLogo.frame = frame;
    [view1 addSubview:imageViewLogo];
    
    UIImageView *imageViewLogo1 = [[UIImageView alloc] init];
    [imageViewLogo1 setImage:[UIImage imageNamed:@"launch_logo.png"]];
    frame = CGRectMake(135, 187, 50, 72);
    imageViewLogo1.frame = frame;
    [view1 addSubview:imageViewLogo1];
    
    [scrollview addSubview:view1];
    
    // view 2
    UIView *view2 = [[UIView alloc] init];
    view2.frame = CGRectMake(320, 0, 320, 568);
    
    UIImageView *imageViewLogo3 = [[UIImageView alloc] init];
    [imageViewLogo3 setImage:[UIImage imageNamed:@"launch_logo.png"]];
    imageViewLogo3.frame = frame;
    [view2 addSubview:imageViewLogo3];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(20, frame.origin.y + frame.size.height + 10, 280, 30);
    label1.font = [UIFont fontWithName:@"MyriadPro-Regular" size:22.0f];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    label1.text = @"Search + Chat = Motivate";
    [view2 addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(20, frame.origin.y + frame.size.height + 40, 280, 100);
    label2.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    label2.text = @"Search people who train near you, become friends with them and motivate each other on this journey of forging a better self.";
    label2.numberOfLines = -1;
    [view2 addSubview:label2];
    
    [scrollview addSubview:view2];
    
    // view 3
    UIView *view3 = [[UIView alloc] init];
    view3.frame = CGRectMake(640, 0, 320, 568);
    
    UIImageView *imageViewLogo4 = [[UIImageView alloc] init];
    [imageViewLogo4 setImage:[UIImage imageNamed:@"launch_logo.png"]];
    imageViewLogo4.frame = frame;
    [view3 addSubview:imageViewLogo4];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(20, frame.origin.y + frame.size.height + 10, 280, 30);
    label3.font = [UIFont fontWithName:@"MyriadPro-Regular" size:22.0f];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor whiteColor];
    label3.text = @"Create + Share = Inspire";
    [view3 addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.frame = CGRectMake(20, frame.origin.y + frame.size.height + 40, 280, 100);
    label4.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.textColor = [UIColor whiteColor];
    label4.text = @"Create your own Fit-Tab and share you and your friend’s customized training/diet/supplement plan, inspire others with your dedication to greatness.";
    label4.numberOfLines = -1;
    [view3 addSubview:label4];
    
    [scrollview addSubview:view3];
    
    // view 4
    UIView *view4 = [[UIView alloc] init];
    view4.frame = CGRectMake(960, 0, 320, 568);
    
    UIImageView *imageViewLogo5 = [[UIImageView alloc] init];
    [imageViewLogo5 setImage:[UIImage imageNamed:@"launch_logo.png"]];
    imageViewLogo5.frame = frame;
    [view4 addSubview:imageViewLogo5];
    
    UILabel *label5 = [[UILabel alloc] init];
    label5.frame = CGRectMake(20, frame.origin.y + frame.size.height + 10, 280, 30);
    label5.font = [UIFont fontWithName:@"MyriadPro-Regular" size:22.0f];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.textColor = [UIColor whiteColor];
    label5.text = @"Gather + Decipher = Upgrade ";
    [view4 addSubview:label5];
    
    UILabel *label6 = [[UILabel alloc] init];
    label6.frame = CGRectMake(20, frame.origin.y + frame.size.height + 40, 280, 100);
    label6.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    label6.textAlignment = NSTextAlignmentCenter;
    label6.textColor = [UIColor whiteColor];
    label6.text = @"Add your gym friends into the group chat and discuss everything related with improving your training, together.";
    label6.numberOfLines = -1;
    [view4 addSubview:label6];
    
    [scrollview addSubview:view4];
}

- (void)startAnimatingScrl
{
    if (arrOfImages.count) {
        [scrollview scrollRectToVisible:CGRectMake(((pageControl.currentPage +1)%arrOfImages.count)*scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height) animated:YES];
        [pageControl setCurrentPage:((pageControl.currentPage +1)%arrOfImages.count)];
        [self performSelector:@selector(startAnimatingScrl) withObject:nil  afterDelay:3.0];
    }
}
-(void) cancelScrollAnimation{
    didEndAnimate =YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAnimatingScrl) object:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self cancelScrollAnimation];
    previousTouchPoint = scrollView.contentOffset.x;
}

- (IBAction)pgCntlChanged:(UIPageControl *)sender {
    [scrollview scrollRectToVisible:CGRectMake(sender.currentPage*scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height) animated:YES];
    [self cancelScrollAnimation];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [pageControl setCurrentPage:scrollview.bounds.origin.x/scrollview.frame.size.width];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
    
    int page = floor((scrollView.contentOffset.x - 320) / 320) + 1;
    float OldMin = 320*page;
    int Value = scrollView.contentOffset.x -OldMin;
    float alpha = (Value% 320) / 320.f;
    
    
    if (previousTouchPoint > scrollView.contentOffset.x)
        page = page+2;
    else
        page = page+1;

    UIView *nextPage = [scrollView.superview viewWithTag:page+1];
    UIView *previousPage = [scrollView.superview viewWithTag:page-1];
    UIView *currentPage = [scrollView.superview viewWithTag:page];
    
    if(previousTouchPoint <= scrollView.contentOffset.x){
        if ([currentPage isKindOfClass:[UIImageView class]])
            currentPage.alpha = 1-alpha;
        if ([nextPage isKindOfClass:[UIImageView class]])
            nextPage.alpha = alpha;
        if ([previousPage isKindOfClass:[UIImageView class]])
            previousPage.alpha = 0;
    }else if(page != 0){
        if ([currentPage isKindOfClass:[UIImageView class]])
            currentPage.alpha = alpha;
        if ([nextPage isKindOfClass:[UIImageView class]])
            nextPage.alpha = 0;
        if ([previousPage isKindOfClass:[UIImageView class]])
            previousPage.alpha = 1-alpha;
    }
    if (!didEndAnimate && pageControl.currentPage == 0) {
        for (UIView * imageView in self.subviews){
            if (imageView.tag !=1 && [imageView isKindOfClass:[UIImageView class]])
                imageView.alpha = 0;
            else if([imageView isKindOfClass:[UIImageView class]])
                imageView.alpha = 1 ;
        }
    }
}

-(void)dealloc{
    [self cancelScrollAnimation];
}

@end

/*
 * Copyright (c) 2013 Martin Hartl
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

extern NSString *const MHCustomTabBarControllerViewControllerChangedNotification;
extern NSString *const MHCustomTabBarControllerViewControllerAlreadyVisibleNotification;

@interface MHCustomTabBarController : UIViewController <UIGestureRecognizerDelegate>

@property (weak,nonatomic) UIViewController *destinationViewController;
@property (strong, nonatomic) NSString *destinationIdentifier;
@property (strong, nonatomic) UIViewController *oldViewController;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

// bottom menu
@property (nonatomic, strong) IBOutlet UILabel *labelNearby;
@property (nonatomic, strong) IBOutlet UILabel *labelMessage;
@property (nonatomic, strong) IBOutlet UILabel *labelMessageNum;
@property (nonatomic, strong) IBOutlet UILabel *labelFittab;
@property (nonatomic, strong) IBOutlet UILabel *labelNotification;
@property (nonatomic, strong) IBOutlet UILabel *labelNotificationNum;
@property (nonatomic, strong) IBOutlet UILabel *labelExtramenu;
@property (nonatomic, strong) IBOutlet UIView *view1;
@property (nonatomic, strong) IBOutlet UIView *view2;
@property (nonatomic, strong) IBOutlet UIView *view3;
@property (nonatomic, strong) IBOutlet UIView *view4;
@property (nonatomic, strong) IBOutlet UIView *view5;
@property (nonatomic, strong) IBOutlet UIImageView *imgNearby;
@property (nonatomic, strong) IBOutlet UIImageView *imgMessage;
@property (nonatomic, strong) IBOutlet UIImageView *imgFit;
@property (nonatomic, strong) IBOutlet UIImageView *imgNotification;
@property (nonatomic, strong) IBOutlet UIImageView *imgExtra;

@property (nonatomic, strong) IBOutlet UIView *navView;
@property (nonatomic, strong) IBOutlet UIView *overlayView;
@property (nonatomic, strong) IBOutlet UIView *shareView;


//image highlight
@property (nonatomic, strong) IBOutlet UIView *overlayImageView;
@property (nonatomic, strong) IBOutlet UIView *imageContainerView;
@property (nonatomic, strong) IBOutlet AsyncImageView *imageHighlight;

-(IBAction)clickCoupons:(id)sender;

- (void) hideSideMenu;
- (void) moveToStartGroupViewController;
- (void) moveToExerciseViewController;
- (void) moveToTrainingViewController;
- (void) moveFromStartGroupViewController;
- (void) showImageHighlight:(NSString*) filename;
- (void) showImageHighlightFromOnline:(NSString*) filename;
- (void) moveToFittab;
- (void) updateNotificationNum:(int) num;
- (void) updateMessageNum:(int) num;

- (void) showShareView;
- (void) hideShareView;

@end

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

#import "MHCustomTabBarController.h"
#import "MHTabBarSegue.h"
#import "SideMenuViewController.h"
#import "AppDelegate.h"

NSString *const MHCustomTabBarControllerViewControllerChangedNotification = @"MHCustomTabBarControllerViewControllerChangedNotification";
NSString *const MHCustomTabBarControllerViewControllerAlreadyVisibleNotification = @"MHCustomTabBarControllerViewControllerAlreadyVisibleNotification";

@implementation MHCustomTabBarController {
    NSMutableDictionary *_viewControllersByIdentifier;
    int prevHighlight;
    AppDelegate *appDelegate;
    NSUserDefaults *defaults;
}

@synthesize labelExtramenu, labelFittab, labelMessage, labelMessageNum, labelNearby, labelNotification, labelNotificationNum, view1, view2, view3, view4, view5;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    defaults = [NSUserDefaults standardUserDefaults];
    
    _viewControllersByIdentifier = [NSMutableDictionary dictionary];
    
    labelNearby.text = NSLocalizedString(@"Nearby", nil);
    labelMessage.text = NSLocalizedString(@"Messages", nil);
    labelFittab.text = NSLocalizedString(@"Fit-tab", nil);
    labelNotification.text = NSLocalizedString(@"Notifications", nil);
    labelExtramenu.text = NSLocalizedString(@"Extra menu", nil);
    
    //[self performSegueWithIdentifier:@"viewController1" sender:[self.buttons objectAtIndex:0]];
    
    [self changeHighlight:0];
    
    UITapGestureRecognizer *tapView3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(overlayImageViewTap:)];
    tapView3.delegate = self;
    [self.overlayImageView addGestureRecognizer:tapView3];
    
    UIColor *borderColor = [UIColor whiteColor];
    self.labelNotificationNum.layer.borderColor = borderColor.CGColor;
    self.labelNotificationNum.layer.borderWidth = 1.0f;
    self.labelNotificationNum.layer.cornerRadius = 7.5f;
    self.labelNotificationNum.layer.masksToBounds = YES;
    
    self.labelNotificationNum.text = @"0";
    self.labelNotificationNum.hidden = YES;
    
    self.labelMessageNum.layer.borderColor = borderColor.CGColor;
    self.labelMessageNum.layer.borderWidth = 1.0f;
    self.labelMessageNum.layer.cornerRadius = 7.5f;
    self.labelMessageNum.layer.masksToBounds = YES;
    
    self.labelMessageNum.text = @"0";
    self.labelMessageNum.hidden = YES;
    
    appDelegate.tabBarController = self;
}

- (void) viewWillAppear:(BOOL)animated {
    self.shareView.hidden = YES;
    
    
    if (appDelegate.tabIndex == 2) {
        [self performSegueWithIdentifier:@"viewController3" sender:[self.buttons objectAtIndex:0]];
        [self changeHighlight:2];
        appDelegate.fromIndex = 0;
        return;
    }
    
    if (appDelegate.fromIndex == 2) {
        [self performSegueWithIdentifier:@"viewController3" sender:[self.buttons objectAtIndex:0]];
        [self changeHighlight:2];
        appDelegate.fromIndex = 0;
    } else if (appDelegate.fromIndex == 1) {
        [self performSegueWithIdentifier:@"viewController2" sender:[self.buttons objectAtIndex:0]];
        [self changeHighlight:1];
        appDelegate.tabIndex = 1;
        appDelegate.fromIndex = 0;
    } else if (appDelegate.fromIndex == 3) {
        [self performSegueWithIdentifier:@"viewController4" sender:[self.buttons objectAtIndex:0]];
        [self changeHighlight:3];
        appDelegate.tabIndex = 3;
        appDelegate.fromIndex = 0;
    } else if (appDelegate.fromIndex == 13) {
        [self performSegueWithIdentifier:@"sharedFittabController" sender:[self.buttons objectAtIndex:0]];
        [self changeHighlight:5];
        appDelegate.tabIndex = 13;
        appDelegate.fromIndex = 0;
    } else if (appDelegate.tabIndex == 4) {
        [self performSegueWithIdentifier:@"friendViewController" sender:[self.buttons objectAtIndex:0]];
        [self changeHighlight:5];
        appDelegate.tabIndex = 4;
        appDelegate.fromIndex = 0;
    } else {
        [self performSegueWithIdentifier:@"viewController1" sender:[self.buttons objectAtIndex:0]];
        [self changeHighlight:0];
    }
    
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.destinationViewController.view.frame = self.container.bounds;
}

-(IBAction)clickCoupons:(id)sender{
    [self performSegueWithIdentifier:@"viewController1" sender:[self.buttons objectAtIndex:0]];
}

- (IBAction)btnNearbyClicked:(id)sender {
    
    appDelegate.tabIndex = 0;
    appDelegate.selectOtherUser = nil;
    [self performSegueWithIdentifier:@"viewController1" sender:[self.buttons objectAtIndex:0]];
    [self changeHighlight:0];
}

- (IBAction)btnMessageClicked:(id)sender {
    
    appDelegate.tabIndex = 1;
    [self performSegueWithIdentifier:@"viewController2" sender:[self.buttons objectAtIndex:0]];
    [self changeHighlight:1];
}

- (IBAction)btnFittabClicked:(id)sender {
    
    appDelegate.tabIndex = 2;
    appDelegate.selectOtherUser = nil;
    [self performSegueWithIdentifier:@"viewController3" sender:[self.buttons objectAtIndex:0]];
    [self changeHighlight:2];
}

- (IBAction)btnNotitficationClicked:(id)sender {
    
    appDelegate.tabIndex = 3;
    [self performSegueWithIdentifier:@"viewController4" sender:[self.buttons objectAtIndex:0]];
    [self changeHighlight:3];
}

- (IBAction)btnExtramenuClicked:(id)sender {
    [self changeHighlight:4];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SideMenuViewController *controller = (SideMenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
    
    [self.navView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
    [self addChildViewController:controller];
    
    CGRect frame1 = self.overlayView.frame;
    frame1.origin.x = 0;
    self.overlayView.frame = frame1;
    self.overlayView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.overlayView.alpha = 0.7f;
                         CGRect frame = self.navView.frame;
                         frame.origin.x = -160;
                         self.navView.frame = frame;
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    controller.parentViewController = self;
}

- (IBAction)btnHideSideMenuClicked:(id)sender {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.overlayView.alpha = 0.0f;
                         CGRect frame = self.overlayView.frame;
                         frame.origin.x = -320;
                         self.navView.frame = frame;
                         
                     }
                     completion:^(BOOL finished) {
                         CGRect frame = self.overlayView.frame;
                         frame.origin.x = -320;
                         self.overlayView.frame = frame;
                         
                         NSArray *views = [self.navView subviews];
                         for (int i = 0; i < [views count]; i++) {
                             UIView *view = (UIView*) [views objectAtIndex:i];
//                             [view removeFromSuperview];
                             [view setHidden:YES];
//                             CGRect frame = view.frame;
//                             frame.origin.x = 320;
//                             [view setFrame:frame];
                         }
                         
                         [self changeHighlight:prevHighlight];
                     }];
}

- (void) hideSideMenu {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.overlayView.alpha = 0.0f;
                         CGRect frame = self.overlayView.frame;
                         frame.origin.x = -320;
                         self.navView.frame = frame;
                         
                     }
                     completion:^(BOOL finished) {
                         CGRect frame = self.overlayView.frame;
                         frame.origin.x = -320;
                         self.overlayView.frame = frame;
                         
                         NSArray *views = [self.navView subviews];
                         for (int i = 0; i < [views count]; i++) {
                             UIView *view = (UIView*) [views objectAtIndex:i];
                             [view setHidden:YES];
//                             [view removeFromSuperview];
                         }
                         
                         if (appDelegate.tabIndex == 7) {
                             //appDelegate.currentUser = nil;
                             
                             
                             NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?username=%@&status=0", SERVER_ADDRESS, UPDATE_USER, [defaults objectForKey:@"name"]]];
                             NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:360];
                             
                             [request setHTTPMethod:@"POST"];
                             
                             [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                              
                                                    completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                        [defaults setObject:@"0" forKey:@"isLogin"];
                                                        [defaults synchronize];
                                                        
                                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                                        
                                                    }];
                         }
                         
                         if (appDelegate.tabIndex == 4) {
                             [self performSegueWithIdentifier:@"friendViewController" sender:[self.buttons objectAtIndex:0]];
                             [self changeHighlight:5];
                         }
                         
                         if (appDelegate.tabIndex == 5) { // Training plan
                             [self performSegueWithIdentifier:@"trainingViewController" sender:[self.buttons objectAtIndex:0]];
                             [self changeHighlight:5];
//                             UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                             TrainingViewController *controller = (TrainingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"TrainingViewController"];
//                             [self.navigationController pushViewController:controller animated:YES];
//                             appDelegate.tabIndex = 0;
                         }
                         
                         if (appDelegate.tabIndex == 15) { // Diet plan
                             [self performSegueWithIdentifier:@"trainingViewController" sender:[self.buttons objectAtIndex:0]];
                              [self changeHighlight:5];
//                             UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                             DietPlanViewController *controller = (DietPlanViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DietPlanViewController"];
//                             [self.navigationController pushViewController:controller animated:YES];
//                             appDelegate.tabIndex = 0;
                         }
                         
                         if (appDelegate.tabIndex == 16) { // Supplement Plan
                             [self performSegueWithIdentifier:@"trainingViewController" sender:[self.buttons objectAtIndex:0]];
                              [self changeHighlight:5];
//                             UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                             SupplementPlanViewController *controller = (SupplementPlanViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SupplementPlanViewController"];
//                             [self.navigationController pushViewController:controller animated:YES];
//                             appDelegate.tabIndex = 0;
                         }
                         
                         if (appDelegate.tabIndex == 6) {
                             [self performSegueWithIdentifier:@"settingsViewController" sender:[self.buttons objectAtIndex:0]];
                             [self changeHighlight:5];
//                             UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                             SettingsViewController *controller = (SettingsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
//                             [self.navigationController pushViewController:controller animated:YES];
                             appDelegate.tabIndex = 0;
                         }
                         
                         if (appDelegate.tabIndex == 8) {
                             [self performSegueWithIdentifier:@"viewController3" sender:[self.buttons objectAtIndex:0]];
                             [self changeHighlight:5];
                         }
                         
                         if (appDelegate.tabIndex == 13) {
                             [self performSegueWithIdentifier:@"sharedFittabController" sender:[self.buttons objectAtIndex:0]];
                             [self changeHighlight:5];
                         }
                     }];
}

- (void) moveToStartGroupViewController {
    [self performSegueWithIdentifier:@"startGroupViewController" sender:[self.buttons objectAtIndex:0]];
    [self changeHighlight:5];
}

- (void) moveToFittab {
    [self performSegueWithIdentifier:@"viewController3" sender:[self.buttons objectAtIndex:0]];
    [self changeHighlight:2];
    /*UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileViewController *controller = (ProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self.navigationController pushViewController:controller animated:YES];*/
}

- (void) moveToExerciseViewController {
    [self performSegueWithIdentifier:@"exerciseViewController" sender:[self.buttons objectAtIndex:0]];
    [self changeHighlight:5];
}
- (void) moveToTrainingViewController {
    
    if (appDelegate.fromIndex == 2) {
        [self performSegueWithIdentifier:@"viewController3" sender:[self.buttons objectAtIndex:0]];
        [self changeHighlight:2];
    } else if (appDelegate.fromIndex == 3) {
        [self performSegueWithIdentifier:@"trainingViewController" sender:[self.buttons objectAtIndex:0]];
        [self changeHighlight:5];
    }
    
}

- (void) moveFromStartGroupViewController {
    
    if (appDelegate.fromIndex == 0) {
        [self performSegueWithIdentifier:@"viewController2" sender:[self.buttons objectAtIndex:0]];
        [self changeHighlight:1];
    } else if (appDelegate.fromIndex == 1) {
        [self performSegueWithIdentifier:@"friendViewController" sender:[self.buttons objectAtIndex:0]];
        [self changeHighlight:5];
    }
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![segue isKindOfClass:[MHTabBarSegue class]]) {
        [super prepareForSegue:segue sender:sender];
        return;
    }
    
    self.oldViewController = self.destinationViewController;
    
    //if view controller isn't already contained in the viewControllers-Dictionary
    if (![_viewControllersByIdentifier objectForKey:segue.identifier]) {
        [_viewControllersByIdentifier setObject:segue.destinationViewController forKey:segue.identifier];
    }
    
    for (UIButton *aButton in self.buttons) {
        [aButton setSelected:NO];
    }
        
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    self.destinationIdentifier = segue.identifier;
    self.destinationViewController = [_viewControllersByIdentifier objectForKey:self.destinationIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MHCustomTabBarControllerViewControllerChangedNotification object:nil]; 

    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.destinationIdentifier isEqual:identifier]) {
        //Dont perform segue, if visible ViewController is already the destination ViewController
        [[NSNotificationCenter defaultCenter] postNotificationName:MHCustomTabBarControllerViewControllerAlreadyVisibleNotification object:nil];
        return NO;
    }
    
    return YES;
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [[_viewControllersByIdentifier allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if (![self.destinationIdentifier isEqualToString:key]) {
            [_viewControllersByIdentifier removeObjectForKey:key];
        }
    }];
}

- (void) showImageHighlight:(NSString*) filename {
    

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
    
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
    [self.imageHighlight setImage:image];
    
    self.overlayImageView.hidden = NO;
    self.imageContainerView.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayImageView.alpha = 0.6f;
                         self.imageContainerView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void) showImageHighlightFromOnline:(NSString *)filename {
    
    
    [self.imageHighlight setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.imageHighlight setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, filename]]];

    self.overlayImageView.hidden = NO;
    self.imageContainerView.hidden = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayImageView.alpha = 0.6f;
                         self.imageContainerView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)overlayImageViewTap:(UITapGestureRecognizer*)recognizer {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayImageView.alpha = 0.0f;
                         self.imageContainerView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.overlayImageView.hidden = YES;
                         self.imageContainerView.hidden = YES;
                         [self.imageHighlight setImage:nil];
                     }];
}

- (void) changeHighlight:(int) index {
    if (index != 4)
        prevHighlight = index;
    view4.backgroundColor = [UIColor clearColor];
    view1.backgroundColor = [UIColor clearColor];
    view3.backgroundColor = [UIColor clearColor];
    view2.backgroundColor = [UIColor clearColor];
    view5.backgroundColor = [UIColor clearColor];
    [self.imgNearby setImage:[UIImage imageNamed:@"bottom_menu_nearby.png"]];
    [self.imgMessage setImage:[UIImage imageNamed:@"bottom_menu_message.png"]];
    [self.imgFit setImage:[UIImage imageNamed:@"bottom_menu_fit.png"]];
    [self.imgNotification setImage:[UIImage imageNamed:@"bottom_menu_notification.png"]];
    [self.imgExtra setImage:[UIImage imageNamed:@"bottom_menu_extra.png"]];
    switch (index) {
        case 0:
            view1.backgroundColor = [UIColor blackColor];
            [self.imgNearby setImage:[UIImage imageNamed:@"bottom_menu_nearby_highlight.png"]];
            break;
        case 1:
            view2.backgroundColor = [UIColor blackColor];
            [self.imgMessage setImage:[UIImage imageNamed:@"bottom_menu_message_highlight.png"]];
            break;
        case 2:
            view3.backgroundColor = [UIColor blackColor];
            [self.imgFit setImage:[UIImage imageNamed:@"bottom_menu_fit_highlight.png"]];
            break;
        case 3:
            view4.backgroundColor = [UIColor blackColor];
            [self.imgNotification setImage:[UIImage imageNamed:@"bottom_menu_notification_highlight.png"]];
            break;
        case 4:
            view5.backgroundColor = [UIColor blackColor];
            [self.imgExtra setImage:[UIImage imageNamed:@"bottom_menu_extra_highlight.png"]];
            break;
    }
}

- (void) updateNotificationNum:(int) num {
    if (num == 0) {
        self.labelNotificationNum.text = @"0";
        self.labelNotificationNum.hidden = YES;
    } else {
        self.labelNotificationNum.hidden = NO;
        self.labelNotificationNum.text = [NSString stringWithFormat:@"%d", num];
    }
}

- (void) updateMessageNum:(int) num {
    if (num == 0) {
        self.labelMessageNum.text = @"0";
        self.labelMessageNum.hidden = YES;
    } else {
        self.labelMessageNum.hidden = NO;
        self.labelMessageNum.text = [NSString stringWithFormat:@"%d", num];
        if (num > 100) {
            CGRect frame = self.labelMessageNum.frame;
            frame.size.width = 27.0f;
            self.labelMessageNum.frame = frame;
        } else if (num > 10) {
            CGRect frame = self.labelMessageNum.frame;
            frame.size.width = 20.0f;
            self.labelMessageNum.frame = frame;
        }
        
    }
}

- (void) showShareView {
    self.overlayImageView.alpha = 0.0f;
    self.shareView.alpha = 0.0f;
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SharePopupViewController *controller = (SharePopupViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SharePopupViewController"];
    controller.tabBarController = self;
    controller.parentViewController = nil;
    controller.otherProfileController = nil;
    
    
    controller.content = NSLocalizedString(@"I just shared my Fit-Tab on SternFit, check it out: ", nil);
    
    [self.shareView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
    [self addChildViewController:controller];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.shareView.hidden = NO;
                         self.overlayImageView.hidden = NO;
                         self.overlayImageView.alpha = 0.7f;
                         self.shareView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (void) hideShareView {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.overlayImageView.alpha = 0.0f;
                         self.shareView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         self.shareView.hidden = YES;
                         self.overlayImageView.hidden = YES;
                     }];
}

@end

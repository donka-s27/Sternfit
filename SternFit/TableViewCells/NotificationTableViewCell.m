//
//  NotificationTableViewself.m
//  SternFit
//
//  Created by MacOS on 12/18/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "AppDelegate.h"

@implementation NotificationTableViewCell {
    AppDelegate *appDelegate;
    BOOL isShare;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(NSMutableDictionary *)user {
    self.labelName.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    self.labelMessage.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13.0f];
    self.labelTime.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13.0f];
    
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    if ([[user objectForKey:@"image"] isEqual:@""]) {
        [self.imgAvator setImage:[UIImage imageNamed:@"avator.png"]];
    } else {
        [self.imgAvator setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.imgAvator setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, [user objectForKey:@"image"]]]];
    }
    UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    self.imgAvator.layer.borderColor = borderColor.CGColor;
    self.imgAvator.layer.borderWidth = 3.0f;
    self.imgAvator.layer.cornerRadius = 30.0f;
    self.imgAvator.layer.masksToBounds = YES;
    //self.imgAvator.frame = CGRectMake(20, 10, 60, 60);
    if ([[user objectForKey:@"gender"] isEqual:@"male"]) {
        UIColor *borderColor1 = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
        self.imgAvator.layer.borderColor = borderColor1.CGColor;
    } else {
        UIColor *borderColor1 = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:90.0f/255.0f alpha:1];
        self.imgAvator.layer.borderColor = borderColor1.CGColor;
    }
    
    self.labelStatus.layer.borderColor = borderColor.CGColor;
    self.labelStatus.layer.borderWidth = 2.0f;
    self.labelStatus.layer.cornerRadius = 7.5f;
    if ([[user objectForKey:@"onlinestatus"] isEqual:@"0"]) {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
    } else {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:227.0f/255.0f blue:54.0f/255.0f alpha:1];
    }
    
    
    
    self.btnTap.hidden = NO;
    if ([[user objectForKey:@"friendrequest"] isEqual:@"1"]) {
        self.labelName.text = [user objectForKey:@"name"];
        self.labelMessage.text = [NSString stringWithFormat:@"%@ %@", [user objectForKey:@"name"], NSLocalizedString(@"has sent you a friend request", nil)];
        self.labelTime.text = [self getShareTime:[user objectForKey:@"sharetime"]];//[NSString stringWithFormat:@"%@/%@/%@", [[user objectForKey:@"sharetime"] substringWithRange:NSMakeRange(5, 2)], [[user objectForKey:@"sharetime"] substringWithRange:NSMakeRange(8, 2)], [[user objectForKey:@"sharetime"] substringToIndex:4]];
        CGRect frame = self.btnTap.frame;
        frame.size.width = 230;
        self.btnTap.frame = frame;
        if ([[user objectForKey:@"status"] intValue] == 2) {
            self.btnAccept.hidden = YES;
            self.btnDecline.hidden = YES;
            self.btnAddFriend.hidden = NO;
            self.labelMessage.text = NSLocalizedString(@"Request has been declined", nil);
            frame.size.width = 270;
            self.btnTap.frame = frame;
        } else if ([[user objectForKey:@"status"] intValue] == 3) {
            self.btnAccept.hidden = YES;
            self.btnDecline.hidden = YES;
            self.btnAddFriend.hidden = NO;
            [self.btnAddFriend setBackgroundImage:[UIImage imageNamed:@"friends_chat.png"] forState:UIControlStateNormal];
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"%@ has become friends with you.", nil), [user objectForKey:@"name"]];
            self.labelMessage.text = message;
            frame.size.width = 270;
            self.btnTap.frame = frame;
        }
        isShare = NO;
    } else {
        self.labelName.text = [user objectForKey:@"name"];
        self.labelMessage.text = NSLocalizedString(@"Shared your Fit-Tab", nil);
        self.labelTime.text = [self getShareTime:[user objectForKey:@"sharetime"]];//[NSString stringWithFormat:@"%@/%@/%@", [[user objectForKey:@"sharetime"] substringWithRange:NSMakeRange(5, 2)], [[user objectForKey:@"sharetime"] substringWithRange:NSMakeRange(8, 2)], [[user objectForKey:@"sharetime"] substringToIndex:4]];
        self.btnAccept.hidden = YES;
        self.btnDecline.hidden = YES;
        
        isShare = YES;
    }
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swiperight];
}

- (NSString *) getShareTime:(NSString *)sharetime {
    //long secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
    
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *dateFromString3 = [[NSDate alloc] init];
    dateFromString3 = [dateFormatter3 dateFromString:sharetime];
    dateFromString3 = [NSDate dateWithTimeIntervalSince1970:[dateFromString3 timeIntervalSince1970]];// + secondsFromGMT];
    
    sharetime = [sharetime substringToIndex:10];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    
    dateFromString = [dateFormatter dateFromString:sharetime];
    dateFromString = [NSDate dateWithTimeIntervalSince1970:[dateFromString timeIntervalSince1970]];// + secondsFromGMT];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *stringDate = [dateFormatter1 stringFromDate:[NSDate date]];
    
    currentDate = [dateFormatter dateFromString:stringDate];
    
    if ([dateFromString timeIntervalSince1970] == [currentDate timeIntervalSince1970]) {
        NSDateFormatter *dateFormatter4 = [[NSDateFormatter alloc] init];
        [dateFormatter4 setDateFormat:@"hh:mm a"];
        NSString *stringDate = [dateFormatter4 stringFromDate:dateFromString3];
        
        return stringDate;
    } else if ([dateFromString timeIntervalSince1970] == ([currentDate timeIntervalSince1970] - 86400))
        return @"Yesterday";
    else {
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"dd/MM/yyyy"];
        
        return [dateFormatter2 stringFromDate:dateFromString];
    }
    
    return @"";
}


- (void)swipeleft:(UISwipeGestureRecognizer*)recognizer {
    
    CGRect frame = recognizer.view.frame;
    if (frame.origin.x == 0) {
        if (isShare)
            self.btnTap.hidden = NO;
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = recognizer.view.frame;
                             recognizer.view.frame = CGRectMake(-50, frame.origin.y, frame.size.width +50, frame.size.height);
                         }
         
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)swiperight:(UISwipeGestureRecognizer*)recognizer {
    CGRect frame = recognizer.view.frame;
    if (frame.origin.x == -50) {
        if (isShare)
            self.btnTap.hidden = YES;
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = recognizer.view.frame;
                             frame.origin.x = 0;
                             frame.size.width = 320;
                             recognizer.view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (IBAction)btnDeleteNotificationClicked:(id)sender {
    
    [self.controller deleteNotification:self.index];
    
}

- (IBAction)btnFriendTapClicked:(id)sender {
    CGRect frame = self.frame;
    if (frame.origin.x == -50) {
        if (isShare)
            self.btnTap.hidden = YES;
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = self.frame;
                             frame.origin.x = 0;
                             self.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    } else {
        [self.controller checkNotification:self.index];
    }
}

- (IBAction)btnAddFriendClicked:(id)sender {
    [self.controller addFriend:self.index];
}

- (IBAction)btnAcceptFriendClicked:(id)sender {
    [self.controller acceptFriendRequest:self.index];
}

- (IBAction)btnDeclineFriendClicked:(id)sender {
    [self.controller declineFriendRequest:self.index];
}

@end

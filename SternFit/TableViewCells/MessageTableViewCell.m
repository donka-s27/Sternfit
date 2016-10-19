//
//  MessageTableViewself.m
//  SternFit
//
//  Created by MacOS on 12/18/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "AppDelegate.h"

@implementation MessageTableViewCell

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

- (IBAction)btnProfilePictureClicked:(id)sender {
    CGRect frame = self.frame;
    if (frame.origin.x < 0) {
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
        return;
    }
    [self.parent gotoFittab:self.index];
}

- (IBAction)btnBodyClicked:(id)sender {
    CGRect frame = self.frame;
    if (frame.origin.x < 0) {
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
        return;
    }
    [self.parent gotoChatroom:self.index];
}

- (IBAction)btnDeleteClicked:(id)sender {
    [self.parent deleteMessage:self.index];
}

- (void)setData:(Message *)message {
    self.labelMessage.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16.0f];
    if ([message.image isEqual:@""]) {
        [self.imgProfile setImage:[UIImage imageNamed:@"avator.png"]];
    } else {
        [self.imgProfile setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.imgProfile setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, message.image]]];
    }
    UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
    self.imgProfile.layer.borderColor = borderColor.CGColor;
    self.imgProfile.layer.borderWidth = 3.0f;
    self.imgProfile.layer.cornerRadius = 30.0f;
    self.imgProfile.layer.masksToBounds = YES;
    if ([message.gender isEqual:@"male"]) {
        UIColor *borderColor1 = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
        self.imgProfile.layer.borderColor = borderColor1.CGColor;
    } else {
        UIColor *borderColor1 = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:90.0f/255.0f alpha:1];
        self.imgProfile.layer.borderColor = borderColor1.CGColor;
    }
    
    self.labelStatus.layer.borderColor = borderColor.CGColor;
    self.labelStatus.layer.borderWidth = 2.0f;
    self.labelStatus.layer.cornerRadius = 7.5f;
    if (message.onlinestatus == 0) {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
    } else {
        self.labelStatus.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:227.0f/255.0f blue:54.0f/255.0f alpha:1];
    }
    
    if (message.onlinestatus == -1)
        self.labelStatus.hidden = YES;
    
    //self.labelNum.layer.borderColor = borderColor.CGColor;
    //self.labelNum.layer.borderWidth = 2.0f;
    self.labelNum.layer.cornerRadius = 7.5f;
    if (message.messageNum == 0)
        self.labelNum.hidden = YES;
    else
        self.labelNum.text = [NSString stringWithFormat:@"%d", message.messageNum];
    
    self.labelUsername.text = message.username;
    self.labelMessage.text = message.message;
    
    if (message.distance == -1) {
        self.labelDistance.hidden = YES;
        self.imgDistance.hidden = YES;
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        double distance = (double) message.distance;
        if ([[defaults objectForKey:@"isUnitSystem"] isEqual:@"1"]) {
            distance = distance / 1610;
            self.labelDistance.text = [NSString stringWithFormat:@"%.1f mi", distance];
        } else {
            distance = distance / 1000;
            self.labelDistance.text = [NSString stringWithFormat:@"%.1f km", distance];
        }
    }
    
    if (message.lastupdatetime == -1) {
        self.labelLastUpdateTime.hidden = YES;
        self.imgLastUpdateTime.hidden = YES;
    } else {
        int mins = message.lastupdatetime;
        if (mins / 60 == 0)
            self.labelLastUpdateTime.text = [NSString stringWithFormat:@"%dmins ago", mins, NSLocalizedString(@"ago", nil)];
        else if (mins / 60 < 24)
            self.labelLastUpdateTime.text = [NSString stringWithFormat:@"%dh %dm ago", mins / 60, mins % 60, NSLocalizedString(@"ago", nil)];
        else {
            self.labelLastUpdateTime.text = [NSString stringWithFormat:@"%d %@ %@", (mins / 60 / 24) + 1, NSLocalizedString(@"days", nil), NSLocalizedString(@"ago", nil)];
        }
    }
    
    self.labelMessageTime.text = [self getMessageTime:message.messagetime];
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swiperight];
}

- (NSString *) getMessageTime:(int) messagetime {
    //long secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
   // messagetime += secondsFromGMT;
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:messagetime];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *sharetime = [dateFormatter2 stringFromDate:messageDate];
    
    sharetime = [sharetime substringToIndex:10];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    
    dateFromString = [dateFormatter dateFromString:sharetime];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *stringDate = [dateFormatter1 stringFromDate:[NSDate date]];
    
    currentDate = [dateFormatter dateFromString:stringDate];
    
    if ([dateFromString timeIntervalSince1970] == [currentDate timeIntervalSince1970]) {
        [dateFormatter setDateFormat:@"hh:mm a"];
        
        return [dateFormatter stringFromDate:messageDate];
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
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = recognizer.view.frame;
                             frame.origin.x = 0;
                             recognizer.view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}
@end

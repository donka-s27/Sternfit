//
//  ChatMineTableViewCell.m
//  SternFit
//
//  Created by MacOS on 1/21/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import "ChatMineTableViewCell.h"
#import "AppDelegate.h"

@implementation ChatMineTableViewCell {
    int myId, userId;
    int messageType;
    NSString *location;
    int recoredTime;
    NSTimer *mRecordingUpdateTimer;
    NSTimer *mUploadingTimer;
    int playIndex;
    int uploadingProgress;
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

- (void) setData:(NSMutableDictionary *) message {
    if (mUploadingTimer != nil) {
        [mUploadingTimer invalidate];
        mUploadingTimer = nil;
    }
    self.labelMessage.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18.0f];
    self.labelDate.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12.0f];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    myId = [[defaults objectForKey:@"userID"] intValue];
    userId = [[message objectForKey:@"senderID"] intValue];
    messageType = [[message objectForKey:@"type"] intValue];
    
    if (messageType == 100) { // group chat creation message
        self.viewMessage.hidden = YES;
        self.labelGroupChat.hidden = NO;
        self.labelDate.text = [message objectForKey:@"created_at"];
        self.labelGroupChat.text = [[message objectForKey:@"message"] stringByRemovingPercentEncoding];
        
        return;
    }
    
    NSArray *str;
    
    if (myId == userId) { // my message
        self.imgMessageBack.image =
        [[UIImage imageNamed:@"chat_bubble_sent.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 9, 12, 20) resizingMode:UIImageResizingModeStretch];
        
        CGRect frame = self.viewAvator.frame;
        self.viewAvator.frame = CGRectMake(self.frame.size.width - 90, frame.origin.y, 90, 98);
        
        UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
        self.imgAvator.layer.borderColor = borderColor.CGColor;
        self.imgAvator.layer.borderWidth = 3.0f;
        self.imgAvator.layer.cornerRadius = 30.0f;
        self.imgAvator.layer.masksToBounds = YES;
        if ([[defaults objectForKey:@"gender"] isEqual:@"male"]) {
            UIColor *borderColor1 = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
            self.imgAvator.layer.borderColor = borderColor1.CGColor;
        } else {
            UIColor *borderColor1 = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:90.0f/255.0f alpha:1];
            self.imgAvator.layer.borderColor = borderColor1.CGColor;
        }
        
        self.labelOnline.layer.borderColor = borderColor.CGColor;
        self.labelOnline.layer.borderWidth = 2.0f;
        self.labelOnline.layer.cornerRadius = 8.0f;
        if ([[defaults objectForKey:@"visibleMode"] intValue] == 2) {
            self.labelOnline.backgroundColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
        } else {
            self.labelOnline.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:227.0f/255.0f blue:54.0f/255.0f alpha:1];
        }
        
        self.labelMessage.textColor = [UIColor blackColor];
        
        if ([defaults objectForKey:@"profile"]) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"profile.jpg"];
            
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
            [self.imgAvator setImage:image];
        } else {
            [self.imgAvator setImage:[UIImage imageNamed:@"avator.png"]];
        }
        
    } else { //friend message
        self.imgMessageBack.image =
        [[UIImage imageNamed:@"chat_bubble_received.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 19, 12, 20) resizingMode:UIImageResizingModeStretch];
        
        CGRect frame = self.viewAvator.frame;
        self.viewAvator.frame = CGRectMake(0, frame.origin.y, 90, 98);
        
        Friend *friend;
        for (int i = 0; i < [appDelegate.friends count]; i++) {
            friend = (Friend*) [appDelegate.friends objectAtIndex:i];
            if (friend.userId == [[message objectForKey:@"senderID"] intValue]) {
                break;
            }
        }
        
        UIColor *borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
        self.imgAvator.layer.borderColor = borderColor.CGColor;
        self.imgAvator.layer.borderWidth = 3.0f;
        self.imgAvator.layer.cornerRadius = 30.0f;
        self.imgAvator.layer.masksToBounds = YES;
        if (friend.gender == YES) {
            UIColor *borderColor1 = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
            self.imgAvator.layer.borderColor = borderColor1.CGColor;
        } else {
            UIColor *borderColor1 = [UIColor colorWithRed:247.0f/255.0f green:27.0f/255.0f blue:90.0f/255.0f alpha:1];
            self.imgAvator.layer.borderColor = borderColor1.CGColor;
        }
        
        self.labelOnline.layer.borderColor = borderColor.CGColor;
        self.labelOnline.layer.borderWidth = 2.0f;
        self.labelOnline.layer.cornerRadius = 8.0f;
        if (friend.status == NO) {
            self.labelOnline.backgroundColor = [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];
        } else {
            self.labelOnline.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:227.0f/255.0f blue:54.0f/255.0f alpha:1];
        }
        
        self.labelMessage.textColor = [UIColor whiteColor];
        
        if ([friend.image isEqual:@""]) {
            [self.imgAvator setImage:[UIImage imageNamed:@"avator.png"]];
        } else {
            [self.imgAvator setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self.imgAvator setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, friend.image]]];
        }
        
    }
    
    self.labelDate.text = [message objectForKey:@"created_at"];//[self getMessageTime:[[message objectForKey:@"lastupdatetime"] intValue]];
    switch (messageType) {
        case 0:
            self.labelMessage.text = [[message objectForKey:@"message"] stringByRemovingPercentEncoding];
            break;
        case 1: // emoji
            self.labelMessage.hidden = YES;
            self.imgEmoji.hidden = NO;
            [self.imgEmoji setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [message objectForKey:@"message"]]]];
            break;
        case 10:
            [self.imgMessageBack setImage:(UIImage*) [message objectForKey:@"image"]];
            mUploadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(onUploadingTimer:) userInfo:nil repeats:YES];
            uploadingProgress = 0;
            self.labelMessage.text = @"0%";
            [self.imgEmoji setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self.imgEmoji setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, @"dummy.png"]]];
            [self.imgEmoji showActivityIndicator];
            self.imgEmoji.backgroundColor = [UIColor blackColor];
            self.labelMessage.textColor = [UIColor whiteColor];
            self.labelMessage.textAlignment = NSTextAlignmentCenter;
            self.imgEmoji.alpha = 0.7f;
            break;
        case 3: // location
            self.labelMessage.hidden = YES;
            location = [message objectForKey:@"message"];
            self.imgEmoji.hidden = NO;
            [self.imgEmoji setImage:[UIImage imageNamed:@"map_location.png"]];
            break;
        case 4: // voice
            if (myId == userId) {
                [self.imgEmoji setImage:[UIImage imageNamed:@"chat_voice_received1.png"]];
            } else {
                [self.imgEmoji setImage:[UIImage imageNamed:@"chat_voice_received.png"]];
            }
            self.imgEmoji.frame = CGRectMake(0, 0, 20, 20);
            self.imgEmoji.hidden = NO;
            str = [[message objectForKey:@"message"] componentsSeparatedByString:@","];
            location = [str objectAtIndex:0];
            recoredTime = [[str objectAtIndex:1] intValue];
            if (recoredTime >= 60) {
                self.labelMessage.text = [NSString stringWithFormat:@"%dm %ds", (int)(recoredTime / 60), recoredTime % 60];
            } else {
                self.labelMessage.text = [NSString stringWithFormat:@"%ds", recoredTime];
            }
            break;
        case 5: // voice recording
            [self.imgEmoji setImage:[UIImage imageNamed:@"chat_voice_received1.png"]];
            self.imgEmoji.frame = CGRectMake(0, 0, 20, 20);
            self.imgEmoji.hidden = NO;
            
            mRecordingUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(onRecordingTimer:) userInfo:nil repeats:YES];
            break;
        case 2: // image
            self.labelMessage.hidden = YES;
            self.imgEmoji.hidden = NO;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[message objectForKey:@"message"]];
            
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:filePath]];
            if (image != nil) {
                [self.imgEmoji setImage:image];
            } else {
                [self.imgEmoji setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                [self.imgEmoji setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGE_URL, [message objectForKey:@"message"]]]];
                
                NSString *fileURL = [NSString stringWithFormat:@"%@%@", IMAGE_URL, [message objectForKey:@"message"]];
                [NSURLConnection sendAsynchronousRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:fileURL]]
                 
                                                   queue: [NSOperationQueue mainQueue]
                                       completionHandler: ^( NSURLResponse *response, NSData *data, NSError *error ) {
                                           if(error)
                                           {
                                               
                                           }
                                           else
                                           {
                                               @try {
                                                   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                                                        NSUserDomainMask, YES);
                                                   
                                                   NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[message objectForKey:@"message"]];
                                                   
                                                   [data writeToFile:filePath atomically:YES];
                                               }
                                               @catch (NSException *exception) {
                                                   
                                               }
                                               @finally {
                                                   
                                               }
                                               
                                           }
                                       }];
            }
            break;
        
    }
    
    [self cellHeight];
}

- (NSString *) getMessageTime:(int) messagetime {
    //long secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
    //messagetime += secondsFromGMT;
    
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

- (float) cellHeight {
    if (messageType == 100) { // group chat creation
        return 75.0f;
    }
    
    CGSize maximumLabelSize;
    maximumLabelSize=CGSizeMake(250.0, 999);
    
    CGSize expectedLabelSize = [self.labelMessage.text boundingRectWithSize:CGSizeMake(215,self.labelMessage.font.lineHeight)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName: self.labelMessage.font}
                                                                  context:nil].size;
    /*[self.labelMessage.text sizeWithFont:self.labelMessage.font
                                               constrainedToSize:maximumLabelSize
                                                   lineBreakMode:self.labelMessage.lineBreakMode];*/
    
    
    CGRect rectMsg, rectImg, rectEmoji;
    UITapGestureRecognizer *tapView8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    tapView8.delegate = self;
    UITapGestureRecognizer *tapView9 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationTap:)];
    tapView9.delegate = self;
    UITapGestureRecognizer *tapView7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(audioTap:)];
    tapView7.delegate = self;
    
    switch (messageType) {
        case 0:
            rectMsg = self.labelMessage.frame;
            rectImg = self.imgMessageBack.frame;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                rectMsg.origin.y=0;
                rectMsg.size.width = expectedLabelSize.width+5;
                rectImg.size.width = expectedLabelSize.width+20;
                
                rectMsg.size.height=expectedLabelSize.height+35;
                rectImg.size.height=expectedLabelSize.height+35;
            }
            else
            {
                rectMsg.size.width=expectedLabelSize.width;
                rectImg.size.width=expectedLabelSize.width+20;
                
                rectMsg.size.height=expectedLabelSize.height;
                rectImg.size.height=expectedLabelSize.height+35;
            }
            self.labelMessage.frame=rectMsg;
            self.imgMessageBack.frame=rectImg;
            
            [self.labelMessage setTextAlignment:NSTextAlignmentLeft];
            
            //rectImg.size.height=rectImg.size.height+10;
            
            if (myId==userId)    //fromid=userid me sending
            {
                [self.labelMessage setTextAlignment:NSTextAlignmentRight];
                
                rectImg.origin.x = 320 - self.imgMessageBack.frame.size.width - 75;
                rectMsg.origin.x = 320 - self.labelMessage.frame.size.width - 90;
            }
            else
            {
                rectImg.origin.x = 75;
                rectMsg.origin.x = 75;
                rectMsg.origin.x=rectImg.origin.x+15;
            }
            rectImg.origin.y = 13;
            rectMsg.origin.y = 13;
            /////////////////
            
            if (myId==userId)    //fromid=userid me sending
            {
                if(rectImg.size.width<70)
                {
                    float x=70-rectImg.size.width;
                    rectImg.origin.x-=x;
                    rectImg.size.width=70;
                    rectMsg.origin.x-=x;
                }
            }
            else
            {
                if(rectImg.size.width<70)
                {
                    rectImg.size.width=70;
                }
                
            }
            
            /////////////////
            
            self.labelMessage.frame=rectMsg;
            self.imgMessageBack.frame=rectImg;
            break;
        case 4: // audio
            expectedLabelSize.width = 40;
            rectMsg = self.labelMessage.frame;
            rectImg = self.imgMessageBack.frame;
            rectEmoji = self.imgEmoji.frame;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                rectMsg.origin.y=0;
                rectMsg.size.width = expectedLabelSize.width+5 + 25;
                rectImg.size.width = expectedLabelSize.width+20 + 25;
                
                rectMsg.size.height=expectedLabelSize.height+20;
                rectImg.size.height=expectedLabelSize.height+20;
            }
            else
            {
                rectMsg.size.width=expectedLabelSize.width + 25;
                rectImg.size.width=expectedLabelSize.width+20 + 25;
                
                rectMsg.size.height=expectedLabelSize.height;
                rectImg.size.height=expectedLabelSize.height+20;
            }
            self.labelMessage.frame=rectMsg;
            self.imgMessageBack.frame=rectImg;
            
            [self.labelMessage setTextAlignment:NSTextAlignmentLeft];
            
            //rectImg.size.height=rectImg.size.height+10;
            
            if (myId==userId)    //fromid=userid me sending
            {
                [self.labelMessage setTextAlignment:NSTextAlignmentRight];
                
                rectImg.origin.x = 320 - self.imgMessageBack.frame.size.width - 75;
                rectMsg.origin.x = rectImg.origin.x - 80;
                rectEmoji.origin.x = rectImg.origin.x + rectImg.size.width - 42;
            }
            else
            {
                rectImg.origin.x = 75;
                rectMsg.origin.x = rectImg.origin.x + rectImg.size.width + 10;
                rectEmoji.origin.x = 95;
            }
            rectImg.origin.y = 13;
            rectMsg.origin.y = 13;
            rectEmoji.origin.y = 21;
            /////////////////
            
            if (myId==userId)    //fromid=userid me sending
            {
                if(rectImg.size.width<70)
                {
                    float x=70-rectImg.size.width;
                    rectImg.origin.x-=x;
                    rectImg.size.width=70;
                    rectMsg.origin.x-=x;
                }
            }
            else
            {
                if(rectImg.size.width<70)
                {
                    rectImg.size.width=70;
                }
                
            }
            
            /////////////////
            
            self.labelMessage.frame=rectMsg;
            self.imgMessageBack.frame=rectImg;
            self.imgEmoji.frame = rectEmoji;
            self.labelMessage.textColor = [UIColor whiteColor];
            
            [self.imgMessageBack setUserInteractionEnabled:YES];
            [self.imgMessageBack addGestureRecognizer:tapView7];
            
            break;
        case 5: // audio recording
            expectedLabelSize.width = 40;
            rectMsg = self.labelMessage.frame;
            rectImg = self.imgMessageBack.frame;
            rectEmoji = self.imgEmoji.frame;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                rectMsg.origin.y=0;
                rectMsg.size.width = expectedLabelSize.width+5 + 25;
                rectImg.size.width = expectedLabelSize.width+20 + 25;
                
                rectMsg.size.height=expectedLabelSize.height+20;
                rectImg.size.height=expectedLabelSize.height+20;
            }
            else
            {
                rectMsg.size.width=expectedLabelSize.width + 25;
                rectImg.size.width=expectedLabelSize.width+20 + 25;
                
                rectMsg.size.height=expectedLabelSize.height;
                rectImg.size.height=expectedLabelSize.height+20;
            }
            self.labelMessage.frame=rectMsg;
            self.imgMessageBack.frame=rectImg;
            
            [self.labelMessage setTextAlignment:NSTextAlignmentLeft];
            
            //rectImg.size.height=rectImg.size.height+10;
            
            if (myId==userId)    //fromid=userid me sending
            {
                rectImg.origin.x = 320 - self.imgMessageBack.frame.size.width - 75;
                rectMsg.origin.x = rectImg.origin.x + 35;
                rectEmoji.origin.x = 320 - self.labelMessage.frame.size.width - 85;
            }
            else
            {
                rectImg.origin.x = 75;
                rectMsg.origin.x = 75;
                rectEmoji.origin.x = 95;
                rectMsg.origin.x=rectImg.origin.x+45;
            }
            rectImg.origin.y = 13;
            rectMsg.origin.y = 13;
            rectEmoji.origin.y = 21;
            /////////////////
            
            if (myId==userId)    //fromid=userid me sending
            {
                if(rectImg.size.width<70)
                {
                    float x=70-rectImg.size.width;
                    rectImg.origin.x-=x;
                    rectImg.size.width=70;
                    rectMsg.origin.x-=x;
                }
            }
            else
            {
                if(rectImg.size.width<70)
                {
                    rectImg.size.width=70;
                }
            }
            
            /////////////////
            
            self.labelMessage.frame=rectMsg;
            self.imgMessageBack.frame=rectImg;
            self.imgEmoji.frame = rectEmoji;
            
            self.imgEmoji.hidden = YES;
            self.labelMessage.hidden = YES;
            
            break;
        case 1: // emoji
            expectedLabelSize = CGSizeMake(60, 60);
            
            rectMsg = self.imgEmoji.frame;
            rectImg = self.imgMessageBack.frame;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                rectMsg.origin.y = -20;
                rectImg.size.width = expectedLabelSize.width+20;
                rectImg.size.height=expectedLabelSize.height+20;
            }
            else
            {
                rectImg.size.width=expectedLabelSize.width+20;
                rectImg.size.height=expectedLabelSize.height+20;
            }
            self.imgEmoji.frame = rectMsg;
            self.imgMessageBack.frame = rectImg;
            if (myId==userId)    //fromid=userid me sending
            {
                rectImg.origin.x = 320 - self.imgMessageBack.frame.size.width - 75;
                rectMsg.origin.x = 320 - self.imgEmoji.frame.size.width - 90;
            }
            else
            {
                rectImg.origin.x = 75;
                rectMsg.origin.x = 75;
                rectMsg.origin.x=rectImg.origin.x+15;
            }
            rectImg.origin.y = 13;
            rectMsg.origin.y = 13;
            /////////////////
            
            if (myId==userId)    //fromid=userid me sending
            {
                if(rectImg.size.width<70)
                {
                    float x=70-rectImg.size.width;
                    rectImg.origin.x-=x;
                    rectImg.size.width=70;
                    rectMsg.origin.x-=x;
                }
            }
            else
            {
                if(rectImg.size.width<70)
                {
                    rectImg.size.width=70;
                }
                
            }
            
            /////////////////
            rectImg.size.height -=40;
            
            self.imgEmoji.frame=rectMsg;
            self.imgMessageBack.frame=rectImg;
            self.imgMessageBack.hidden = YES;
            break;
            
        case 2: // image
            expectedLabelSize = CGSizeMake(120, 120);
            
            rectMsg = self.imgEmoji.frame;
            rectImg = self.imgMessageBack.frame;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                rectMsg.origin.y = -20;
                rectImg.size.width = expectedLabelSize.width+20;
                rectImg.size.height=expectedLabelSize.height+20;
                
                rectMsg.size.width = 120;
                rectMsg.size.height = 120;
            }
            else
            {
                rectImg.size.width=expectedLabelSize.width+20;
                rectImg.size.height=expectedLabelSize.height+20;
                
                rectMsg.size.width = 120;
                rectMsg.size.height = 120;
            }
            self.imgEmoji.frame = rectMsg;
            self.imgMessageBack.frame = rectImg;
            if (myId==userId)    //fromid=userid me sending
            {
                rectImg.origin.x = 320 - self.imgMessageBack.frame.size.width - 75;
                rectMsg.origin.x = 320 - self.imgEmoji.frame.size.width - 90;
            }
            else
            {
                rectImg.origin.x = 75;
                rectMsg.origin.x = 75;
                rectMsg.origin.x=rectImg.origin.x+15;
            }
            rectImg.origin.y = 13;
            rectMsg.origin.y = 13;
            /////////////////
            
            if (myId==userId)    //fromid=userid me sending
            {
                if(rectImg.size.width<70)
                {
                    float x=70-rectImg.size.width;
                    rectImg.origin.x-=x;
                    rectImg.size.width=70;
                    rectMsg.origin.x-=x;
                }
            }
            else
            {
                if(rectImg.size.width<70)
                {
                    rectImg.size.width=70;
                }
                
            }
            
            /////////////////
            
            rectImg.size.height -=40;
            self.imgEmoji.frame=rectMsg;
            self.imgMessageBack.frame=rectImg;
            self.imgMessageBack.hidden = YES;
            
            [self.imgEmoji setUserInteractionEnabled:YES];
            [self.imgEmoji addGestureRecognizer:tapView8];
            
            break;
            
        case 10: // image preloading
            expectedLabelSize = CGSizeMake(120, 120);
            
            rectMsg = self.imgEmoji.frame;
            rectImg = self.imgMessageBack.frame;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                rectMsg.origin.y = -20;
                rectImg.size.width = expectedLabelSize.width+20;
                rectImg.size.height=expectedLabelSize.height+20;
                
                rectMsg.size.width = 120;
                rectMsg.size.height = 120;
            }
            else
            {
                rectImg.size.width=expectedLabelSize.width+20;
                rectImg.size.height=expectedLabelSize.height+20;
                
                rectMsg.size.width = 120;
                rectMsg.size.height = 120;
            }
            self.imgEmoji.frame = rectMsg;
            self.imgMessageBack.frame = rectImg;
            if (myId==userId)    //fromid=userid me sending
            {
                rectImg.origin.x = 320 - self.imgMessageBack.frame.size.width - 75;
                rectMsg.origin.x = 320 - self.imgEmoji.frame.size.width - 90;
            }
            else
            {
                rectImg.origin.x = 75;
                rectMsg.origin.x = 75;
                rectMsg.origin.x=rectImg.origin.x+15;
            }
            rectImg.origin.y = 13;
            rectMsg.origin.y = 13;
            /////////////////
            
            if (myId==userId)    //fromid=userid me sending
            {
                if(rectImg.size.width<70)
                {
                    float x=70-rectImg.size.width;
                    rectImg.origin.x-=x;
                    rectImg.size.width=70;
                    rectMsg.origin.x-=x;
                }
            }
            else
            {
                if(rectImg.size.width<70)
                {
                    rectImg.size.width=70;
                }
                
            }
            
            /////////////////
            
            rectImg.size.height -=40;
            self.imgEmoji.frame=rectMsg;
            self.imgMessageBack.frame=rectMsg;
            rectMsg.origin.y += 20;
            self.labelMessage.frame = rectMsg;
            self.imgMessageBack.hidden = NO;
            self.imgEmoji.hidden = NO;
            self.labelMessage.hidden = NO;
            
            break;
            
        case 3: // location
            expectedLabelSize = CGSizeMake(60, 60);
            
            rectMsg = self.imgEmoji.frame;
            rectImg = self.imgMessageBack.frame;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
            {
                rectMsg.origin.y = -20;
                rectImg.size.width = expectedLabelSize.width+20;
                rectImg.size.height=expectedLabelSize.height+20;
            }
            else
            {
                rectImg.size.width=expectedLabelSize.width+20;
                rectImg.size.height=expectedLabelSize.height+20;
            }
            self.imgEmoji.frame = rectMsg;
            self.imgMessageBack.frame = rectImg;
            if (myId==userId)    //fromid=userid me sending
            {
                rectImg.origin.x = 320 - self.imgMessageBack.frame.size.width - 75;
                rectMsg.origin.x = 320 - self.imgEmoji.frame.size.width - 90;
            }
            else
            {
                rectImg.origin.x = 75;
                rectMsg.origin.x = 75;
                rectMsg.origin.x=rectImg.origin.x+15;
            }
            rectImg.origin.y = 13;
            rectMsg.origin.y = 13;
            /////////////////
            
            if (myId==userId)    //fromid=userid me sending
            {
                if(rectImg.size.width<70)
                {
                    float x=70-rectImg.size.width;
                    rectImg.origin.x-=x;
                    rectImg.size.width=70;
                    rectMsg.origin.x-=x;
                }
            }
            else
            {
                if(rectImg.size.width<70)
                {
                    rectImg.size.width=70;
                }
                
            }
            
            /////////////////
            rectImg.size.height -=40;
            
            self.imgEmoji.frame=rectMsg;
            self.imgMessageBack.frame=rectImg;
            self.imgMessageBack.hidden = YES;
            
            [self.imgEmoji setUserInteractionEnabled:YES];
            [self.imgEmoji addGestureRecognizer:tapView9];
            
            break;
    }
    
    return self.imgMessageBack.frame.size.height + 85;
}

- (IBAction)imageViewTap:(UITapGestureRecognizer*)recognizer {
   
    UIImageView *view = (UIImageView*) recognizer.view;
    [self.parent highlightImage:view.image];
}

- (IBAction)locationTap:(UITapGestureRecognizer*)recognizer {
    [self.parent gotoMapController:location];
}

- (IBAction)audioTap:(UITapGestureRecognizer*)recognizer {
    if ([self.parent playAudio:location time:recoredTime] == YES) {
        playIndex = 0;
        mRecordingUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(onPlayingTimer:) userInfo:nil repeats:YES];
    } else {
        if (mRecordingUpdateTimer != nil)
        {
            [mRecordingUpdateTimer invalidate];
            mRecordingUpdateTimer = nil;
            if (myId == userId)
                [self.imgEmoji setImage:[UIImage imageNamed:@"chat_voice_received1_03.png"]];
            else
                [self.imgEmoji setImage:[UIImage imageNamed:@"chat_voice_received_03.png"]];
        }
    }
}


- (void)onRecordingTimer:(id)sender
{
    [UIView animateWithDuration:0.7f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (self.imgMessageBack.alpha <= 0.5f)
                             self.imgMessageBack.alpha = 1.0f;
                         else
                             self.imgMessageBack.alpha = 0.4f;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)onUploadingTimer:(id)sender
{
    uploadingProgress += rand() % 15;
    if (uploadingProgress >= 85)
        uploadingProgress = 85;
    self.labelMessage.text = [NSString stringWithFormat:@"%d%%", uploadingProgress];
}

- (void)onPlayingTimer:(id)sender
{
    if (self.parent.isplaying == NO)
    {
        [mRecordingUpdateTimer invalidate];
        mRecordingUpdateTimer = nil;
        if (myId == userId)
            [self.imgEmoji setImage:[UIImage imageNamed:@"chat_voice_received1_03.png"]];
        else
            [self.imgEmoji setImage:[UIImage imageNamed:@"chat_voice_received_03.png"]];
    }
    if (myId == userId)
        [self.imgEmoji setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chat_voice_received1_0%d.png", (playIndex + 1)]]];
    else
        [self.imgEmoji setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chat_voice_received_0%d.png", (playIndex + 1)]]];
    playIndex = (playIndex + 1) % 3;
}

- (IBAction)btnProfileClicked:(id)sender {
    if (myId == userId)
    {
        [self.parent gotoMyProfilePage];
        return;
    }
    
    [self.parent gotoProfilePage:userId];
}

@end

//
//  Message.h
//  SternFit
//
//  Created by MacOS on 1/28/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property NSString *image;
@property NSString *username;
@property NSString *message;
@property int distance;
@property int messagetime;
@property int lastupdatetime;
@property NSString *gender;
@property int onlinestatus;
@property int messageNum;

- (NSComparisonResult)sortByMessageTime:(Message *)otherObject;

@end

//
//  Friend.h
//  SternFit
//
//  Created by MacOS on 12/23/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property NSString *name;
@property NSString *image;
@property int distance;
@property int userId;
@property NSString *message;
@property BOOL status;
@property int lastupdatetime;
@property BOOL gender;
@property int age;
@property int isFriend;
@property NSString *photo1;
@property NSString *photo2;
@property NSString *photo3;
@property NSString *photo4;
@property NSString *photo5;
@property int height;
@property int weight;
@property NSString *updatedAt;
@property NSString *shareID;
@property NSString *chatroomID;

- (NSComparisonResult)sortByDistance:(Friend *)otherObject;
- (NSComparisonResult)sortByLocationUpdateTime:(Friend *)otherObject;
- (NSComparisonResult)sortByAlpha:(Friend *)otherObject;

@end

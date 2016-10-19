//
//  Message.m
//  SternFit
//
//  Created by MacOS on 1/28/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import "Message.h"

@implementation Message

- (NSComparisonResult)sortByMessageTime:(Message *)otherObject {
    return self.messagetime < otherObject.messagetime;
}
@end

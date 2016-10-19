//
//  Friend.m
//  SternFit
//
//  Created by MacOS on 12/23/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "Friend.h"

@implementation Friend

- (NSComparisonResult)sortByDistance:(Friend *)otherObject {
    return self.distance > otherObject.distance;
}

- (NSComparisonResult)sortByLocationUpdateTime:(Friend *)otherObject {
    return self.lastupdatetime > otherObject.lastupdatetime;
}

- (NSComparisonResult)sortByAlpha:(Friend *)otherObject {
    return [self.name compare:otherObject.name];
}

@end

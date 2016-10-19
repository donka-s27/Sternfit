//
//  DietPlan.h
//  SternFit
//
//  Created by MacOS on 1/30/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exercise.h"

@interface DietPlan : NSObject

@property (nonatomic, strong) NSString *ID;
@property int weekday;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) Exercise *exercise;

@end

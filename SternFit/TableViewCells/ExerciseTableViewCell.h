//
//  ExerciseTableViewCell.h
//  SternFit
//
//  Created by MacOS on 12/22/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ExerciseTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet AsyncImageView *imgExercise;
@property (nonatomic, strong) IBOutlet UILabel *labelExerciseName;

@end

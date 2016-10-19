//
//  TrainingPlanTableViewself.m
//  SternFit
//
//  Created by MacOS on 12/12/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "DietPlanTableViewCell.h"
#import "AppDelegate.h"
#import "DietPlan.h"

@implementation DietPlanTableViewCell

@synthesize imgSeperate;
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

- (void)imageresize
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setData:(NSMutableArray *)weekday {
    DietPlan *plan = (DietPlan*) [weekday objectAtIndex:self.index];
    UIColor *borderColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
    self.imgIcon.layer.borderColor = borderColor.CGColor;
    self.imgIcon.layer.borderWidth = 3.0f;
    self.imgIcon.layer.cornerRadius = 25.0f;
    self.imgIcon.layer.masksToBounds = YES;
    
    [self.imgIcon setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.imgIcon setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@cat0%@/%@", EXERCISE_ICON_URL, plan.exercise.categoryID, plan.exercise.image]]];
    
    self.labelTitle.text = plan.exercise.name;
    self.labelDetail2.text = plan.notes;
    self.labelDetail3.text = plan.notes;
    
    self.showsReorderControl = YES;
    
    self.labelTitle.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13.0f];
    self.labelDetail1.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13.0f];
    self.labelDetail2.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13.0f];
    self.labelDetail3.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13.0f];
}

@end

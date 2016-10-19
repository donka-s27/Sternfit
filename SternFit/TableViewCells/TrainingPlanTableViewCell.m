//
//  TrainingPlanTableViewself.m
//  SternFit
//
//  Created by MacOS on 12/12/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import "TrainingPlanTableViewCell.h"
#import "AppDelegate.h"
#import "TrainingPlan.h"

@implementation TrainingPlanTableViewCell

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
    TrainingPlan *plan = (TrainingPlan*) [weekday objectAtIndex:self.index];
    UIColor *borderColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
    self.imgIcon.layer.borderColor = borderColor.CGColor;
    self.imgIcon.layer.borderWidth = 3.0f;
    self.imgIcon.layer.cornerRadius = 25.0f;
    self.imgIcon.layer.masksToBounds = YES;
    
    [self.imgIcon setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.imgIcon setImageURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@cat0%@/%@", EXERCISE_ICON_URL, plan.exercise.categoryID, plan.exercise.image]]];
    
    self.labelTitle.text = plan.exercise.name;
    NSArray *details = [plan.detail componentsSeparatedByString:@":"];
    NSString *str;
    switch (plan.exercise.type) {
        case 2:
            str = [NSString stringWithFormat:@"%@ %@\n%@ %@", [details objectAtIndex:0], [NSLocalizedString(@"Hours", nil) lowercaseString], [details objectAtIndex:1], [NSLocalizedString(@"Minutes", nil) lowercaseString]];
            break;
        case 0:
            str = [NSString stringWithFormat:@"%@: %@lbs\n%@ x %@", NSLocalizedString(@"Weight", nil), [details objectAtIndex:0], [details objectAtIndex:1], [details objectAtIndex:2]];
            break;
        case 1:
            str = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@ %@", [details objectAtIndex:0], [NSLocalizedString(@"Sets", nil) lowercaseString], [details objectAtIndex:1], [NSLocalizedString(@"Minutes", nil) lowercaseString], [details objectAtIndex:2], [NSLocalizedString(@"Seconds", nil) lowercaseString]];
            break;
        case 3:
            str = [NSString stringWithFormat:@"%@ x %@", [details objectAtIndex:0], [details objectAtIndex:1]];
            break;
    }
    self.labelDetail1.text = str;
    self.labelDetail2.text = plan.notes;
    self.labelDetail3.text = plan.notes;

    self.showsReorderControl = YES;

    self.labelTitle.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13.0f];
    self.labelDetail1.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13.0f];
    self.labelDetail2.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13.0f];
    self.labelDetail3.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13.0f];
}

@end

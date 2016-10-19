//
//  PlanCategoryTableViewCell.h
//  SternFit
//
//  Created by MacOS on 1/30/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanCategoryTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *labelValue;

- (void) setData:(NSString *) value;
@end

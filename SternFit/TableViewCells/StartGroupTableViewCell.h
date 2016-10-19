//
//  StartGroupTableViewCell.h
//  SternFit
//
//  Created by MacOS on 12/18/14.
//  Copyright (c) 2014 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface StartGroupTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet AsyncImageView *imgAvator;
@property (nonatomic, strong) IBOutlet UILabel *labelStatus;
@property (nonatomic, strong) IBOutlet UILabel *labelUsername;
@property (nonatomic, strong) IBOutlet UILabel *labelMessage;
@property (nonatomic, strong) IBOutlet UILabel *labelDistance;
@property (nonatomic, strong) IBOutlet UILabel *labelTimer;
@property (nonatomic, strong) IBOutlet UIImageView *imgCheck;

@end

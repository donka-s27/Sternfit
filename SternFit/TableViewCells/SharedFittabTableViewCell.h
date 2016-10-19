//
//  SharedFittabTableViewCell.h
//  SternFit
//
//  Created by MacOS on 1/12/15.
//  Copyright (c) 2015 com.mobile.sternfit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface SharedFittabTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet AsyncImageView *imgAvator;
@property (nonatomic, strong) IBOutlet UILabel *labelStatus;
@property (nonatomic, strong) IBOutlet UILabel *labelUsername;
@property (nonatomic, strong) IBOutlet UILabel *labelTimer;
@property (nonatomic, strong) IBOutlet UIButton *btnTap;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;

@end

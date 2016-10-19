//
//  ANPopoverView.m
//  CustomSlider
//
//  Created by Gabriel  on 30/1/13.
//  Copyright (c) 2013 App Ninja. All rights reserved.
//

#import "ANPopoverView.h"
#import "AppDelegate.h"
#import "NearbyViewController.h"

@implementation ANPopoverView {
    UILabel *textLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.0f];
        
        UIImageView *popoverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sliderlabel.png"]];
        [self addSubview:popoverView];
        CGRect frame = popoverView.frame;
        frame.origin.x += 13;
        frame.origin.y += 13;
        popoverView.frame = frame;
        
        textLabel = [[UILabel alloc] init];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = self.font;
        textLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.7];
        textLabel.text = self.text;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.frame = CGRectMake(frame.origin.x, frame.origin.y - 2.0f, popoverView.frame.size.width, popoverView.frame.size.height);
        [self addSubview:textLabel];
        
    }
    return self;
}

-(void)setValue:(float)aValue {
    _value = aValue;
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    switch ((int)(_value * 3)) {
        case 0:
            self.text = [NSString stringWithFormat:@"30 %@", NSLocalizedString(@"mins", nil)];
            appDelegate.rootView.appear_time = 0;
            break;
            
        case 1:
            self.text = [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"hour", nil)];
            appDelegate.rootView.appear_time = 1;
            break;
            
        case 2:
            self.text = [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"day", nil)];
            appDelegate.rootView.appear_time = 2;
            break;
            
        case 3:
            self.text = [NSString stringWithFormat:@"3 %@s", NSLocalizedString(@"day", nil)];
            appDelegate.rootView.appear_time = 3;
            break;
    }/*
    if (((int)(_value * 3) + 1) == 1)
        self.text = [NSString stringWithFormat:@"%d %@", ((int)(_value * 3) + 1), NSLocalizedString(@"hour", nil)];
    else
        self.text = [NSString stringWithFormat:@"%d %@s", ((int)(_value * 3) + 1), NSLocalizedString(@"hour", nil)];*/
    textLabel.text = self.text;
    [self setNeedsDisplay];
    
    appDelegate.rootView.filterLabelAppearValue.text = self.text;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

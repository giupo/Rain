//
//  GAHourCell.m
//  Rain
//
//  Created by Giuseppe Acito on 07/06/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import "GAHourCell.h"
#define kMTLabelBottomWidth 40.0
#define kMTLabelBottomHeight 40.0
#define kMTColorGray [UIColor colorWithRed:0.737 green:0.737 blue:0.737 alpha:1.0]
#define kMTColorGreen [UIColor colorWithRed:0.325 green:0.573 blue:0.388 alpha:1.0]
#define kMTColorOrange [UIColor colorWithRed:1.000 green:0.306 blue:0.373 alpha:1.0]

@implementation GAHourCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Helpers
        CGSize size = self.contentView.frame.size;
        // Initialize Label Time
        self.labelTime = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, 50.0, 40.0)];
        // Configure Label Time
        [self.labelTime setBackgroundColor:[UIColor clearColor]];
        [self.labelTime setTextColor:[UIColor whiteColor]];
        [self.labelTime setFont:[UIFont fontWithName:@"GillSans-Light" size:18.0]];
        [self.labelTime setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [self.contentView addSubview:self.labelTime];
        // Initialize Label Temp
        self.labelTemp = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 46.0, 80.0, 44.0)];
        // Configure Label Temp
        [self.labelTemp setBackgroundColor:[UIColor clearColor]];
        [self.labelTemp setTextAlignment:NSTextAlignmentCenter];
        [self.labelTemp setTextColor:kMTColorGray];
        [self.labelTemp setFont:[UIFont fontWithName:@"GillSans-Bold" size:40.0]];
        [self.labelTemp setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [self.contentView addSubview:self.labelTemp];
        // Initialize Label Wind
        self.labelWind = [[UILabel alloc] initWithFrame:CGRectMake(0.0, size.height - kMTLabelBottomHeight, kMTLabelBottomWidth, kMTLabelBottomHeight)];
        // Configure Label Wind
        [self.labelWind setBackgroundColor:[UIColor clearColor]];
        [self.labelWind setTextAlignment:NSTextAlignmentCenter];
        [self.labelWind setTextColor:kMTColorGray];
        [self.labelWind setFont:[UIFont fontWithName:@"GillSans-Light" size:16.0]];
        [self.labelWind setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin)];
        [self.contentView addSubview:self.labelWind];
        // Initialize Label Rain
        self.labelRain = [[UILabel alloc] initWithFrame:CGRectMake(size.width - kMTLabelBottomWidth, size.height - kMTLabelBottomHeight, kMTLabelBottomWidth, kMTLabelBottomHeight)];
        // Configure Label Rain
        [self.labelRain setBackgroundColor:[UIColor clearColor]];
        [self.labelRain setTextAlignment:NSTextAlignmentCenter];
        [self.labelRain setTextColor:kMTColorGray];
        [self.labelRain setFont:[UIFont fontWithName:@"GillSans-Light" size:16.0]];
        [self.labelRain setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin)];
        [self.contentView addSubview:self.labelRain];
        // Background View
        UIImage *backgroundImage = [[UIImage imageNamed:@"background-hour-cell"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 10.0, 10.0, 10.0)];
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)];
        [backgroundView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [backgroundView setImage:backgroundImage];
        [self setBackgroundView:backgroundView];
    }
    return self;
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

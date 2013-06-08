//
//  GADayCell.m
//  Rain
//
//  Created by Giuseppe Acito on 08/06/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import "GADayCell.h"
#import "GAConstants.h"

#define kMTCalendarWidth 44.0
#define kMTCalendarHeight 80.0
#define kMTCalendarMarginLeft 60.0
#define kMTLabelRightWidth 30.0
#define kMTLabelRightHeight 14.0
#define kMTCalendarWidth 44.0
#define kMTCalendarHeight 80.0
#define kMTCalendarMarginLeft 60.0
#define kMTLabelRightWidth 30.0
#define kMTLabelRightHeight 14.0

@interface GADayCell ()
@property (strong, nonatomic) UIImageView *imageViewCalendar;
@end

@implementation GADayCell
#pragma mark -
#pragma mark Initialization
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Helpers
        CGSize size = self.contentView.frame.size;
        // Configure Table View Cell
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        // Initialize Image View Clock
        self.imageViewCalendar = [[UIImageView alloc] initWithFrame:CGRectMake(kMTCalendarMarginLeft, 0.0, kMTCalendarWidth, kMTCalendarHeight)];
        // Configure Image View Clock
        [self.imageViewCalendar setContentMode:UIViewContentModeCenter];
        [self.imageViewCalendar setImage:[UIImage imageNamed:@"background-calendar-day-cell"]];
        [self.imageViewCalendar setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [self.contentView addSubview:self.imageViewCalendar];
        // Initialize Label Day
        self.labelDay = [[UILabel alloc] initWithFrame:CGRectMake(kMTCalendarMarginLeft, 10.0, kMTCalendarWidth, 20.0)];
        // Configure Label Day
        [self.labelDay setTextColor:[UIColor whiteColor]];
        [self.labelDay setTextAlignment:NSTextAlignmentCenter];
        [self.labelDay setBackgroundColor:[UIColor clearColor]];
        [self.labelDay setFont:[UIFont fontWithName:@"GillSans" size:14.0]];
        [self.labelDay setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [self.contentView addSubview:self.labelDay];
        // Initialize Label Date
        self.labelDate = [[UILabel alloc] initWithFrame:CGRectMake(kMTCalendarMarginLeft, 20.0, kMTCalendarWidth, 60.0)];
        // Configure Label Date
        [self.labelDate setTextColor:kMTColorGray];
        [self.labelDate setTextAlignment:NSTextAlignmentCenter];
        [self.labelDate setBackgroundColor:[UIColor clearColor]];
        [self.labelDate setFont:[UIFont fontWithName:@"GillSans" size:24.0]];
        [self.labelDate setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [self.contentView addSubview:self.labelDate];
        // Initialize Label Wind
        self.labelWind = [[UILabel alloc] initWithFrame:CGRectMake(size.width - kMTLabelRightWidth, (size.height / 2.0) - kMTLabelRightHeight, kMTLabelRightWidth, kMTLabelRightHeight)];
        // Configure Label Wind
        [self.labelWind setTextColor:kMTColorGray];
        [self.labelWind setTextAlignment:NSTextAlignmentCenter];
        [self.labelWind setBackgroundColor:[UIColor clearColor]];
        [self.labelWind setFont:[UIFont fontWithName:@"GillSans" size:12.0]];
        [self.labelWind setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin)];
        [self.contentView addSubview:self.labelWind];
        // Initialize Label Rain
        self.labelRain = [[UILabel alloc] initWithFrame:CGRectMake(size.width - kMTLabelRightWidth, (size.height / 2.0), kMTLabelRightWidth, kMTLabelRightHeight)];
        // Configure Label Rain
        [self.labelRain setTextColor:kMTColorGray];
        [self.labelRain setTextAlignment:NSTextAlignmentCenter];
        [self.labelRain setBackgroundColor:[UIColor clearColor]];
        [self.labelRain setFont:[UIFont fontWithName:@"GillSans" size:12.0]];
        [self.labelRain setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [self.contentView addSubview:self.labelRain];
        // Initialize Label Temp
        self.labelTemp = [[UILabel alloc] initWithFrame:CGRectMake(kMTCalendarWidth + kMTCalendarMarginLeft + 12.0, 0.0, size.width - kMTCalendarWidth - kMTCalendarMarginLeft - kMTLabelRightWidth - 12.0, size.height)];
        // Configure Label Temp
        [self.labelTemp setTextColor:kMTColorGray];
        [self.labelTemp setTextAlignment:NSTextAlignmentCenter];
        [self.labelTemp setBackgroundColor:[UIColor clearColor]];
        [self.labelTemp setFont:[UIFont fontWithName:@"GillSans-Bold" size:40.0]];
        [self.labelTemp setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.contentView addSubview:self.labelTemp];
    }
    return self;
}
@end

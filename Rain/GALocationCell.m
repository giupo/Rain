//
//  GALocationCell.m
//  Rain
//
//  Created by Giuseppe Acito on 08/06/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import "GALocationCell.h"

#define kMTColorGray [UIColor colorWithRed:0.737 green:0.737 blue:0.737 alpha:1.0]
#define kMTButtonDeleteWidth 44.0
#define kMTLabelLocationMarginLeft 44.0
@implementation GALocationCell
#pragma mark -
#pragma mark Initialization
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Helpers
        CGSize size = self.contentView.frame.size;
        // Initialize Delete Button
        self.buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        // Configure Delete Button
        [self.buttonDelete setFrame:CGRectMake(0.0, 0.0, kMTButtonDeleteWidth, size.height)];
        [self.buttonDelete setImage:[UIImage imageNamed:@"button-delete-location-cell"] forState:UIControlStateNormal];
        [self.buttonDelete setImage:[UIImage imageNamed:@"button-delete-location-cell"] forState:UIControlStateSelected];
        [self.buttonDelete setImage:[UIImage imageNamed:@"button-delete-location-cell"] forState:UIControlStateDisabled];
        [self.buttonDelete setImage:[UIImage imageNamed:@"button-delete-location-cell"] forState:UIControlStateHighlighted];
        [self.buttonDelete setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin)];
        [self.contentView addSubview:self.buttonDelete];
        // Initialize Location Label
        self.labelLocation = [[UILabel alloc] initWithFrame:CGRectMake(kMTLabelLocationMarginLeft, 0.0, size.width - kMTLabelLocationMarginLeft, size.height)];
        // Configure Text Label
        [self.labelLocation setTextColor:kMTColorGray];
        [self.labelLocation setBackgroundColor:[UIColor clearColor]];
        [self.labelLocation setFont:[UIFont fontWithName:@"GillSans" size:20.0]];
        [self.labelLocation setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin)];
        [self.contentView addSubview:self.labelLocation];
    }
    return self;
}
@end
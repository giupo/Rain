//
//  NSUserDefaults+Helpers.h
//  Rain
//
//  Created by Giuseppe Acito on 07/06/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSUserDefaults (Helpers)
#pragma mark -
#pragma mark Temperature
+ (BOOL)isDefaultCelcius;
+ (void)setDefaultToCelcius;
+ (void)setDefaultToFahrenheit;
@end
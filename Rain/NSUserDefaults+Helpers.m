//
//  NSUserDefaults+Helpers.m
//  Rain
//
//  Created by Giuseppe Acito on 07/06/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import "NSUserDefaults+Helpers.h"

@implementation NSUserDefaults (Helpers)

+ (BOOL)isDefaultCelcius {
    return [[NSUserDefaults standardUserDefaults] integerForKey:GARainUserDefaultsTemperatureUnit] == 1;
}
+ (void)setDefaultToCelcius {
    // Update User Defaults
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:1 forKey:GARainUserDefaultsTemperatureUnit];
    [ud synchronize];
    // Post Notification
    [[NSNotificationCenter defaultCenter] postNotificationName:GARainTemperatureUnitDidChangeNotification object:nil];
}
+ (void)setDefaultToFahrenheit {
    // Update User Defaults
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:0 forKey:GARainUserDefaultsTemperatureUnit];
    [ud synchronize];
    // Post Notification
    [[NSNotificationCenter defaultCenter] postNotificationName:GARainTemperatureUnitDidChangeNotification object:nil];
}

@end


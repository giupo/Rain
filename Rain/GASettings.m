//
//  GASettings.m
//  Rain
//
//  Created by Giuseppe Acito on 07/06/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import "GASettings.h"
#import "NSUserDefaults+Helpers.h"

@implementation GASettings

+ (NSString *)formatTemperature:(NSNumber *)temperature {
    float value = [temperature floatValue];
    if ([NSUserDefaults isDefaultCelcius]) {
        value = (value  -  32.0)  *  (5.0 / 9.0);
    }
    return [NSString stringWithFormat:@"%.0f°", value];
}

@end

//
//  GASettings.h
//  Rain
//
//  Created by Giuseppe Acito on 07/06/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GASettings : NSObject
#pragma mark -
#pragma mark Convenience Methods
+ (NSString *)formatTemperature:(NSNumber *)temperature;
@end
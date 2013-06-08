//
//  GAConstants.h
//  Rain
//
//  Created by Giuseppe Acito on 21/05/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#pragma mark -
#pragma mark User Defaults
extern NSString * const MTRainUserDefaultsLocation;
extern NSString * const MTRainUserDefaultsLocations;
#pragma mark -
#pragma mark Notifications
extern NSString * const MTRainDidAddLocationNotification;
extern NSString * const MTRainLocationDidChangeNotification;
#pragma mark -
#pragma mark Location Keys
extern NSString * const MTLocationKeyCity;
extern NSString * const MTLocationKeyCountry;
extern NSString * const MTLocationKeyLatitude;
extern NSString * const MTLocationKeyLongitude;
extern NSString * const MTForecastAPIKey;
extern NSString * const GAForecastURL;
extern NSString * const GARainReachabilityStatusDidChangeNotification;
extern NSString * const GARainWeatherDataDidChangeChangeNotification;
extern NSString * const GARainTemperatureUnitDidChangeNotification;
extern NSString * const GARainUserDefaultsTemperatureUnit;


#define kMTColorGray [UIColor colorWithRed:0.737 green:0.737 blue:0.737 alpha:1.0]
#define kMTColorGreen [UIColor colorWithRed:0.325 green:0.573 blue:0.388 alpha:1.0]
#define kMTColorOrange [UIColor colorWithRed:1.000 green:0.306 blue:0.373 alpha:1.0]
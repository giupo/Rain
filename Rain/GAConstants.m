//
//  GAConstants.m
//  Rain
//
//  Created by Giuseppe Acito on 21/05/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import "GAConstants.h"
#pragma mark -
#pragma mark User Defaults
NSString * const MTRainUserDefaultsLocation = @"location";
NSString * const MTRainUserDefaultsLocations = @"locations";
#pragma mark -
#pragma mark Notifications
NSString * const MTRainDidAddLocationNotification = @"it.giupo.mobileTuts.GARainDidAddLocationNotification";
NSString * const MTRainLocationDidChangeNotification = @"it.giupo.GARainLocationDidChangeNotification";
#pragma mark -
#pragma mark Location Keys
NSString * const MTLocationKeyCity = @"city";
NSString * const MTLocationKeyCountry = @"country";
NSString * const MTLocationKeyLatitude = @"latitude";
NSString * const MTLocationKeyLongitude = @"longitude";
NSString * const MTForecastAPIKey = @"08ae2eba52c85e25d178531aace23d87";
NSString * const GAForecastURL = @"https://api.forecast.io/forecast/%@/";

NSString * const GARainReachabilityStatusDidChangeNotification = @"it.giupo.GARainReachabilityStatusDidChangeNotification";
NSString * const GARainWeatherDataDidChangeChangeNotification = @"it.giupo.GARainWeatherDataDidChangeChangeNotification";
NSString * const GARainTemperatureUnitDidChangeNotification = @"it.giupo.GARainTemperatureUnitDidChangeNotification";

NSString * const GARainUserDefaultsTemperatureUnit = @"temperatureUnit";

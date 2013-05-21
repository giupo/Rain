//
//  GAForecastClient.h
//  Pods
//
//  Created by Giuseppe Acito on 21/05/13.
//
//

#import "AFHTTPClient.h"

typedef void (^GAForecastClientCompletionBlock)(BOOL success, NSDictionary *response);

@interface GAForecastClient : AFHTTPClient

#pragma mark -
#pragma mark Shared Client
+ (GAForecastClient *)sharedClient;
- (void)requestWeatherForCoordinate:(CLLocationCoordinate2D)coordinate completion:(GAForecastClientCompletionBlock)completion;

@end

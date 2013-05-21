//
//  GAForecastClient.m
//  Pods
//
//  Created by Giuseppe Acito on 21/05/13.
//
//

#import "GAForecastClient.h"

@implementation GAForecastClient



+ (GAForecastClient *)sharedClient {
    static dispatch_once_t predicate;
    static GAForecastClient *_sharedClient = nil;
    dispatch_once(&predicate, ^{
        _sharedClient = [self alloc];
        _sharedClient = [_sharedClient initWithBaseURL:[GAForecastClient baseURL]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        // Reachability
        __weak typeof(self)weakSelf = self;
        [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GARainReachabilityStatusDidChangeNotification object:weakSelf];
        }];
    }
    return self;
}

+ (NSURL *)baseURL {
    return [NSURL URLWithString:[NSString stringWithFormat:GAForecastURL, MTForecastAPIKey]];
}

- (void)requestWeatherForCoordinate:(CLLocationCoordinate2D)coordinate completion:(GAForecastClientCompletionBlock)completion {
    
    if ([[GAForecastClient sharedClient] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
    [self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
        if (completion) {
            completion(YES, response);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(NO, nil);
            NSLog(@"Unable to fetch weather data due to error %@ with user info %@.", error, error.userInfo);
        }
    }];
}

@end

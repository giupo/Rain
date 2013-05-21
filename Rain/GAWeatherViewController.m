//
//  GAWeatherViewController.m
//  Rain
//
//  Created by Giuseppe Acito on 21/05/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import "GAWeatherViewController.h"

@interface GAWeatherViewController () {
    BOOL _locationFound;
}

@property (strong, nonatomic) NSDictionary *location;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation GAWeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.location = [[NSUserDefaults standardUserDefaults] objectForKey:MTRainUserDefaultsLocation];
    if(!self.location) {
        self.labelLocation.text = @"Updating...";
        [self.locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GALocationsControllerDelegate methods

- (void)controllerShouldAddCurrentLocation:(GALocationsViewController *)controller {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.locationManager startUpdatingLocation];
}
- (void)controller:(GALocationsViewController *)controller didSelectLocation:(NSDictionary *)location {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.location = location;
}

#pragma mark - CLLocationManagerDelegate methods

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if(![locations count] || _locationFound) {
        return;
    } else {
        _locationFound = YES;
    }
    
    
    [manager stopUpdatingLocation];
    CLLocation *currentLocation = [locations objectAtIndex:0];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placeMarks, NSError *error) {
        if([placeMarks count]) {
            _locationFound = NO;
            [self processPlacemark:[placeMarks objectAtIndex:0]];
        }
    }];
}
     
- (void) processPlacemark:(CLPlacemark *) placemark {
    NSString *city = placemark.locality;
    NSString *country = placemark.country;
    
    CLLocationDegrees lat = placemark.location.coordinate.latitude;
    CLLocationDegrees lon = placemark.location.coordinate.longitude;
    
    NSDictionary *currentLocation = @{ MTLocationKeyCity :city,
                                       MTLocationKeyCountry : country,
                                       MTLocationKeyLatitude : @(lat),
                                       MTLocationKeyLongitude : @(lon)};
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *locations = [NSMutableArray arrayWithArray:[ud objectForKey:MTRainUserDefaultsLocations]];
    [locations addObject:currentLocation];
    [locations sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:MTLocationKeyCity ascending:YES]]];
    [ud setObject:locations forKey:MTRainUserDefaultsLocations];
    
    [ud synchronize];
    self.location = currentLocation;
    
    NSNotification *notification = [NSNotification notificationWithName:MTRainDidAddLocationNotification object:self userInfo:currentLocation];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void) setLocation:(NSDictionary *)location {
    if(_location != location) {
        _location = location;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:location forKey:MTRainUserDefaultsLocation];
        [ud synchronize];
        
        NSNotification *notification = [NSNotification notificationWithName:MTRainLocationDidChangeNotification object:self userInfo:location];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [self updateView];
    }
}

- (void) updateView {
    [self.labelLocation setText:[self.location objectForKey:MTLocationKeyCity]];
}


@end
//
//  GAWeatherViewController.m
//  Rain
//
//  Created by Giuseppe Acito on 21/05/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import "GAWeatherViewController.h"
#import "GAForecastClient.h"
#import "GAHourCell.h"

@interface GAWeatherViewController () {
    BOOL _locationFound;
}

@property (strong, nonatomic) NSDictionary *location;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDictionary *response;
@property (strong, nonatomic) NSArray *forecast;

@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonRefresh;
@property (weak, nonatomic) IBOutlet UIButton *buttonLocation;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTemp;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelWind;
@property (weak, nonatomic) IBOutlet UILabel *labelRain;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@end

@implementation GAWeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(reachabilityStatusDidChange:)
                                name:GARainReachabilityStatusDidChangeNotification object:nil];
        
        [nc addObserver:self selector:@selector(applicationDidBecomeActive:)
                   name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [nc addObserver:self selector:@selector(weatherDataDidChangeChange:)
                    name:GARainWeatherDataDidChangeChangeNotification object:nil];
        [nc addObserver:self selector:@selector(temperatureUnitDidChange:)
                    name:GARainTemperatureUnitDidChangeNotification object:nil];
        
        
        
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
    
    [super viewDidLoad];
    // Load Location
    self.location = [[NSUserDefaults standardUserDefaults] objectForKey:MTRainUserDefaultsLocation];
    if (!self.location) {
        [self.locationManager startUpdatingLocation];
    }
    // Configure Collection View
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerClass:[GAHourCell class] forCellWithReuseIdentifier:HourCell];
    
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
        [self fetchWeatherData];
    }
}

- (void)updateView {
    // Update Location Label
    [self.labelLocation setText:[self.location objectForKey:MTLocationKeyCity]];
    // Update Current Weather
    [self updateCurrentWeather];
    // Reload Collection View
    [self.collectionView reloadData];
}


- (void)updateCurrentWeather {
    // Weather Data
    NSDictionary *data = [self.response objectForKey:@"currently"];
    // Update Date Label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    //[dateFormatter setDateFormat:@"EEEE, MMMM d"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[data[@"time"] doubleValue]];
    [self.labelDate setText:[dateFormatter stringFromDate:date]];
    // Update Temperature Label
    [self.labelTemp setText:[GASettings formatTemperature:data[@"temperature"]]];
    // Update Time Label
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [timeFormatter setDateFormat:@"hh:mm a"];
    [self.labelTime setText:[timeFormatter stringFromDate:[NSDate date]]];
    // Update Wind Label
    [self.labelWind setText:[NSString stringWithFormat:@"%.1f MP", [data[@"windSpeed"] floatValue]]];
    // Update Rain Label
    float rainProbability = 0.0;
    if (data[@"precipProbability"]) {
        rainProbability = [data[@"precipProbability"] floatValue] * 100.0;
    }
    [self.labelRain setText:[NSString stringWithFormat:@"%.0f%%", rainProbability]];
}

- (void)fetchWeatherData {
    
    if ([[GAForecastClient sharedClient] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) return;
    // Show Progress HUD
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    // Query Forecast API
    double lat = [[_location objectForKey:MTLocationKeyLatitude] doubleValue];
    double lng = [[_location objectForKey:MTLocationKeyLongitude] doubleValue];
    [[GAForecastClient sharedClient] requestWeatherForCoordinate:CLLocationCoordinate2DMake(lat, lng) completion:^(BOOL success, NSDictionary *response) {
        // Dismiss Progress HUD
        [SVProgressHUD dismiss];
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // Post Notification on Main Thread
                NSNotification *notification = [NSNotification notificationWithName:GARainWeatherDataDidChangeChangeNotification object:nil userInfo:response];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });
        }
    }];
}

- (void)dealloc {
    // Remove Observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reachabilityStatusDidChange:(NSNotification *)notification {
    GAForecastClient *forecastClient = [notification object];
    NSLog(@"Reachability Status > %i", forecastClient.networkReachabilityStatus);
    self.buttonRefresh.enabled = (forecastClient.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable);
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (self.location) {
        [self fetchWeatherData];
    }
}

- (IBAction)refresh:(id)sender {
    if (self.location) {
        [self fetchWeatherData];
    }
}

- (void)weatherDataDidChangeChange:(NSNotification *)notification {
    // Update Response & Forecast
    [self setResponse:[notification userInfo]];
    [self setForecast:self.response[@"hourly"][@"data"]];
    // Update View
    [self updateView];
}
- (void)temperatureUnitDidChange:(NSNotification *)notification {
    // Update View
    [self updateView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.forecast ? 1 : 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.forecast count];
}

static NSString *HourCell = @"HourCell";

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GAHourCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HourCell forIndexPath:indexPath];
    // Fetch Data
    NSDictionary *data = [self.forecast objectAtIndex:indexPath.row];
    // Initialize Date Formatter
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [timeFormatter setDateFormat:@"ha"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[data[@"time"] doubleValue]];
    // Configure Cell
    [cell.labelTime setText:[timeFormatter stringFromDate:date]];
    [cell.labelTemp setText:[GASettings formatTemperature:data[@"temperature"]]];
    [cell.labelWind setText:[NSString stringWithFormat:@"%.0fMP", [data[@"windSpeed"] floatValue]]];
    float rainProbability = 0.0;
    if (data[@"precipProbability"]) {
        rainProbability = [data[@"precipProbability"] floatValue] * 100.0;
    }
    [cell.labelRain setText:[NSString stringWithFormat:@"%.0f%%", rainProbability]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80.0, 120.0);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
}

- (IBAction)resetLocation:(id)sender {
    [self.locationManager startUpdatingLocation];
}



@end

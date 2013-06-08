//
//  GAForecastViewController.m
//  Rain
//
//  Created by Giuseppe Acito on 21/05/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import "GAForecastViewController.h"
#import "GADayCell.h"

@interface GAForecastViewController ()

@property (strong, nonatomic) NSDictionary *response;
@property (strong, nonatomic) NSArray *forecast;

@end

@implementation GAForecastViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self selector:@selector(weatherDataDidChangeChange:)
                   name:GARainWeatherDataDidChangeChangeNotification object:nil];
        
        [nc addObserver:self selector:@selector(temperatureUnitDidChange:)
                    name:GARainTemperatureUnitDidChangeNotification object:nil];
    }
    return self;
}

- (void)weatherDataDidChangeChange:(NSNotification *)notification {
    // Update Response & Forecast
    [self setResponse:[notification userInfo]];
    [self setForecast:self.response[@"daily"][@"data"]];
    // Update View
    [self updateView];
}
- (void)temperatureUnitDidChange:(NSNotification *)notification {
    // Update View
    [self updateView];
}

- (void)updateView {
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[GADayCell class] forCellReuseIdentifier:DayCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.forecast ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.forecast count];
}

static NSString *DayCell = @"DayCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GADayCell *cell = [tableView dequeueReusableCellWithIdentifier:DayCell forIndexPath:indexPath];
    // Fetch Data
    NSDictionary *data = [self.forecast objectAtIndex:indexPath.row];
    // Initialize Date Formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[data[@"time"] doubleValue]];
    // Configure Cell
    [dateFormatter setDateFormat:@"EEE"];
    [cell.labelDay setText:[dateFormatter stringFromDate:date]];
    [dateFormatter setDateFormat:@"d"];
    [cell.labelDate setText:[dateFormatter stringFromDate:date]];
    float tempMin = [data[@"temperatureMin"] floatValue];
    float tempMax = [data[@"temperatureMax"] floatValue];
    
    
    
    [cell.labelTemp setText:[NSString stringWithFormat:@"%@/%@",
                             [GASettings formatTemperature:[NSNumber numberWithFloat:tempMin]],
                             [GASettings formatTemperature:[NSNumber numberWithFloat:tempMax]]]];
    
    [cell.labelWind setText:[NSString stringWithFormat:@"%.0f", [data[@"windSpeed"] floatValue]]];
    float rainProbability = 0.0;
    if (data[@"precipProbability"]) {
        rainProbability = [data[@"precipProbability"] floatValue] * 100.0;
    }
    [cell.labelRain setText:[NSString stringWithFormat:@"%.0f", rainProbability]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

@end

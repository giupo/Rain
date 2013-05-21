//
//  GALocationsViewController.m
//  Rain
//
//  Created by Giuseppe Acito on 21/05/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import "GALocationsViewController.h"

@interface GALocationsViewController ()
@property (strong, nonatomic) NSMutableArray *locations;
@end

@implementation GALocationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadLocations];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddLocation:) name:MTRainDidAddLocationNotification object:nil];
    }
    return self;
}

- (void) loadLocations {
    self.locations = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MTRainUserDefaultsLocations]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];

}

static NSString *LocationCell = @"LocationCell";

- (void) setupView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LocationCell];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return ([self.locations count] +1);
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationCell];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void) configureCell:(UITableViewCell *) cell atIndexPath:(NSIndexPath *) indexPath {
    if(indexPath.row == 0) {
        [cell.textLabel setText:@"Add Current Location"];
    } else {
        NSDictionary *location = [self.locations objectAtIndex:indexPath.row - 1 ];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@, %@", location[MTLocationKeyCity], location[MTLocationKeyCountry]]];
    }
}

- (BOOL) tableView: (UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL) tableView: (UITableView *) tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        [self.delegate controllerShouldAddCurrentLocation:self];
    } else {
        NSDictionary *location = [self.locations objectAtIndex:(indexPath.row -1)];
        [self.delegate controller:self didSelectLocation:location];
    }
    [self.viewDeckController closeLeftViewAnimated:YES];
}

- (void) didAddLocation:(NSNotification *) notification {
    NSDictionary *location = notification.userInfo;
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    for(id storedLocation in self.locations) {
        if([storedLocation[MTLocationKeyCity] isEqualToString:location[MTLocationKeyCity]] &&
            [storedLocation[MTLocationKeyCountry] isEqualToString:location[MTLocationKeyCountry]]) {
            return;
        }
    }
    
    [self.locations addObject:location];
    [self.locations sortUsingDescriptors:@[[NSSortDescriptor
                                            sortDescriptorWithKey:MTLocationKeyCity ascending:YES]]];
    [self.tableView reloadData];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_delegate) {
        self.delegate = nil;
    }
}

@end

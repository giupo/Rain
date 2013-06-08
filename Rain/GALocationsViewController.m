//
//  GALocationsViewController.m
//  Rain
//
//  Created by Giuseppe Acito on 21/05/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import "GALocationsViewController.h"
#import "GALocationCell.h"
#import "NSUserDefaults+Helpers.h"

static NSString *AddLocationCell = @"AddLocationCell";
static NSString *LocationCell = @"LocationCell";
static NSString *SettingsCell = @"SettingsCell";

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellReusableID = nil;
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            cellReusableID = AddLocationCell;
        } else {
            cellReusableID = LocationCell;
        }
    } else {
        cellReusableID = SettingsCell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusableID];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (BOOL) tableView: (UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL) tableView: (UITableView *) tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
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

- (IBAction)openLeftView:(id)sender {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)setupView {
    // Setup Table View
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // Register Class for Cell Reuse
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:AddLocationCell];
    [self.tableView registerClass:[GALocationCell class] forCellReuseIdentifier:LocationCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SettingsCell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.locations count] + 1;
    }
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return NSLocalizedString(@"Locations", nil);
            break;
        }
        default: {
            return NSLocalizedString(@"Temperature", nil);
            break;
        }
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // Header Text
    NSString *text = [self tableView:tableView titleForHeaderInSection:section];
    // Helpers
    CGRect labelFrame = CGRectMake(12.0, 0.0, tableView.bounds.size.width, 44.0);
    // Initialize Label
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    // Configure Label
    [label setText:text];
    [label setTextColor:kMTColorOrange];
    [label setFont:[UIFont fontWithName:@"GillSans" size:20.0]];
    [label setBackgroundColor:[UIColor clearColor]];
    // Initialize View
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, 34.0)];
    [backgroundView setBackgroundColor:[UIColor clearColor]];
    [backgroundView addSubview:label];
    return backgroundView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // Initialize View
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, 34.0)];
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    return backgroundView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 40.0;
    }
    return 0.0;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Helpers
    UIFont *fontLight = [UIFont fontWithName:@"GillSans-Light" size:18.0];
    UIFont *fontRegular = [UIFont fontWithName:@"GillSans" size:18.0];
    // Background View Image
    UIImage *backgroundImage = [[UIImage imageNamed:@"background-location-cell"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 0.0, 0.0, 10.0)];
    // Configure Table View Cell
    [cell.textLabel setFont:fontLight];
    [cell.textLabel setTextColor:kMTColorGray];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Add Current Location"];
            [cell.imageView setContentMode:UIViewContentModeCenter];
            [cell.imageView setImage:[UIImage imageNamed:@"icon-add-location"]];
            // Background View Image
            backgroundImage = [[UIImage imageNamed:@"background-add-location-cell"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 0.0, 0.0, 10.0)];
        } else {
            // Fetch Location
            NSDictionary *location = [self.locations objectAtIndex:(indexPath.row - 1)];
            // Configure Cell
            [[(GALocationCell *)cell buttonDelete] addTarget:self action:@selector(deleteLocation:) forControlEvents:UIControlEventTouchUpInside];
            [[(GALocationCell *)cell labelLocation] setText:[NSString stringWithFormat:@"%@, %@", location[MTLocationKeyCity], location[MTLocationKeyCountry]]];
        }
    } else {
        if (indexPath.row == 0) {
            [cell.textLabel setText:NSLocalizedString(@"Fahrenheit", nil)];
            if ([NSUserDefaults isDefaultCelcius]) {
                [cell.textLabel setFont:fontLight];
                [cell.textLabel setTextColor:kMTColorGray];
            } else {
                [cell.textLabel setFont:fontRegular];
                [cell.textLabel setTextColor:kMTColorGreen];
            }
        } else {
            [cell.textLabel setText:NSLocalizedString(@"Celsius", nil)];
            if ([NSUserDefaults isDefaultCelcius]) {
                [cell.textLabel setFont:fontRegular];
                [cell.textLabel setTextColor:kMTColorGreen];
            } else {
                [cell.textLabel setFont:fontLight];
                [cell.textLabel setTextColor:kMTColorGray];
            }
        }
    }
    if (backgroundImage) {
        // Background View
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
        [backgroundView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [backgroundView setImage:backgroundImage];
        [cell setBackgroundView:backgroundView];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // Notify Delegate
            [self.delegate controllerShouldAddCurrentLocation:self];
        } else {
            // Fetch Location
            NSDictionary *location = [self.locations objectAtIndex:(indexPath.row - 1)];
            // Notify Delegate
            [self.delegate controller:self didSelectLocation:location];
        }
    } else {
        if (indexPath.row == 0 && [NSUserDefaults isDefaultCelcius]) {
            [NSUserDefaults setDefaultToFahrenheit];
        } else if (![NSUserDefaults isDefaultCelcius]) {
            [NSUserDefaults setDefaultToCelcius];
        }
        // Update Section
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
    // Show Center View Controller
    [self.viewDeckController closeLeftViewAnimated:YES];
}

- (void)deleteLocation:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[(UIButton *)sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    // Update Locations
    [self.locations removeObjectAtIndex:(indexPath.row - 1)];
    // Update User Defaults
    [[NSUserDefaults standardUserDefaults] setObject:self.locations forKey:MTRainUserDefaultsLocations];
    // Update Table View
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

@end

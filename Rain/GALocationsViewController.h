//
//  GALocationsViewController.h
//  Rain
//
//  Created by Giuseppe Acito on 21/05/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GALocationsViewController : UIViewController
@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end


@protocol GALocationsViewControllerDelegate <NSObject>
- (void) controllerShouldAddCurrentLocation:(GALocationsViewController *) controller;
- (void) controller:(GALocationsViewController *) controller didSelectLocation:(NSDictionary *) location;
@end
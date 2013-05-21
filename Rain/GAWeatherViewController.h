//
//  GAWeatherViewController.h
//  Rain
//
//  Created by Giuseppe Acito on 21/05/13.
//  Copyright (c) 2013 GA Software Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GALocationsViewController.h"

@interface GAWeatherViewController : UIViewController
    <GALocationsViewControllerDelegate, CLLocationManagerDelegate>
@end

//
//  WeatherController.h
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CurrentForecast.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CurrentForecast *currentForecast;

@end

NS_ASSUME_NONNULL_END

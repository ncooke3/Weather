//
//  WeatherController.h
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

// Frameworks
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

// Models
#import "CurrentForecast.h"
#import "DailyForecast.h"
#import "HourlyForecast.h"

// Networking
#import "DarkSky.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CurrentForecast *currentForecast;
@property (nonatomic) NSArray<DailyForecast *> *dailyForecasts;
@property (nonatomic) NSArray<HourlyForecast *> *hourlyForecasts;
@property (nonatomic) DarkSky *darksky;

- (CLLocationCoordinate2D)currentLocationCoordinate;

@end

NS_ASSUME_NONNULL_END

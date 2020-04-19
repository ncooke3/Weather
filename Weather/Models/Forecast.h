//
//  Forecast.h
//  Weather
//
//  Created by Nicholas Cooke on 3/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// Models
#import "CurrentForecast.h"
#import "HourlyForecast.h"
#import "DailyForecast.h"

// Networking
#import "DarkSky.h"
#import "DarkSky+CLLocation.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ForecastType) {
    ForecastTypeCurrently,
    ForecastTypeHourly,
    ForecastTypeDaily
};

typedef NSArray<DailyForecast *>  WeeklyWeather;
typedef NSArray<HourlyForecast *> HourlyWeather;
typedef NSArray<NSArray *> * HourlyTemperatures;
typedef NSArray<NSArray *> * HourlyPrecipitation;

@interface Forecast : NSObject

@property (nonatomic) CLLocation *location;
@property (nonatomic) NSString *locationString;

@property (nonatomic) CurrentForecast *currentForecast;
@property (nonatomic) WeeklyWeather *dailyForecasts;
@property (nonatomic) HourlyWeather *hourlyForecasts;

- (instancetype)initForLocation:(CLLocation *)location;

- (void)forecastLocationString:(void(^)(NSString *))completion;
- (NSString *)currentTemperature;
- (NSString *)currentFeelsLikeTemperature;
- (NSString *)currentConditions;
- (NSArray *)currentWeatherFeed;
- (NSArray *)currentColors;

- (void)updateForecasts:(void(^)(void))completion;
- (void)updateForecast:(ForecastType)forecastType completion:(void(^)(void))completion;
- (HourlyTemperatures)hourlyTemperatures;
- (HourlyPrecipitation)hourlyPrecipitation;

@end

NS_ASSUME_NONNULL_END

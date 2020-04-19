//
//  Forecast.m
//  Weather
//
//  Created by Nicholas Cooke on 3/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "Forecast.h"

// Categories
#import "NSArray+Map.h"
#import "NSString+ForecastConditions.h"
#import "UIColor+WeatherColors.h"
#import "CLGeocoder+City.h"

typedef NSDictionary * ForecastResponse;
typedef NSArray * (^ForecastsConstructorBlock)(ForecastResponse, ForecastType, NSInteger);

@interface Forecast ()

@property (nonatomic, copy) ForecastsConstructorBlock forecastsConstructor;

@end

@implementation Forecast

- (instancetype)init {
    return nil;
}

- (instancetype)initForLocation:(CLLocation *)location {
    self = [super init];
    if (self) {
        _location = location;
        [self configureForecastsConstructor];
        [self updateLocalityForLocation];
    }
    return self;
}

- (void)updateLocalityForLocation {
    [CLGeocoder cityFromLocation:_location completion:^(Placemark city) {
        self.locationString = city.locality;
    }];
}

- (void)configureForecastsConstructor {
    _forecastsConstructor = ^NSArray *(ForecastResponse response, ForecastType type, NSInteger count) {
        NSMutableArray<HourlyForecast *> *forecasts = [[NSMutableArray alloc] init];
        for (NSDictionary *forecastJSON in response) {
            if ([forecasts count] == count) break;
            id forecast;
            if (type == ForecastTypeHourly) forecast = [[HourlyForecast alloc] initWithDictionary:forecastJSON];
            if (type == ForecastTypeDaily) forecast = [[DailyForecast alloc] initWithDictionary:forecastJSON];
            [forecasts addObject:forecast];
        }
        return [forecasts copy];
    };
}

- (void)updateForecasts:(void(^)(void))completion {
    DarkSky *darsky = [DarkSky sharedManagager];
    [darsky clearCache];
    [darsky getForecastForLocation:self.location completion:^(ForecastResponse forecast) {
        self.currentForecast = [[CurrentForecast alloc] initWithDictionary:forecast[kDScurrentlyForecast]];
        self.hourlyForecasts = self.forecastsConstructor(forecast[kDShourlyForecast][kDSData], ForecastTypeHourly, 12);
        self.dailyForecasts  = self.forecastsConstructor(forecast[kDSdailyForecast][kDSData], ForecastTypeDaily, 7);
        completion();
    }];
}

- (void)updateForecast:(ForecastType)forecastType completion:(void(^)(void))completion {
    DarkSky *darsky = [DarkSky sharedManagager];
    [darsky getForecastForLocation:self.location completion:^(ForecastResponse forecast) {
        if (forecastType == ForecastTypeCurrently) {
            self.currentForecast = [[CurrentForecast alloc] initWithDictionary:forecast[kDScurrentlyForecast]];
        } else if (forecastType == ForecastTypeHourly) {
            self.hourlyForecasts = self.forecastsConstructor(forecast[kDShourlyForecast][kDSData], ForecastTypeHourly, 12);
        } else if (forecastType == ForecastTypeDaily) {
            self.dailyForecasts  = self.forecastsConstructor(forecast[kDSdailyForecast][kDSData], ForecastTypeDaily, 7);
        }
        completion();
    }];
}

- (void)forecastLocationString:(void(^)(NSString *))completion; {
    [CLGeocoder cityFromLocation:_location completion:^(Placemark city) {
        self.locationString = city.locality;
        completion(city.locality);
    }];
}

- (NSString *)currentTemperature {
    return [self.currentForecast.temperature stringValue];
}

- (NSString *)currentFeelsLikeTemperature {
    return [self.currentForecast.apparentTemperature stringValue];
}

- (NSString *)currentConditions {
    return [NSString conditionsFrom:self.currentForecast.icon];
}

- (NSArray *)currentWeatherFeed {
    return @[@"Feels like 66°", @"Current humidity is 69%", @"Storm is approaching"];
}

- (NSArray *)currentColors {
    return [UIColor colorsForForecast:_currentForecast.icon];
}

- (HourlyTemperatures)hourlyTemperatures {
    return [_hourlyForecasts map:^(HourlyForecast *forecast) {
        //NSLog(@"forecast time: %@ and temp: %@ \n",forecast.time, forecast.temperature.stringValue);
        return @[forecast.time, forecast.temperature];
    }];
}

- (HourlyPrecipitation)hourlyPrecipitation {
    return [_hourlyForecasts map:^(HourlyForecast *forecast) {
        //NSLog(@"forecast time: %@ and precipitation: %@ \n",forecast.time, forecast.precipProbability.stringValue);
        return @[forecast.time, forecast.precipProbability];
    }];
}

@end

 


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

@interface Forecast () <NSCoding>

@property (nonatomic, copy) ForecastsConstructorBlock forecastsConstructor;

@end

@implementation Forecast

- (instancetype)init {
    return nil;
}

- (ForecastsConstructorBlock)forecastsConstructor {
    if (!_forecastsConstructor) {
        [self configureForecastsConstructor];
    }
    return _forecastsConstructor;
}

- (instancetype)initForPlaceNamed:(NSString *)placeName atLocation:(CLLocation *)location withTimeZone:(nullable NSTimeZone *)timeZone {
    self = [super init];
    if (self) {
        _locationString = placeName;
        _location = location;
        _timeZone = timeZone;
    }
    return self;
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

+ (BOOL)supportsSecureCoding {
    return YES;
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
    NSString *currentTemperatureString = [self.currentForecast.temperature stringValue];
    if (currentTemperatureString == nil) {
        currentTemperatureString = @"0";
    }
    return currentTemperatureString;
}

- (NSString *)currentFeelsLikeTemperature {
    return [self.currentForecast.apparentTemperature stringValue];
}

- (NSString *)currentConditions {
    return [NSString conditionsFrom:self.currentForecast.icon];
}

- (NSArray *)currentColors {
    return [UIColor colorsForForecast:[self currentConditions]];
}

- (HourlyTemperatures)hourlyTemperatures {
    return [_hourlyForecasts map:^(HourlyForecast *forecast) {
        return @[forecast.time, forecast.temperature];
    }];
}

- (HourlyPrecipitation)hourlyPrecipitation {
    return [_hourlyForecasts map:^(HourlyForecast *forecast) {
        return @[forecast.time, forecast.precipProbability];
    }];
}

- (void)encodeWithCoder:(nonnull NSCoder *)encoder {
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:self.locationString forKey:@"locationString"];
    [encoder encodeObject:self.currentForecast forKey:@"currentForecast"];
    [encoder encodeObject:self.dailyForecasts forKey:@"dailyForecast"];
    [encoder encodeObject:self.hourlyForecasts forKey:@"hourlyForecast"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.location = [decoder decodeObjectOfClass:CLLocation.class forKey:@"location"];
        self.locationString = [decoder decodeObjectForKey:@"locationString"];
        self.currentForecast = [decoder decodeObjectOfClass:CurrentForecast.class forKey:@"currentForecast"];
        self.dailyForecasts = [decoder decodeObjectOfClasses:[NSSet setWithArray:@[NSArray.class, DailyForecast.class]] forKey:@"dailyForecast"];
        self.hourlyForecasts = [decoder decodeObjectOfClasses:[NSSet setWithArray:@[NSArray.class, HourlyForecast.class]] forKey:@"hourlyForecast"];
    }
    return self;
}

@end

 


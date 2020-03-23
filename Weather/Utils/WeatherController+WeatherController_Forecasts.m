//
//  WeatherController+WeatherController_Forecasts.m
//  Weather
//
//  Created by Nicholas Cooke on 3/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "WeatherController+WeatherController_Forecasts.h"

@implementation WeatherController (WeatherController_Forecasts)

- (void)getCurrentForecast:(ForecastResponseBlock)completion {
    [self.darksky getForecastForLatitude:[self currentLocationCoordinate].latitude
                               longitude:[self currentLocationCoordinate].longitude
                                    time:[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]]
                               excluding:@[kDSdailyForecast, kDSminutelyForecast,
                                           kDShourlyForecast, kDSflags]
                                  extend:@"" language:@"" units:@"us" success:^(NSDictionary *forecast) {
        completion(forecast[kDScurrentlyForecast]);
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [error description]);
        completion(nil);
    }];
}

- (void)getDailyForecasts:(ForecastResponseBlock)completion {
    [self.darksky getForecastForLatitude:[self currentLocationCoordinate].latitude
                               longitude:[self currentLocationCoordinate].longitude
                                    time:nil
                               excluding:@[kDScurrentlyForecast, kDSminutelyForecast,
                                           kDShourlyForecast, kDSflags]
                                  extend:@"" language:@"" units:@"us" success:^(NSDictionary *forecast) {
        completion(forecast[kDSdailyForecast][kDSData]);
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [error description]);
        completion(nil);
    }];
}

- (void)getHourlyForecasts:(ForecastResponseBlock)completion {
    [self.darksky getForecastForLatitude:[self currentLocationCoordinate].latitude
                               longitude:[self currentLocationCoordinate].longitude
                                    time:nil
                               excluding:@[kDScurrentlyForecast, kDSminutelyForecast,
                                           kDSdailyForecast, kDSflags]
                                  extend:@"" language:@"" units:@"us" success:^(NSDictionary *forecast) {
        completion(forecast[kDShourlyForecast][kDSData]);
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [error description]);
        completion(nil);
    }];
}

@end

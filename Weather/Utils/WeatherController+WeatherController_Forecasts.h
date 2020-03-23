//
//  WeatherController+WeatherController_Forecasts.h
//  Weather
//
//  Created by Nicholas Cooke on 3/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "WeatherController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSDictionary * _Nullable ForecastResponse;
typedef void(^ForecastResponseBlock)(ForecastResponse forecast);

@interface WeatherController (WeatherController_Forecasts)

- (void)getCurrentForecast:(ForecastResponseBlock)completion;
- (void)getDailyForecasts:(ForecastResponseBlock)completion;
- (void)getHourlyForecasts:(ForecastResponseBlock)completion;

@end

NS_ASSUME_NONNULL_END

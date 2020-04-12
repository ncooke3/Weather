//
//  CityForecastCell+ConfigureForForecast.h
//  Weather
//
//  Created by Nicholas Cooke on 4/7/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "CityForecastCell.h"

// Models
#import "Forecast.h"

NS_ASSUME_NONNULL_BEGIN

@interface CityForecastCell (ConfigureForForecast)

- (void)configureForForecast:(Forecast *)forecast;

@end

NS_ASSUME_NONNULL_END

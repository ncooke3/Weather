//
//  DailyForecastCell+ConfigureForForecast.h
//  Weather
//
//  Created by Nicholas Cooke on 4/5/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DailyForecastCell.h"

// Models
#import "DailyForecast.h"

NS_ASSUME_NONNULL_BEGIN

@interface DailyForecastCell (ConfigureForForecast)

- (void)configureForForecast:(DailyForecast *)forecast;

@end

NS_ASSUME_NONNULL_END

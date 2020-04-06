//
//  DarkSky+CLLocation.h
//  Weather
//
//  Created by Nicholas Cooke on 4/4/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DarkSky.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSDictionary * _Nullable ForecastResponse;
typedef void(^ForecastResponseBlock)(ForecastResponse forecast);

@interface DarkSky (CLLocation)

- (void)getForecastForLocation:(CLLocation *)location completion:(ForecastResponseBlock)completion;

@end

NS_ASSUME_NONNULL_END

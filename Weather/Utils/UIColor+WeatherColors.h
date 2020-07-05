//
//  UIColor+WeatherColors.h
//  Weather
//
//  Created by Nicholas Cooke on 4/2/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (WeatherColors)


+ (NSArray<UIColor *> *)colorsForForecast:(NSString *)forecastString;


@end

NS_ASSUME_NONNULL_END

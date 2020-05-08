//
//  UIColor+WeatherColors.h
//  Weather
//
//  Created by Nicholas Cooke on 4/2/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WeatherCondition) {
    WeatherConditionClear,
    WeatherConditionClearNight,
    WeatherConditionCloudy,
    WeatherConditionFoggy,
    WeatherConditionHailShowers,
    WeatherConditionPartlyCloudy,
    WeatherConditionPartlyCloudyNight,
    WeatherConditionRain,
    WeatherConditionSleet,
    WeatherConditionSnow,
    WeatherConditionThunderstorm,
    WeatherConditionTornado,
    WeatherConditionWindy,
    WeatherConditionUnknown
};

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (WeatherColors)

+ (UIColor *)whitishBackgroundColor;

// Weather Conditions
+ (NSArray<UIColor *> *)clearWeatherColor;
+ (NSArray<UIColor *> *)cloudyColor;
+ (NSArray<UIColor *> *)foggyColor;
+ (NSArray<UIColor *> *)hailShowersColor;
+ (UIColor *)partlyCloudyColor;
+ (NSArray<UIColor *> *)rainyColor;
+ (UIColor *)sleetColor;
+ (UIColor *)snowColor;
+ (NSArray<UIColor *> *)thunderstormColor;
+ (NSArray<UIColor *> *)tornadoColor;
+ (UIColor *)windyColor;
+ (UIColor *)rainColor;

// Moon & Sun Colors
+ (UIColor *)moonColor;
+ (UIColor *)sunColor;

+ (NSArray<UIColor *> *)colorsForForecast:(NSString *)forecastString;
+ (NSArray<UIColor *> *)colorsForForecastCondition:(WeatherCondition)weatherCondition;

@end

NS_ASSUME_NONNULL_END

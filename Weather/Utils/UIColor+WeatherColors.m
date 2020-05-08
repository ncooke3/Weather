//
//  UIColor+WeatherColors.m
//  Weather
//
//  Created by Nicholas Cooke on 4/2/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "UIColor+WeatherColors.h"

@implementation UIColor (WeatherColors)

#pragma mark - Background Colors

+ (UIColor *)whitishBackgroundColor {
    return [UIColor colorWithRed:0.97 green:0.97 blue:0.95 alpha:1.0];
    
}

#pragma mark - Text Colors

// TODO: add colors for text (light and dark)

/// Im thinkig title, subtitle, detail for light and dark (6 colors)

#pragma mark - Weather Colors

+ (NSArray<UIColor *> *)clearWeatherColor {
    /// Warm 316
    UIColor *reddish = [UIColor colorWithRed:0.84 green:0.46 blue:0.45 alpha:1.00];
    UIColor *orangeish = [UIColor colorWithRed:0.96 green:0.78 blue:0.66 alpha:1.00];
    UIColor *yellowish = [UIColor colorWithRed:0.97 green:0.91 blue:0.81 alpha:1.00];
    UIColor *whitish = [UIColor colorWithRed:0.99 green:0.96 blue:0.93 alpha:1.00];
    return @[reddish, orangeish, whitish, yellowish];
}

+ (NSArray<UIColor *> *)cloudyColor {
    return @[
        [UIColor colorNamed:@"Clear Color 1"],
        [UIColor colorNamed:@"Clear Color 2"]
    ];
}

+ (NSArray<UIColor *> *)foggyColor {
    return @[

        [UIColor colorWithRed:0.94 green:0.96 blue:0.94 alpha:1.00], //lightest
        
        [UIColor colorWithRed:0.71 green:0.80 blue:0.69 alpha:1.00], //greenish
        
        [UIColor colorWithRed:0.20 green:0.27 blue:0.28 alpha:1.00], // dark greenish
        [UIColor colorWithRed:0.42 green:0.55 blue:0.55 alpha:1.00], // darkest

    ];
}

+ (NSArray<UIColor *> *)hailShowersColor {
    return @[
        [UIColor colorNamed:@"hail.dark"],
        [UIColor colorNamed:@"hail.light"],
    ];
}

+ (UIColor *)partlyCloudyColor {
    return UIColor.new;
}

+ (NSArray<UIColor *> *)rainyColor {
    return @[
    [UIColor colorWithRed: 0.81 green: 0.85 blue: 0.87 alpha: 1.00], // heavy rain gray
    [UIColor colorWithRed: 0.89 green: 0.92 blue: 0.94 alpha: 1.00], // heavier rain
//    [UIColor colorWithRed: 0.22 green: 0.29 blue: 0.38 alpha: 1.00], // dark blue
  //  [UIColor colorWithRed: 0.36 green: 0.58 blue: 0.77 alpha: 1.00], // medium blue
    [UIColor colorWithRed: 0.75 green: 0.85 blue: 0.98 alpha: 1.00], // light blue
    //[UIColor colorWithRed: 0.97 green: 0.97 blue: 0.95 alpha: 1.00]  // whitish
    ];
}

+ (UIColor *)rainColor {
    return [UIColor colorWithRed: 0.81 green: 0.85 blue: 0.87 alpha: 1.00];
}

+ (UIColor *)sleetColor {
    return UIColor.new;
}

+ (UIColor *)snowColor {
    return UIColor.new;
}

+ (NSArray<UIColor *> *)thunderstormColor {
    return @[
        [UIColor colorNamed:@"thunderstorm.dark"],
        [UIColor colorNamed:@"thunderstorm.light"]
    ];
}

+ (NSArray<UIColor *> *)tornadoColor {
    return @[
        [UIColor colorNamed:@"tornado.dark"],
        [UIColor colorNamed:@"tornado.light"],
    ];
}

+ (UIColor *)windyColor {
    return UIColor.new;
}


#pragma mark - Sun & Moon Colors (for MoonButton.h)

+ (UIColor *)moonColor {
    return [UIColor colorWithRed:0.97 green:0.95 blue:0.93 alpha:1.00];
}

+ (UIColor *)sunColor {
    return [UIColor colorWithRed:0.98 green:0.80 blue:0.37 alpha:1.00];
}

#pragma mark - For gradients

+ (NSArray<UIColor *> *)colorsForForecast:(NSString *)forecastString {
    if ([forecastString isEqualToString:@"Clear"]) {
        return [self colorsForForecastCondition:WeatherConditionClear];
    } else if ([forecastString isEqualToString:@"Clear Night"]) {
        return [self colorsForForecastCondition:WeatherConditionClearNight];
    } else if ([forecastString isEqualToString:@"Cloudy"]) {
        return [self colorsForForecastCondition:WeatherConditionCloudy];
    } else if ([forecastString isEqualToString:@"Foggy"]) {
        return [self colorsForForecastCondition:WeatherConditionFoggy];
    } else if ([forecastString isEqualToString:@"Hail Showers"]) {
        return [self colorsForForecastCondition:WeatherConditionHailShowers];
    } else if ([forecastString isEqualToString:@"Partly Cloudy"]) {
        return [self colorsForForecastCondition:WeatherConditionPartlyCloudy];
    } else if ([forecastString isEqualToString:@"Partly Cloudy"]) { // MARK: handle night man
        return [self colorsForForecastCondition:WeatherConditionPartlyCloudyNight];
    } else if ([forecastString isEqualToString:@"Rain"]) {
        return [self colorsForForecastCondition:WeatherConditionRain];
    } else if ([forecastString isEqualToString:@"Sleet"]) {
        return [self colorsForForecastCondition:WeatherConditionSleet];
    } else if ([forecastString isEqualToString:@"Snow"]) {
        return [self colorsForForecastCondition:WeatherConditionSnow];
    } else if ([forecastString isEqualToString:@"Thunderstorm"]) {
        return [self colorsForForecastCondition:WeatherConditionThunderstorm];
    } else if ([forecastString isEqualToString:@"Tornado"]) {
        return [self colorsForForecastCondition:WeatherConditionTornado];
    } else if ([forecastString isEqualToString:@"Windy"]) {
        return [self colorsForForecastCondition:WeatherConditionWindy];
    }
    
    return @[[UIColor secondarySystemBackgroundColor],
             [UIColor secondarySystemBackgroundColor]];
}

+ (NSArray<UIColor *> *)colorsForForecastCondition:(WeatherCondition)weatherCondition {
    switch (weatherCondition) {
        case WeatherConditionClear:
            return @[[UIColor colorNamed:@"clear.dark"],
                     [UIColor colorNamed:@"clear.light"]];
        case WeatherConditionClearNight:
            return @[[UIColor colorNamed:@"clear.dark"],
                     [UIColor colorNamed:@"clear.light"]];
        case WeatherConditionCloudy:
            return @[[UIColor colorNamed:@"cloudy.dark"],
                     [UIColor colorNamed:@"cloudy.light"]];
        case WeatherConditionFoggy:
            return @[[UIColor colorNamed:@"fog.dark"],
                     [UIColor colorNamed:@"fog.light"]];
        case WeatherConditionHailShowers:
            return @[[UIColor colorNamed:@"hail.dark"],
                     [UIColor colorNamed:@"hail.light"]];
        case WeatherConditionPartlyCloudy:
            return @[[UIColor colorNamed:@"partlyCloudy.dark"],
                     [UIColor colorNamed:@"partlyCloudy.light"]];
        case WeatherConditionPartlyCloudyNight:
            return @[[UIColor colorNamed:@"partlyCloudy.dark"],
                     [UIColor colorNamed:@"partlyCloudy.light"]];
        case WeatherConditionRain:
            return @[[UIColor colorNamed:@"rain.dark"],
                     [UIColor colorNamed:@"rain.light"]];
        case WeatherConditionSleet:
            return @[[UIColor colorNamed:@"sleet.dark"],
                     [UIColor colorNamed:@"sleet.light"]];
        case WeatherConditionSnow:
            return @[[UIColor colorNamed:@"snow.dark"],
                     [UIColor colorNamed:@"snow.light"]];
        case WeatherConditionThunderstorm:
            return @[[UIColor colorNamed:@"thunderstorm.dark"],
                     [UIColor colorNamed:@"thunderstorm.light"]];
        case WeatherConditionTornado:
            return @[[UIColor colorNamed:@"tornado.dark"],
                     [UIColor colorNamed:@"tornado.light"]];
        case WeatherConditionWindy:
            return @[[UIColor colorNamed:@"windy.dark"],
                     [UIColor colorNamed:@"windy.light"]];
        case WeatherConditionUnknown:
            return @[[UIColor secondarySystemBackgroundColor],
                     [UIColor secondarySystemBackgroundColor]];
    }
    
}

@end

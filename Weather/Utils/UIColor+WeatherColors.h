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

+ (UIColor *)whitishBackgroundColor;

// Weather Conditions
+ (NSArray<UIColor *> *)clearWeatherColor;
+ (UIColor *)cloudyColor;
+ (NSArray<UIColor *> *)foggyColor;
+ (UIColor *)hailShowersColor;
+ (UIColor *)partlyCloudyColor;
+ (UIColor *)rainyColor;
+ (UIColor *)sleetColor;
+ (UIColor *)snowColor;
+ (UIColor *)thunderstormColor;
+ (UIColor *)tornadoColor;
+ (UIColor *)windyColor;

// Moon & Sun Colors
+ (UIColor *)moonColor;
+ (UIColor *)sunColor;

+ (NSArray<UIColor *> *)colorsForForecast:(NSString *)forecastString;

@end

NS_ASSUME_NONNULL_END

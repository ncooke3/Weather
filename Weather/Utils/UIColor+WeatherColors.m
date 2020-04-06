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

// TODO: light mode subview

// TODO: dark mode background color should be the color sets from fluid interfaces

// TODO: dark mode subview

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

+ (UIColor *)cloudyColor {
    return UIColor.new;
}

+ (NSArray<UIColor *> *)foggyColor {
    return @[

        [UIColor colorWithRed:0.94 green:0.96 blue:0.94 alpha:1.00], //lightest
        
        [UIColor colorWithRed:0.71 green:0.80 blue:0.69 alpha:1.00], //greenish
        
        [UIColor colorWithRed:0.20 green:0.27 blue:0.28 alpha:1.00], // dark greenish
        [UIColor colorWithRed:0.42 green:0.55 blue:0.55 alpha:1.00], // darkest

    ];
}

+ (UIColor *)hailShowersColor {
    return UIColor.new;
}

+ (UIColor *)partlyCloudyColor {
    return UIColor.new;
}

+ (UIColor *)rainyColor {
    return UIColor.new;
}

+ (UIColor *)sleetColor {
    return UIColor.new;
}

+ (UIColor *)snowColor {
    return UIColor.new;
}

+ (UIColor *)thunderstormColor {
    return UIColor.new;
}

+ (UIColor *)tornadoColor {
    return UIColor.new;
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

    return [UIColor foggyColor];
    

}

@end

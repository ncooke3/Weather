//
//  UIColor+WeatherColors.m
//  Weather
//
//  Created by Nicholas Cooke on 4/2/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "UIColor+WeatherColors.h"

@implementation UIColor (WeatherColors)


+ (NSArray<UIColor *> *)colorsForForecast:(NSString *)forecastString {
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"forecastColors"]) {
        return @[[UIColor colorNamed:@"cloudy.dark"],
                 [UIColor colorNamed:@"cloudy.light"]];
    } else {
        return @[[UIColor colorNamed:@"rain.dark"],
                 [UIColor colorNamed:@"rain.light"]];
    }
}


@end

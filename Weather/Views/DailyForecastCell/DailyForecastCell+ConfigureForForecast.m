//
//  DailyForecastCell+ConfigureForForecast.m
//  Weather
//
//  Created by Nicholas Cooke on 4/5/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DailyForecastCell+ConfigureForForecast.h"

// Temporary Import
#import "DarkSky.h"

@implementation DailyForecastCell (ConfigureForForecast)

- (void)configureForForecast:(DailyForecast *)forecast {
    UIImage *iconImage = [self imageForConditions:forecast.icon];
    [self.iconImageView setImage:iconImage];
    self.iconImageView.image = [self.iconImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.iconImageView setTintColor:[UIColor secondaryLabelColor]];
    self.dayLabel.text = forecast.dayOfTheWeek;
    [self.dayLabel sizeToFit];
    self.highTempLabel.text = [forecast.maxTemperature stringValue];
    [self.highTempLabel sizeToFit];
    self.lowTempLabel.text = [forecast.minTemperature stringValue];
    [self.lowTempLabel sizeToFit];
    self.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
}

- (UIImage *)imageForConditions:(NSString *)conditions {
    NSString *systemImageName;
    if ([conditions isEqualToString:kDSclearDay]) {
        systemImageName = @"sun.max.fill";
    } else if ([conditions isEqualToString:kDSclearNight]) {
        systemImageName = @"moon.fill";
    } else if ([conditions isEqualToString:kDScloudy]) {
        systemImageName = @"cloud.fill";
    } else if ([conditions isEqualToString:kDSfog]) {
        systemImageName = @"cloud.fog.fill";
    } else if ([conditions isEqualToString:kDShail]) {
        systemImageName = @"cloud.hail.fill";
    } else if ([conditions isEqualToString:kDSpartlyCloudyDay]) {
        systemImageName = @"cloud.sun.fill";
    } else if ([conditions isEqualToString:kDSpartlyCloudyNight]) {
        systemImageName = @"cloud.moon.fill";
    } else if ([conditions isEqualToString:kDSrain]) {
        systemImageName = @"cloud.rain.fill";
    } else if ([conditions isEqualToString:kDSsleet]) {
        systemImageName = @"cloud.sleet.fill";
    } else if ([conditions isEqualToString:kDSsnow]) {
        systemImageName = @"snow";
    } else if ([conditions isEqualToString:kDSthunderstorm]) {
        systemImageName = @"cloud.bolt.rain.fill";
    } else if ([conditions isEqualToString:kDStornado]) {
        systemImageName = @"ornado";
    } else if ([conditions isEqualToString:kDSwind]) {
        systemImageName = @"wind";
    } else {
        systemImageName = @"Unknown";
    }
    
    return [UIImage systemImageNamed:systemImageName];
}

@end

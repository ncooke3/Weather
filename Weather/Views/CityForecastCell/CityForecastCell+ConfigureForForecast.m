//
//  CityForecastCell+ConfigureForForecast.m
//  Weather
//
//  Created by Nicholas Cooke on 4/7/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "CityForecastCell+ConfigureForForecast.h"

@implementation CityForecastCell (ConfigureForForecast)

- (void)configureForForecast:(Forecast *)forecast {

    self.imageView.image = [self imageForConditions:forecast.currentForecast.icon];
    self.imageView.image = [self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.cityLabel.text = [forecast locationString];
    self.timeLabel.text = [self currentDateStringWithTimeZone:forecast.timeZone];
    self.temperatureLabel.text = [NSString stringWithFormat:@"%@°", [forecast currentTemperature]];
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
        systemImageName = @"tornado";
    } else if ([conditions isEqualToString:kDSwind]) {
        systemImageName = @"wind";
    } else {
        systemImageName = @"Unknown";
    }
    
    return [UIImage systemImageNamed:systemImageName];
}


# pragma mark - Private Helpers

- (NSString *)currentDateStringWithTimeZone:(NSTimeZone *)timezone {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = timezone;
    formatter.dateFormat = @"h:mm a";
    NSString *stringDate = [formatter stringFromDate:[NSDate date]];
    NSLog(@"It is %@ in %@", stringDate, timezone.name);
    return stringDate;
}

@end

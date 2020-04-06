//
//  DailyForecastCell+ConfigureForForecast.m
//  Weather
//
//  Created by Nicholas Cooke on 4/5/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DailyForecastCell+ConfigureForForecast.h"

@implementation DailyForecastCell (ConfigureForForecast)

- (void)configureForForecast:(DailyForecast *)forecast {
    UIImage *iconImage = [UIImage imageNamed:forecast.icon];
    [self.iconImageView setImage:iconImage];
    self.iconImageView.image = [self.iconImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.iconImageView setTintColor:UIColor.grayColor];//[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.0]];
    self.dayLabel.text = forecast.dayOfTheWeek;
    [self.dayLabel sizeToFit];
    self.highTempLabel.text = [forecast.maxTemperature stringValue];
    [self.highTempLabel sizeToFit];
    self.lowTempLabel.text = [forecast.minTemperature stringValue];
    [self.lowTempLabel sizeToFit];
    self.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.2]; //[UIColor.grayColor colorWithAlphaComponent:0.2];//[UIColor.whiteColor colorWithAlphaComponent:0.25]; //UIColor.lightTextColor;
}

@end

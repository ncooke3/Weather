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
    
    self.circleView.backgroundColor = [forecast currentColors][0];
    self.cityLabel.text = [forecast locationString];
    
}

@end

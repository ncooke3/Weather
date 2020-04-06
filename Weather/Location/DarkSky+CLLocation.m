//
//  DarkSky+CLLocation.m
//  Weather
//
//  Created by Nicholas Cooke on 4/4/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DarkSky+CLLocation.h"

@implementation DarkSky (CLLocation)

// TODO: clean this method's parameters up
- (void)getForecastForLocation:(CLLocation *)location completion:(ForecastResponseBlock)completion {
    CLLocationCoordinate2D coordinates = location.coordinate;
    [self getForecastForLatitude:coordinates.latitude longitude:coordinates.longitude time:nil excluding:nil extend:nil language:nil units:nil success:^(NSDictionary *forecastResponse) {
        completion(forecastResponse);
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [error description]);
        completion(nil);
    }];
}

@end

//
//  Store.m
//  Weather
//
//  Created by Nicholas Cooke on 4/7/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "Store.h"

@implementation Store

+ (Forecasts)forecasts {
    
    Forecast *atlanta = [[Forecast alloc] initForPlaceNamed:@"Atlanta" atLocation:[[CLLocation alloc] initWithLatitude:33.7490 longitude:-84.3880] withTimeZone:nil];

    Forecast *paris = [[Forecast alloc] initForPlaceNamed:@"Paris" atLocation:[[CLLocation alloc] initWithLatitude:48.8566 longitude:2.3522] withTimeZone:nil];
    
    Forecast *ghent = [[Forecast alloc] initForPlaceNamed:@"Ghent" atLocation:[[CLLocation alloc] initWithLatitude:51.0543 longitude:3.7174] withTimeZone:nil];
    
    Forecast *interlaken = [[Forecast alloc] initForPlaceNamed:@"Interlaken" atLocation:[[CLLocation alloc] initWithLatitude:46.6863 longitude:7.8632] withTimeZone:nil];
    
    Forecast *monterrey = [[Forecast alloc] initForPlaceNamed:@"Monterrey" atLocation:[[CLLocation alloc] initWithLatitude:25.6866 longitude:-100.3161] withTimeZone:nil];
    
    Forecast *seattle = [[Forecast alloc] initForPlaceNamed:@"Seattle" atLocation:[[CLLocation alloc] initWithLatitude:47.6062 longitude:-122.3321] withTimeZone:nil];

    Forecast *mykonos = [[Forecast alloc] initForPlaceNamed:@"Mykonos" atLocation:[[CLLocation alloc] initWithLatitude:37.4467 longitude:25.3289] withTimeZone:nil];
    
    return @[atlanta, paris, ghent, interlaken, monterrey, seattle, mykonos];
    
}

@end

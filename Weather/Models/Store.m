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

    
    Forecast *atlanta = [[Forecast alloc] initForLocation:[[CLLocation alloc] initWithLatitude:33.7490 longitude:-84.3880]];

    atlanta.locationString = @"Atlanta";
    
    Forecast *paris = [[Forecast alloc] initForLocation:[[CLLocation alloc] initWithLatitude:48.8566 longitude:2.3522]];
    paris.locationString = @"Paris";
    Forecast *ghent = [[Forecast alloc] initForLocation:[[CLLocation alloc] initWithLatitude:51.0543 longitude:3.7174]];
    ghent.locationString = @"Ghent";
    Forecast *interlaken = [[Forecast alloc] initForLocation:[[CLLocation alloc] initWithLatitude:46.6863 longitude:7.8632]];
    interlaken.locationString = @"Interlaken";
    Forecast *monterrey = [[Forecast alloc] initForLocation:[[CLLocation alloc] initWithLatitude:25.6866 longitude:-100.3161]];
    monterrey.locationString = @"Monterrey";
    Forecast *seattle = [[Forecast alloc] initForLocation:[[CLLocation alloc] initWithLatitude:47.6062 longitude:-122.3321]];
    seattle.locationString = @"Seattle";
    Forecast *mykonos = [[Forecast alloc] initForLocation:[[CLLocation alloc] initWithLatitude:37.4467 longitude:25.3289]];
    mykonos.locationString = @"Mykonos";
    
    return @[atlanta, paris, ghent, interlaken, monterrey, seattle, mykonos];
    
}

@end

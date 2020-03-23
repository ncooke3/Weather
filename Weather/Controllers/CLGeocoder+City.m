//
//  CLGeocoder+City.m
//  Weather
//
//  Created by Nicholas Cooke on 3/23/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "CLGeocoder+City.h"

@implementation CLGeocoder (City)

+ (void)cityFromLocation:(CLLocation *)location completion:(GeocoderCompletion)completion {
    [[CLGeocoder new] reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error) {
        if (error || !placemarks || placemarks.count == 0) { completion(nil); }
        completion(placemarks.firstObject);
    }];
}

@end

//
//  CLGeocoder+City.h
//  Weather
//
//  Created by Nicholas Cooke on 3/23/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef CLPlacemark * _Nullable Placemark;
typedef void(^GeocoderCompletion)(Placemark city);

@interface CLGeocoder (City)

+ (void)cityFromLocation:(CLLocation *)location completion:(GeocoderCompletion)completion;

@end

NS_ASSUME_NONNULL_END

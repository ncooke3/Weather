//
//  NSString+ForecastConditions.m
//  Weather
//
//  Created by Nicholas Cooke on 3/23/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "NSString+ForecastConditions.h"

@implementation NSString (ForecastConditions)

+ (NSString *)conditionsFrom:(NSString *)icon {
    if ([icon isEqualToString:kDSclearDay]) {
        return @"Clear";
    } else if ([icon isEqualToString:kDSclearNight]) {
        return @"Clear Night";
    } else if ([icon isEqualToString:kDScloudy]) {
        return @"Cloudy";
    } else if ([icon isEqualToString:kDSfog]) {
        return @"Foggy";
    } else if ([icon isEqualToString:kDShail]) {
        return @"Hail Showers";
    } else if ([icon isEqualToString:kDSpartlyCloudyDay]) {
        return @"Partly Cloudy";
    } else if ([icon isEqualToString:kDSpartlyCloudyNight]) {
        return @"Partly Cloudy";
    } else if ([icon isEqualToString:kDSrain]) {
        return @"Rain";
    } else if ([icon isEqualToString:kDSsleet]) {
        return @"Sleet";
    } else if ([icon isEqualToString:kDSsnow]) {
        return @"Snow";
    } else if ([icon isEqualToString:kDSthunderstorm]) {
        return @"Thunderstorm";
    } else if ([icon isEqualToString:kDStornado]) {
        return @"Tornado";
    } else if ([icon isEqualToString:kDSwind]) {
        return @"Windy";
    }
    
    return @"Unknown";
}

@end

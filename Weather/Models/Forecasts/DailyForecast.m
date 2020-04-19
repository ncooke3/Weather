//
//  DailyForecast.m
//  Weather
//
//  Created by Nicholas Cooke on 3/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DailyForecast.h"
#import "NSDateFormatter+UnixConverter.h"
#import "DarkSkyConstants.h"

@implementation DailyForecast

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _time = [dictionary[kDSTime] copy];
        _icon = [dictionary[kDSIcon] copy];
        _dayOfTheWeek = [NSDateFormatter weekdayFromDate:[NSDate dateWithTimeIntervalSince1970:_time.integerValue]];
        _minTemperature = @(round([(NSNumber*)[dictionary[kDSTemperatureMin] copy] doubleValue]));
        _maxTemperature = @(round([(NSNumber*)[dictionary[kDSTemperatureMax] copy] doubleValue]));
        _sunriseTime = [NSDate dateWithTimeIntervalSince1970:[[dictionary[kDSSunriseTime] copy] doubleValue]];
        _sunsetTime = [NSDate dateWithTimeIntervalSince1970:[[dictionary[kDSSunsetTime] copy] doubleValue]];
        _moonPhase = [[dictionary[kDSMoonPhase] copy] doubleValue];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [super init];
    if (self) {
        _time = [[decoder decodeObjectForKey:kDSTime] copy];
        _icon = [[decoder decodeObjectForKey:kDSIcon] copy];
        _dayOfTheWeek =  [[decoder decodeObjectForKey:@"dayOfTheWeek"] copy];
        _minTemperature = [[decoder decodeObjectForKey:kDSTemperatureMin] copy];
        _maxTemperature = [[decoder decodeObjectForKey:kDSTemperatureMax] copy];
        _sunriseTime = [[decoder decodeObjectForKey:kDSSunriseTime] copy];
        _sunsetTime = [[decoder decodeObjectForKey:kDSSunsetTime] copy];
        _moonPhase = [[[decoder decodeObjectForKey:kDSMoonPhase] copy] doubleValue];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    if (self.time != nil) [coder encodeObject:self.time forKey:kDSTime];
    if (self.icon != nil) [coder encodeObject:self.icon forKey:kDSIcon];
    if (self.dayOfTheWeek) [coder encodeObject:self.dayOfTheWeek forKey:@"dayOfTheWeek"];
    if (self.minTemperature) [coder encodeObject:self.minTemperature];
    if (self.maxTemperature) [coder encodeObject:self.maxTemperature];
    if (self.sunriseTime) [coder encodeObject:self.sunriseTime];
    if (self.sunsetTime) [coder encodeObject:self.sunsetTime];
    if (self.moonPhase) [coder encodeObject:@(self.moonPhase)];

}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - \n\t time: %@; \n\t icon: %@", [super description], _time, _icon];
}

- (NSString *)formattedMoonPhase {
    NSString *formattedMoonPhase;
    if (_moonPhase == 0) {
        formattedMoonPhase = @"New Moon";
    } else if (_moonPhase < 0.25) {
        formattedMoonPhase = @"Waxing Crescent";
    } else if (_moonPhase == 0.25) {
        formattedMoonPhase = @"First Quarter Moon";
    } else if (_moonPhase < 0.50) {
        formattedMoonPhase = @"Waxing Gibbous";
    } else if (_moonPhase == 0.50) {
        formattedMoonPhase = @"Full Moon";
    } else if (_moonPhase < 0.75) {
        formattedMoonPhase = @"Waning Gibbous";
    } else if (_moonPhase == 0.75) {
        formattedMoonPhase = @"Third Quarter";
    } else if (_moonPhase <= 1.00) {
        formattedMoonPhase = @"Waning Crescent";
    }
    return formattedMoonPhase;
}

- (BOOL)hasPrecipitation {
    return [@[@"rain", @"snow", @"sleet", @"hail", @"thunderstorm"] containsObject:_icon];
}

@end

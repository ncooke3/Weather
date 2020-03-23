//
//  HourlyForecast.m
//  Weather
//
//  Created by Nicholas Cooke on 3/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "HourlyForecast.h"

@implementation HourlyForecast

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _time = [dictionary[kDSTime] copy];
        _icon = [dictionary[kDSIcon] copy];
        _minTemperature = @(round([(NSNumber*)[dictionary[kDSTemperatureMin] copy] doubleValue]));
        _maxTemperature = @(round([(NSNumber*)[dictionary[kDSTemperatureMax] copy] doubleValue]));
        _precipProbability = [dictionary[kDSPrecipProbability] copy];
        _precipType = [dictionary[kDSPrecipType] copy];
        _humidity = [dictionary[kDSHumidity] copy];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [super init];
    if (self) {
        _time = [[decoder decodeObjectForKey:kDSTime] copy];
        _icon = [[decoder decodeObjectForKey:kDSIcon] copy];
        _minTemperature = [[decoder decodeObjectForKey:kDSTemperatureMin] copy];
        _maxTemperature = [[decoder decodeObjectForKey:kDSTemperatureMax] copy];
        _precipProbability = [[decoder decodeObjectForKey:kDSPrecipProbability] copy];
        _precipType = [[decoder decodeObjectForKey:kDSPrecipType] copy];
        _humidity = [[decoder decodeObjectForKey:kDSHumidity] copy];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    if (self.time != nil) [coder encodeObject:self.time forKey:kDSTime];
    if (self.icon != nil) [coder encodeObject:self.icon forKey:kDSIcon];
    if (self.minTemperature) [coder encodeObject:self.minTemperature];
    if (self.maxTemperature) [coder encodeObject:self.maxTemperature];
    if (self.precipProbability) [coder encodeObject:self.precipProbability];
    if (self.precipType) [coder encodeObject:self.precipType];
    if (self.humidity) [coder encodeObject:self.humidity];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - \n\t time: %@; \n\t icon: %@", [super description], _time, _icon];
}

@end

//
//  HourlyForecast.m
//  Weather
//
//  Created by Nicholas Cooke on 3/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "HourlyForecast.h"
#import "NSDateFormatter+UnixConverter.h"

@implementation HourlyForecast

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _time = [NSDateFormatter timeOfDayFrom:[NSDate dateWithTimeIntervalSince1970:[(NSNumber *)[dictionary[kDSTime] copy] integerValue]]];
        _icon = [dictionary[kDSIcon] copy];
        _temperature = @(round([(NSNumber*)[dictionary[kDSTemperature] copy] doubleValue]));
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
        _temperature = [[decoder decodeObjectForKey:kDSTemperature] copy];
        _precipProbability = [[decoder decodeObjectForKey:kDSPrecipProbability] copy];
        _precipType = [[decoder decodeObjectForKey:kDSPrecipType] copy];
        _humidity = [[decoder decodeObjectForKey:kDSHumidity] copy];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    if (self.time != nil) [coder encodeObject:self.time forKey:kDSTime];
    if (self.icon != nil) [coder encodeObject:self.icon forKey:kDSIcon];
    if (self.temperature) [coder encodeObject:self.temperature];
    if (self.precipProbability) [coder encodeObject:self.precipProbability];
    if (self.precipType) [coder encodeObject:self.precipType];
    if (self.humidity) [coder encodeObject:self.humidity];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - \n\t time: %@; \n\t icon: %@", [super description], _time, _icon];
}

@end

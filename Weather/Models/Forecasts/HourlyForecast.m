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

@synthesize temperature = _temperature;

- (NSNumber *)temperature {
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"units"]) {
        return @(round(([_temperature doubleValue] - 32.0) * .5556));
    }
    return _temperature;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _time = [NSDateFormatter hourOfDayFrom:[NSDate dateWithTimeIntervalSince1970:[(NSNumber *)[dictionary[kDSTime] copy] integerValue]]];
        _icon = [dictionary[kDSIcon] copy];
        _temperature = @(round([(NSNumber*)[dictionary[kDSTemperature] copy] doubleValue]));
        _precipProbability = @(round([[dictionary[kDSPrecipProbability] copy] doubleValue] * 100));
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
    if (self.temperature) [coder encodeObject:self.temperature forKey:kDSTemperature];
    if (self.precipProbability) [coder encodeObject:self.precipProbability forKey:kDSPrecipProbability];
    if (self.precipType) [coder encodeObject:self.precipType forKey:kDSPrecipType];
    if (self.humidity) [coder encodeObject:self.humidity forKey:kDSHumidity];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - \n\t time: %@; \n\t icon: %@", [super description], _time, _icon];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

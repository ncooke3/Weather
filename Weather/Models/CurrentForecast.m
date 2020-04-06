//
//  CurrentForecast.m
//  Weather
//
//  Created by Nicholas Cooke on 3/20/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "CurrentForecast.h"
#import "DarkSkyConstants.h"

@implementation CurrentForecast

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _time = [dictionary[kDSTime] copy];
        _icon = [dictionary[kDSIcon] copy];
        _temperature = @(round([(NSNumber*)[dictionary[kDSTemperature] copy] doubleValue]));
        _apparentTemperature = @(round([(NSNumber*)[dictionary[kDSApparentTemperature] copy] doubleValue]));
        _nearestStormDistance = [dictionary[kDSNearestStormDistance] copy];
        _nearestStormBearing = [dictionary[kDSNearestStormBearing] copy];
        _precipProbability = [dictionary[kDSPrecipProbability] copy];
        _precipIntensity = [dictionary[kDSPrecipIntensity] copy];
        _precipType = [dictionary[kDSPrecipType] copy];
        _humidity = [dictionary[kDSHumidity] copy];
        _pressure = [dictionary[kDSPressure] copy];
        _windSpeed = [dictionary[kDSWindSpeed] copy];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [super init];
    if (self) {
        _time = [[decoder decodeObjectForKey:kDSTime] copy];
        _icon = [[decoder decodeObjectForKey:kDSIcon] copy];
        _temperature = [[decoder decodeObjectForKey:kDSTemperature] copy];
        _apparentTemperature = [[decoder decodeObjectForKey:kDSApparentTemperature] copy];
        _nearestStormDistance = [[decoder decodeObjectForKey:kDSNearestStormDistance] copy];
        _nearestStormBearing = [[decoder decodeObjectForKey:kDSNearestStormBearing] copy];
        _precipProbability = [[decoder decodeObjectForKey:kDSPrecipProbability] copy];
        _precipIntensity = [[decoder decodeObjectForKey:kDSPrecipIntensity] copy];
        _precipType = [[decoder decodeObjectForKey:kDSPrecipType] copy];
        _humidity = [[decoder decodeObjectForKey:kDSHumidity] copy];
        _pressure = [[decoder decodeObjectForKey:kDSPressure] copy];
        _windSpeed = [[decoder decodeObjectForKey:kDSWindSpeed] copy];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    if (self.time != nil) [coder encodeObject:self.time forKey:kDSTime];
    if (self.icon != nil) [coder encodeObject:self.icon forKey:kDSIcon];
    if (self.temperature) [coder encodeObject:self.temperature forKey:kDSTemperature];
    if (self.apparentTemperature) [coder encodeObject:self.apparentTemperature forKey:kDSApparentTemperature];
    if (self.nearestStormDistance != nil) [coder encodeObject:self.nearestStormDistance forKey:kDSNearestStormDistance];
    if (self.nearestStormBearing != nil) [coder encodeObject:self.nearestStormBearing forKey:kDSNearestStormBearing];
    if (self.precipProbability != nil) [coder encodeObject:self.precipProbability forKey:kDSPrecipProbability];
    if (self.precipIntensity != nil) [coder encodeObject:self.precipIntensity forKey:kDSPrecipIntensity];
    if (self.precipType != nil) [coder encodeObject:self.precipType forKey:kDSPrecipType];
    if (self.humidity != nil) [coder encodeObject:self.humidity forKey:kDSHumidity];
    if (self.pressure != nil) [coder encodeObject:self.pressure forKey:kDSPressure];
    if (self.windSpeed != nil) [coder encodeObject:self.windSpeed forKey:kDSWindSpeed];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - \n\t time: %@; \n\t icon: %@", [super description], _time, _icon];
}

@end

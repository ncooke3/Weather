//
//  DailyForecast.m
//  Weather
//
//  Created by Nicholas Cooke on 3/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DailyForecast.h"
#import "NSDateFormatter+UnixConverter.h"

@implementation DailyForecast

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _time = [dictionary[kDSTime] copy];
        _icon = [dictionary[kDSIcon] copy];
        _dayOfTheWeek = [NSDateFormatter weekdayFromDate:[NSDate dateWithTimeIntervalSince1970:_time.integerValue]];
        _minTemperature = @(round([(NSNumber*)[dictionary[kDSTemperatureMin] copy] doubleValue]));
        _maxTemperature = @(round([(NSNumber*)[dictionary[kDSTemperatureMax] copy] doubleValue]));
    }
    return self;
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [super init];
    if (self) {
        _time = [[decoder decodeObjectForKey:kDSTime] copy];
        _icon = [[decoder decodeObjectForKey:kDSIcon] copy];
//        _dayOfTheWeek =  [[decoder decodeObjectForKey:@"dayOfTheWeek"] copy];
        _minTemperature = [[decoder decodeObjectForKey:kDSTemperatureMin] copy];
        _maxTemperature = [[decoder decodeObjectForKey:kDSTemperatureMax] copy];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    if (self.time != nil) [coder encodeObject:self.time forKey:kDSTime];
    if (self.icon != nil) [coder encodeObject:self.icon forKey:kDSIcon];
//    if (self.dayOfTheWeek) [coder encodeObject:self.dayOfTheWeek forKey:@"dayOfTheWeek"];
    if (self.minTemperature) [coder encodeObject:self.minTemperature];
    if (self.maxTemperature) [coder encodeObject:self.maxTemperature];

}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - \n\t time: %@; \n\t icon: %@", [super description], _time, _icon];
}

@end

//
//  HourlyForecast.h
//  Weather
//
//  Created by Nicholas Cooke on 3/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DarkSkyConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface HourlyForecast : NSObject <NSCoding, NSSecureCoding>

@property (nonatomic, readonly) NSString * time;
@property (nonatomic, readonly) NSString *icon;

// Temperature Properties
@property (nonatomic, readonly) NSNumber *temperature;

// Precipitation Properties
@property (nonatomic, readonly) NSNumber *precipProbability;
@property (nonatomic, readonly) NSString *precipType;

// Additional Weather Data Properties
@property (nonatomic, readonly) NSNumber *humidity;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andTimezone:(NSTimeZone *)timezone;


@end

NS_ASSUME_NONNULL_END

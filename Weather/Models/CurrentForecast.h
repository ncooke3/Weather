//
//  CurrentForecast.h
//  Weather
//
//  Created by Nicholas Cooke on 3/20/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrentForecast : NSObject<NSCoding>

@property (nonatomic, readonly) NSNumber *time;
@property (nonatomic, readonly) NSString *icon;

// Temperature Properties
@property (nonatomic, readonly) NSNumber *temperature;
@property (nonatomic, readonly) NSNumber *apparentTemperature;

// Storm Properties
@property (nonatomic, readonly) NSNumber  *nearestStormDistance;
@property (nonatomic, readonly) NSNumber  *nearestStormBearing;

// Precipitation Properties
@property (nonatomic, readonly) NSNumber *precipProbability;
@property (nonatomic, readonly) NSNumber *precipIntensity;
@property (nonatomic, readonly) NSString *precipType;

// Additional Weather Data Properties
@property (nonatomic, readonly) NSNumber *humidity;
@property (nonatomic, readonly) NSNumber *pressure;
@property (nonatomic, readonly) NSNumber *windSpeed;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

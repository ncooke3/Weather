//
//  DailyForecast.h
//  Weather
//
//  Created by Nicholas Cooke on 3/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyForecast : NSObject<NSCoding>

@property (nonatomic, readonly) NSNumber *time;
@property (nonatomic, readonly) NSString *icon;

@property (nonatomic, readonly) NSString *dayOfTheWeek;

// Temperature Properties
@property (nonatomic, readonly) NSNumber *minTemperature;
@property (nonatomic, readonly) NSNumber *maxTemperature;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

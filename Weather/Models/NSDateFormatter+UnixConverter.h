//
//  NSDateFormatter+UnixConverter.h
//  Weather
//
//  Created by Nicholas Cooke on 3/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (UnixConverter)

+ (NSString *)weekdayFromDate:(NSDate *)date;
+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)dateStyle andTimezone:(NSTimeZone *)timezone;
+ (NSString *)hourOfDayFrom:(NSDate *)date forTimezone:(NSTimeZone *)timezone;
+ (NSString *)timeOfDayFrom:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END

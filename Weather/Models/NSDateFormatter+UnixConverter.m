//
//  NSDateFormatter+UnixConverter.m
//  Weather
//
//  Created by Nicholas Cooke on 3/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "NSDateFormatter+UnixConverter.h"

@implementation NSDateFormatter (UnixConverter)

+ (NSString *)weekdayFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E"];
    return [formatter stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)dateStyle andTimezone:(NSTimeZone *)timezone {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = timezone;
    [formatter setDateFormat:dateStyle];
    return [formatter stringFromDate:date];
}

+ (NSString *)hourOfDayFrom:(NSDate *)date forTimezone:(NSTimeZone *)timezone {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = timezone;
    [formatter setDateFormat:@"ha"];
    return [formatter stringFromDate:date];
}

+ (NSString *)timeOfDayFrom:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm"];
    return [formatter stringFromDate:date];
}

@end

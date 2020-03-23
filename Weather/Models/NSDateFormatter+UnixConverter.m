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
    return [formatter stringFromDate:date];;
}

@end

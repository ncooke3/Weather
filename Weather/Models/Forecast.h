//
//  Forecast.h
//  Weather
//
//  Created by Nicholas Cooke on 3/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DarkSkyConstants.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ForecastType) {
    ForecastTypeCurrently,
    ForecastTypeHourly,
    ForecastTypeDaily
};


/**
* An abstract class representing a Forecast object.
*/
@interface Forecast : NSObject

@end

NS_ASSUME_NONNULL_END

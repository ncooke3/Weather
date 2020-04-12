//
//  Store.h
//  Weather
//
//  Created by Nicholas Cooke on 4/7/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>

// Models
#import "Forecast.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSArray<Forecast *> * Forecasts;

@interface Store : NSObject

+ (Forecasts)forecasts;

@end

NS_ASSUME_NONNULL_END

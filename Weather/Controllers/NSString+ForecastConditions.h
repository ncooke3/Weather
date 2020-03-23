//
//  NSString+ForecastConditions.h
//  Weather
//
//  Created by Nicholas Cooke on 3/23/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DarkSkyConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ForecastConditions)

+ (NSString *)conditionsFrom:(NSString *)icon;

@end

NS_ASSUME_NONNULL_END

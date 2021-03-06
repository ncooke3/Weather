//
//  WeatherViewController.h
//  Weather
//
//  Created by Nicholas Cooke on 4/4/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "Forecast.h"

#import "WeatherScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherViewController : UIViewController

@property (nonatomic) Forecast *forecast;
@property (nonatomic) WeatherScrollView *weatherScrollView;

- (instancetype)initWithForecast:(Forecast *)forecast;

@end

NS_ASSUME_NONNULL_END

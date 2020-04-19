//
//  WeatherScrollView.h
//  Weather
//
//  Created by Nicholas Cooke on 3/28/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

// Views
#import "DailyForecastCell.h"

@class DailyForecast;

NS_ASSUME_NONNULL_BEGIN

@interface WeatherScrollView : UIScrollView

//@property (nonatomic) ForecastDataSource *dataSource;
@property (nonatomic) UICollectionView *forecastCollectionView;

@property (nonatomic, copy) void (^configureCell)(DailyForecastCell *, DailyForecast *);

@property (nonatomic) UILabel *weatherTickerLabel;

- (void)updateTemperatureLabel:(NSString *)temperature;
- (void)updateWeatherConditionsLabel:(NSString *)conditions;
- (void)updateWeatherTicker:(NSString *)info;
- (void)refreshTemperaturePlotWithData:(NSArray *)data;
- (void)updateSolarLunarViewWithData:(NSDictionary *)data;
- (void)animateLayerColorsWith:(NSArray<UIColor *> *)colors;

@end

NS_ASSUME_NONNULL_END

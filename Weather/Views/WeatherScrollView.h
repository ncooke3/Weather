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

@property (nonatomic) UILabel *locationLabel;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) UILabel *temperatureLabel;

@property (nonatomic) UICollectionView *forecastCollectionView;
@property (nonatomic, copy) void (^configureCell)(DailyForecastCell *, DailyForecast *);
@property (nonatomic) UILabel *weatherTickerLabel;

@property (nonatomic) UILabel *conditionsLabel;

- (void)fadeOutLabels;
- (void)fadeInLabels;
- (void)updateLocationLabelsWithLocation:(NSString *)location;
- (void)updateTemperatureLabel:(NSString *)temperature;
- (void)updateWeatherConditionsLabel:(NSString *)conditions;
- (void)updateWeatherTicker:(NSString *)info;
- (void)updateApparentTemperatureLabel:(NSString *)apparentTemperature;
- (void)refreshTemperaturePlotWithData:(NSArray *)data;
- (void)updateSolarLunarViewWithData:(NSDictionary *)data;
- (void)animateLayerColorsWith:(NSArray<UIColor *> *)colors;
- (void)showPrecipitationView;
- (void)refreshPrecipitationPlotWithData:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END

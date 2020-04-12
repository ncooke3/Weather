//
//  WeatherViewController.m
//  Weather
//
//  Created by Nicholas Cooke on 4/4/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "WeatherViewController.h"

// Views
#import "WeatherScrollView.h"

// Models
#import "ForecastDataSource.h"

@interface WeatherViewController ()

@property (nonatomic) WeatherScrollView *weatherScrollView;
@property (nonatomic, retain) ForecastDataSource *dataSource;

@end

@implementation WeatherViewController

- (WeatherScrollView *)weatherScrollView {
    if (!_weatherScrollView) {
        _weatherScrollView = [[WeatherScrollView alloc] init];
    }
    return _weatherScrollView;
}

- (void)loadView {
    self.view = self.weatherScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CLLocation *atl = [[CLLocation alloc] initWithLatitude:33.7490 longitude:-84.3880];
    _forecast = [[Forecast alloc] initForLocation:atl];

    weakify(self)
    [_forecast updateForecasts:^{
        strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [self configureForecastDataSource];
            [self handleCurrentForecastUpdate];
            [self handleHourlyForecastUpdate];
        });
    }];
    
}

- (void)configureForecastDataSource {
    self.dataSource = [[ForecastDataSource alloc] initWithItems:self.forecast.dailyForecasts cellIdentifier:@"dailyForecastCell" configureCellBlock:self.weatherScrollView.configureCell];
    self.weatherScrollView.forecastCollectionView.dataSource = self.dataSource;
}

#pragma mark - Handlers

- (void)handleCurrentForecastUpdate {
    [self.weatherScrollView updateTemperatureLabel:[_forecast currentTemperature]];
    [self.weatherScrollView updateWeatherConditionsLabel:[_forecast currentConditions]];
    [self startWeatherFeedWith:[[_forecast currentWeatherFeed] mutableCopy]];
    [self.weatherScrollView animateLayerColorsWith:[_forecast currentColors]];
}

- (void)handleHourlyForecastUpdate {
    [self.weatherScrollView refreshTemperaturePlotWithData:[_forecast hourlyTemperatures]];
}

// TODO: create that UIControl subclass
- (void)startWeatherFeedWith:(NSMutableArray *)feed {
    [self.weatherScrollView.weatherTickerLabel setText:feed[0]];
    self.weatherScrollView.weatherTickerLabel.alpha = 1;
    
    if (feed) { return; } // silences warning until further develoopment
    
    if ([feed count] == 0) {
        return;
    }
    
    UIViewPropertyAnimator *fadeInAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:8 curve:UIViewAnimationCurveEaseInOut animations:^{ self.weatherScrollView.weatherTickerLabel.alpha = 1; }];
    
    UIViewPropertyAnimator *fadeOutAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:8 curve:UIViewAnimationCurveEaseInOut animations:^{ self.weatherScrollView.weatherTickerLabel.alpha = 0; }];

    [fadeInAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        [fadeOutAnimator startAnimation];
    }];
    
    [fadeOutAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
    
        id firstObject = feed[0];
        [feed removeObjectAtIndex:0];
        [feed addObject:firstObject];
        
        [self startWeatherFeedWith:feed];
    }];
    
    [fadeInAnimator startAnimation];
}

@end

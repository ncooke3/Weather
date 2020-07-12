//
//  WeatherViewController.m
//  Weather
//
//  Created by Nicholas Cooke on 4/4/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "WeatherViewController.h"

// Views
//#import "WeatherScrollView.h"

// Models
#import "ForecastDataSource.h"

// Categories
#import "NSDateFormatter+UnixConverter.h"

@interface WeatherViewController ()


@property (nonatomic, retain) ForecastDataSource *dataSource;

@end

@implementation WeatherViewController

- (instancetype)initWithForecast:(Forecast *)forecast {
    self = [super init];
    if (self) {
        _forecast = forecast;
    }
    return self;
}

- (WeatherScrollView *)weatherScrollView {
    if (!_weatherScrollView) {
        _weatherScrollView = [[WeatherScrollView alloc] init];
    }
    return _weatherScrollView;
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIUserInterfaceStyle currentUIStyle = UITraitCollection.currentTraitCollection.userInterfaceStyle;
    if (currentUIStyle == UIUserInterfaceStyleDark) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modalPresentationCapturesStatusBarAppearance = YES;
    
    UITapGestureRecognizer *developmentTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)];
    [self.view addGestureRecognizer:developmentTapRecognizer];
    
    self.weatherScrollView = [[WeatherScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.weatherScrollView];
    
    [self configureForecastDataSource];
    [self handleDate];
    [self handleCurrentForecastUpdate];
    [self handleHourlyForecastUpdate];
    [self handleDailyForecastUpdate];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [_weatherScrollView fadeInLabels];
}

- (void)configureForecastDataSource {
    self.dataSource = [[ForecastDataSource alloc] initWithItems:self.forecast.dailyForecasts cellIdentifier:@"dailyForecastCell" configureCellBlock:self.weatherScrollView.configureCell];
    self.weatherScrollView.forecastCollectionView.dataSource = self.dataSource;
}

#pragma mark - Handlers

- (void)handleDate {
    self.weatherScrollView.dateLabel.text = [NSDateFormatter stringFromDate:[NSDate date] withDateFormat:@"E MMM d" andTimezone:_forecast.timeZone];
}

- (void)handleCurrentForecastUpdate {
    [self.weatherScrollView updateLocationLabelsWithLocation:[_forecast locationString]];
    [self.weatherScrollView updateTemperatureLabel:[_forecast currentTemperature]];
    [self.weatherScrollView updateWeatherConditionsLabel:[_forecast currentConditions]];
    [self.weatherScrollView updateApparentTemperatureLabel:[_forecast currentFeelsLikeTemperature]];
    [self.weatherScrollView animateLayerColorsWith:[_forecast currentColors]];
}

- (void)handleHourlyForecastUpdate {
    [self.weatherScrollView refreshTemperaturePlotWithData:[_forecast hourlyTemperatures]];
}

- (void)handleDailyForecastUpdate {
    
    NSDate *currentDate = [NSDate date];
    DailyForecast *todayDailyForecast = [self.forecast.dailyForecasts objectAtIndex:0];
    DailyForecast *tomorrowDailyForecast = [self.forecast.dailyForecasts objectAtIndex:1];
    
    NSString *sunPhase;
    NSString *time;
    
    if ([currentDate compare:todayDailyForecast.sunriseTime] == NSOrderedAscending ||
        [currentDate compare:todayDailyForecast.sunsetTime] == NSOrderedSame) {
        // It is early morning so show moon + sunrise time and today's sun + sunset time.
        sunPhase = @"Sunrise";
        time = [NSDateFormatter timeOfDayFrom:todayDailyForecast.sunriseTime];
        
    } else if ([currentDate compare:todayDailyForecast.sunsetTime] == NSOrderedAscending ||
               [currentDate compare:todayDailyForecast.sunsetTime] == NSOrderedSame) {
        // It is day time so show sun + sunset time and moon + tomorrow's sunrise time.
        sunPhase = @"Sunset";
        time = [NSDateFormatter timeOfDayFrom:todayDailyForecast.sunsetTime];
        
    } else {
        // It is in the evening so show moon + tomorrow's sunrise time and tomorrow's sunset time.
        sunPhase = @"Sunrise";
        time = [NSDateFormatter timeOfDayFrom:tomorrowDailyForecast.sunriseTime];
    }
    
    [_weatherScrollView updateSunriseSunsetForPhase:sunPhase atTime:time];
    
}

// TODO: create that UIControl subclass
- (void)startWeatherFeedWith:(NSMutableArray *)feed {
    [self.weatherScrollView.weatherTickerLabel setText:feed[0]];
    self.weatherScrollView.weatherTickerLabel.alpha = 1;
}

@end

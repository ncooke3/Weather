//
//  WeatherScrollView.m
//  Weather
//
//  Created by Nicholas Cooke on 3/28/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "WeatherScrollView.h"

// Views
#import "GraphView.h"
#import "ForecastCollectionViewFlowLayout.h"
#import "MoonButton.h"
#import "SolarLunarView.h"

// Categories
#import "NSDateFormatter+UnixConverter.h"
#import "NSLayoutAnchor+Pinto.h"
#import "UIColor+WeatherColors.h"
#import "DailyForecastCell+ConfigureForForecast.h"

@interface WeatherScrollView () <UIScrollViewDelegate, UICollectionViewDelegate>

// Location Properties
@property (nonatomic) UILabel *locationLabel;
@property (nonatomic) UILabel *pinnedLocationLabel;

// Time & Date Properties
@property (nonatomic) UILabel *dateLabel;

// Current Forecast Properties
@property (nonatomic) UILabel *temperatureLabel;
@property (nonatomic) UILabel *conditionsLabel;

@property (nonatomic) UILabel *pinnedTemperatureLabel;

// Animating Gradient Layer
@property (nonatomic) CAGradientLayer *animatingGradientLayer;

// CollectionView
@property (nonatomic) UILabel *forecastCollectionViewLabel;


// Weather Plots
@property (nonatomic) GraphView *temperaturePlot;
@property (nonatomic) GraphView *precipitationPlot;

// Sun/Moon View
@property (nonatomic) SolarLunarView *sunMoonInfoView;
@property (nonatomic) NSLayoutConstraint *sunMoonInfoViewBottomConstraint;

@end

@implementation WeatherScrollView

- (UILabel *)pinnedLocationLabel {
    if (!_pinnedLocationLabel) {
        _pinnedLocationLabel = [[UILabel alloc] init];
        _pinnedLocationLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _pinnedLocationLabel.text = _locationLabel.text;
        _pinnedLocationLabel.textColor = UIColor.darkTextColor;
        _pinnedLocationLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        _pinnedLocationLabel.alpha = 0;
    }
    return _pinnedLocationLabel;
}

- (UILabel *)pinnedTemperatureLabel {
    if (!_pinnedTemperatureLabel) {
        _pinnedTemperatureLabel = [[UILabel alloc] init];
        _pinnedTemperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _pinnedTemperatureLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        _pinnedTemperatureLabel.textColor = UIColor.darkTextColor;
        _pinnedTemperatureLabel.alpha = 0;
    }
    return _pinnedTemperatureLabel;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
        // TODO: user defaults - last stored location
        _locationLabel.font = [UIFont systemFontOfSize:36 weight:UIFontWeightBold];
        _locationLabel.textColor = UIColor.darkTextColor;
        _locationLabel.adjustsFontSizeToFitWidth = YES;
        _locationLabel.minimumScaleFactor = 0.50;
    }
    return _locationLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _dateLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _dateLabel.textColor = UIColor.darkTextColor;
        _dateLabel.text = [NSDateFormatter stringFromDate:[NSDate date] withDateFormat:@"E MMM d"]; // MARK: add to settings userdefaults!
    }
    return _dateLabel;
}

- (UILabel *)temperatureLabel {
    if (!_temperatureLabel) {
        _temperatureLabel = [[UILabel alloc] init];
        _temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _temperatureLabel.font = [UIFont systemFontOfSize:72 weight:UIFontWeightBold];
        _temperatureLabel.textColor = UIColor.darkTextColor;
    }
    return _temperatureLabel;
}

- (UILabel *)conditionsLabel {
    if (!_conditionsLabel) {
        _conditionsLabel = [[UILabel alloc] init];
        _conditionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _conditionsLabel.font = [UIFont systemFontOfSize:34 weight:UIFontWeightMedium];
        _conditionsLabel.textColor = UIColor.darkTextColor;
    }
    return _conditionsLabel;
}

- (UILabel *)weatherTickerLabel {
    if (!_weatherTickerLabel) {
        _weatherTickerLabel = [[UILabel alloc] init];
        _weatherTickerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _weatherTickerLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        _weatherTickerLabel.textColor = UIColor.darkTextColor;
    }
    return _weatherTickerLabel;
}

- (CAGradientLayer *)animatingGradientLayer {
    if (!_animatingGradientLayer) {
        _animatingGradientLayer = [[CAGradientLayer alloc] init];
    }
    return _animatingGradientLayer;
}

- (GraphView *)temperaturePlot {
    if (!_temperaturePlot) {
        _temperaturePlot = [[GraphView alloc] init];
        _temperaturePlot.labelUnits = @"°";
        _temperaturePlot.strokeColor = [UIColor colorNamed:@"weatherBackgroundColor"];
        _temperaturePlot.labelFontColor = [UIColor colorNamed:@"weatherBackgroundColor"];
        _temperaturePlot.pointFillColor = [UIColor systemGray5Color];
    }
    return _temperaturePlot;
}

- (UILabel *)forecastCollectionViewLabel {
    if (!_forecastCollectionViewLabel) {
        _forecastCollectionViewLabel = [[UILabel alloc] init];
        _forecastCollectionViewLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _forecastCollectionViewLabel.text = @"Weekly Forecast";
        _forecastCollectionViewLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightMedium];
        _forecastCollectionViewLabel.textColor = UIColor.secondaryLabelColor;
        _forecastCollectionViewLabel.alpha = 0;
    }
    return _forecastCollectionViewLabel;
}

- (UICollectionView *)forecastCollectionView {
    if (!_forecastCollectionView) {
        ForecastCollectionViewFlowLayout *forecastLayout = [[ForecastCollectionViewFlowLayout alloc] init];
        _forecastCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:forecastLayout];
        _forecastCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_forecastCollectionView registerClass:DailyForecastCell.class forCellWithReuseIdentifier:@"dailyForecastCell"];
        _forecastCollectionView.showsHorizontalScrollIndicator = NO;
        _forecastCollectionView.backgroundColor = self.backgroundColor;
    }
    return _forecastCollectionView;
}

- (GraphView *)precipitationPlot {
    if (!_precipitationPlot) {
        _precipitationPlot = [[GraphView alloc] init];
        _precipitationPlot.labelUnits = @"%";
        _precipitationPlot.labelFontColor = UIColor.secondaryLabelColor;
        _precipitationPlot.strokeColor = UIColor.systemGray3Color;
        _precipitationPlot.strokeFillColor = UIColor.systemGray3Color;
        _precipitationPlot.pointFillColor = [UIColor systemGray5Color];
    }
    return _precipitationPlot;
}

- (SolarLunarView *)sunMoonInfoView {
    if (!_sunMoonInfoView) {
        _sunMoonInfoView = [[SolarLunarView alloc] init];
        _sunMoonInfoView.translatesAutoresizingMaskIntoConstraints = NO;
        _sunMoonInfoView.layer.cornerRadius = 15.0;
    }
    return _sunMoonInfoView;
}

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor colorNamed:@"weatherBackgroundColor"];
        
        self.userInteractionEnabled = YES;
        self.delegate = self;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.showsVerticalScrollIndicator = NO;
        self.automaticallyAdjustsScrollIndicatorInsets = NO;
        self.forecastCollectionView.delegate = self;
    
        [self.layer insertSublayer:self.animatingGradientLayer atIndex:0];
        [self configureCellBlock];
        
        /// Pinned Location Label
        [self addSubview:self.pinnedLocationLabel];
        [_pinnedLocationLabel.topAnchor pinTo:self.safeAreaLayoutGuide.topAnchor];
        [_pinnedLocationLabel.centerXAnchor pinTo:self.centerXAnchor];
        
        /// Pinned Temperature Label
        [self addSubview:self.pinnedTemperatureLabel];
        [_pinnedTemperatureLabel.topAnchor pinTo:_pinnedLocationLabel.bottomAnchor withPadding:5];
        [_pinnedTemperatureLabel.centerXAnchor pinTo:self.centerXAnchor];
        
        /// Location Label
        [self addSubview:self.locationLabel];
        [_locationLabel.topAnchor pinTo:self.topAnchor withPadding:80];
        [_locationLabel.leadingAnchor pinTo:self.leadingAnchor withPadding:40];
        [_locationLabel.trailingAnchor pinTo:self.trailingAnchor withPadding:-15];

        /// Date Label
        [self addSubview:self.dateLabel];
        [_dateLabel.topAnchor pinTo:_locationLabel.bottomAnchor withPadding:8];
        [_dateLabel.leadingAnchor pinTo:_locationLabel.leadingAnchor];
                
        /// Temperature Label
        [self addSubview:self.temperatureLabel];
        [_temperatureLabel.leadingAnchor pinTo:_locationLabel.leadingAnchor];
        [[_temperatureLabel.topAnchor constraintEqualToSystemSpacingBelowAnchor:self.topAnchor multiplier:30] setActive:YES];
        
        /// Conditions Label
        [self addSubview:self.conditionsLabel];
        [_conditionsLabel.topAnchor pinTo:_temperatureLabel.bottomAnchor withPadding:8];
        [_conditionsLabel.leadingAnchor pinTo:_locationLabel.leadingAnchor];
        
        /// Apparent Temperature Label
        [self addSubview:self.weatherTickerLabel];
        [_weatherTickerLabel.topAnchor pinTo:_conditionsLabel.bottomAnchor withPadding:8];
        [_weatherTickerLabel.leadingAnchor pinTo:_locationLabel.leadingAnchor];
        
        /// Temperature Plot
        [self addSubview:self.temperaturePlot];
        _temperaturePlot.frame = CGRectMake(self.frame.size.width  * -0.01,
                                            self.frame.size.height * 2.0 / 3.0,
                                            self.frame.size.width  * 1.02,
                                            self.frame.size.height * 1.0/3.0);
        
        /// Forecast CollectionView & Label
        [self addSubview:self.forecastCollectionViewLabel];
        [_forecastCollectionViewLabel.topAnchor pinTo:_temperaturePlot.bottomAnchor withPadding:15];
        [_forecastCollectionViewLabel.leadingAnchor pinTo:self.leadingAnchor withPadding:30];
        
        [self addSubview:self.forecastCollectionView];
        [_forecastCollectionView.topAnchor pinTo:_forecastCollectionViewLabel.bottomAnchor withPadding:10];
        [_forecastCollectionView.leadingAnchor pinTo:_forecastCollectionViewLabel.leadingAnchor withPadding:-5];
        [[_forecastCollectionView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:.85] setActive:YES];
        [[_forecastCollectionView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.2 constant:0] setActive:YES];
        
        // Sun/Moon Info View
        [self addSubview:self.sunMoonInfoView];
        [_sunMoonInfoView.topAnchor pinTo:self.forecastCollectionView.bottomAnchor withPadding:10];
        [_sunMoonInfoView.leadingAnchor pinTo:_forecastCollectionViewLabel.leadingAnchor];
        [[_sunMoonInfoView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:1] setActive:YES];
        [[_sunMoonInfoView.heightAnchor constraintEqualToConstant:120] setActive:YES];
        _sunMoonInfoViewBottomConstraint = [_sunMoonInfoView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-50];
        [_sunMoonInfoViewBottomConstraint setActive:YES];
        
        // MARK: precipitation plot is handled by showPrecipitationView: method
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectIsEmpty(_animatingGradientLayer.frame)) {
        _animatingGradientLayer.frame = CGRectMake(0, -1000, self.frame.size.width, 1000 + self.frame.size.height);
    }
}

#pragma mark - Utils

- (void)configureCellBlock {
    _configureCell = ^(DailyForecastCell *cell, DailyForecast *dailyForecast) {
        [cell configureForForecast:dailyForecast];
    };
}

# pragma mark - Public Methods

- (void)updateLocationLabelsWithLocation:(NSString *)location {
    [_locationLabel setText:location];
    [_pinnedLocationLabel setText:location];
}

- (void)updateTemperatureLabel:(NSString *)temperature {
    NSString *formattedTemperatureString = [NSString stringWithFormat:@"%@°", temperature];
    [_temperatureLabel setText:formattedTemperatureString];
    [_pinnedTemperatureLabel setText:formattedTemperatureString];
}

- (void)updateWeatherConditionsLabel:(NSString *)conditions {
    [_conditionsLabel setText:conditions];
}

- (void)updateWeatherTicker:(NSString *)info {
    [_weatherTickerLabel setText:info];
}

- (void)updateApparentTemperatureLabel:(NSString *)apparentTemperature {
    _weatherTickerLabel.text = [NSString stringWithFormat:@"Feels like %@°", apparentTemperature];
}

- (void)refreshTemperaturePlotWithData:(NSArray *)data {
    [_temperaturePlot plotWithData:data];
}

- (void)animateLayerColorsWith:(NSArray<UIColor *> *)colors {
    _animatingGradientLayer.colors = @[(id)colors[1].CGColor, (id)colors[0].CGColor];
    _animatingGradientLayer.startPoint = CGPointZero;
    _animatingGradientLayer.endPoint = CGPointMake(0, 1);
    
    CABasicAnimation *colorsAnimation = [CABasicAnimation animationWithKeyPath:@"colors"];
    colorsAnimation.fromValue = _animatingGradientLayer.colors;
    colorsAnimation.toValue = @[(id)colors[0].CGColor, (id)colors[1].CGColor];
    colorsAnimation.duration = 10;
    colorsAnimation.repeatCount = INFINITY;
    colorsAnimation.autoreverses = YES;
    
    [_animatingGradientLayer addAnimation:colorsAnimation forKey:@"colorAnimation"];
    
}

- (void)updateSolarLunarViewWithData:(NSDictionary *)data {
    [_sunMoonInfoView setData:data];
}

- (void)showPrecipitationView {
    [self addSubview:self.precipitationPlot];
    
    _precipitationPlot.translatesAutoresizingMaskIntoConstraints = NO;
    [_sunMoonInfoViewBottomConstraint setActive:NO];

    [_precipitationPlot.topAnchor pinTo:_sunMoonInfoView.bottomAnchor withPadding:20];
    [[_precipitationPlot.widthAnchor constraintEqualToConstant:self.frame.size.width * 1.02] setActive:YES];
    [[_precipitationPlot.heightAnchor constraintEqualToConstant:self.frame.size.height * 0.20] setActive:YES];
    [_precipitationPlot.centerXAnchor pinTo:self.centerXAnchor];
    
    [_precipitationPlot layoutIfNeeded];
    
    UIView *precipitationFooterView = [[UIView alloc] init];
    precipitationFooterView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:precipitationFooterView];
    [precipitationFooterView.topAnchor pinTo:_precipitationPlot.bottomAnchor];
    [precipitationFooterView.widthAnchor pinTo:self.widthAnchor];
    [precipitationFooterView.centerXAnchor pinTo:self.centerXAnchor];
    [[precipitationFooterView.heightAnchor constraintEqualToConstant:1000] setActive:YES];
    [precipitationFooterView.bottomAnchor pinTo:self.bottomAnchor withPadding:950];
    precipitationFooterView.backgroundColor = _precipitationPlot.strokeFillColor;
    
    UILabel *precipitationLabel = [[UILabel alloc] init];
    precipitationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    precipitationLabel.text = @"Rain Forecast";
    precipitationLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightMedium];
    precipitationLabel.textColor = UIColor.secondaryLabelColor;;
    precipitationLabel.alpha = 1;
    
    [precipitationFooterView addSubview:precipitationLabel];
    [precipitationLabel.bottomAnchor pinTo:precipitationFooterView.topAnchor];
    [precipitationLabel.leadingAnchor pinTo:_forecastCollectionViewLabel.leadingAnchor];
    
}

- (void)refreshPrecipitationPlotWithData:(NSArray *)data {
    [_precipitationPlot plotWithData:data];
}

- (CGFloat)slidingValueWithx0:(CGFloat)x0 x1:(CGFloat)x1 y0:(CGFloat)y0 y1:(CGFloat)y1 x:(CGFloat)x {
    CGFloat m = (y1-y0)/(x1-x0);
    CGFloat b = y1 - m * x1;
    CGFloat maxY = y1 > y0 ? y1 : y0;
    CGFloat minY = y1 > y0 ? y0 : y1;
    CGFloat y = m * x + b;
    return MAX(MIN(y, maxY), minY);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView != self) { return; }

    CGFloat offset = 25;
    
    _pinnedLocationLabel.alpha = [self slidingValueWithx0:CGRectGetMinY(_locationLabel.frame) - offset x1:CGRectGetMinY(_locationLabel.frame) + offset y0:0 y1:1 x:scrollView.contentOffset.y];
    _locationLabel.alpha = [self slidingValueWithx0:0 x1:50 y0:1 y1:0 x:scrollView.contentOffset.y];
    _dateLabel.alpha = [self slidingValueWithx0:10 x1:60 y0:1 y1:0 x:scrollView.contentOffset.y];
    
    _temperatureLabel.alpha = [self slidingValueWithx0:CGRectGetMaxY(_dateLabel.frame) - offset x1:CGRectGetMaxY(_dateLabel.frame) + offset y0:1 y1:0 x:scrollView.contentOffset.y];
    _pinnedTemperatureLabel.alpha = (1 - _temperatureLabel.alpha) - _temperatureLabel.alpha;
    
    if (_temperatureLabel.alpha == 0) {
        _pinnedLocationLabel.alpha = [self slidingValueWithx0:CGRectGetMinY(_temperaturePlot.frame) - 150 x1:CGRectGetMinY(_temperaturePlot.frame) - 80 y0:1 y1:0 x:scrollView.contentOffset.y];
        _pinnedTemperatureLabel.alpha = [self slidingValueWithx0:CGRectGetMinY(_temperaturePlot.frame) - 140 x1:CGRectGetMinY(_temperaturePlot.frame) - 90 y0:1 y1:0 x:scrollView.contentOffset.y];
    }
    
    _conditionsLabel.alpha = [self slidingValueWithx0:CGRectGetMaxY(_dateLabel.frame) x1:CGRectGetMaxY(_dateLabel.frame) + 4 * offset y0:1 y1:0 x:scrollView.contentOffset.y];
    _weatherTickerLabel.alpha = [self slidingValueWithx0:CGRectGetMaxY(_dateLabel.frame) + 2 * offset x1:CGRectGetMaxY(_dateLabel.frame) + 5 * offset y0:1 y1:0 x:scrollView.contentOffset.y];
    
    _forecastCollectionViewLabel.alpha = [self slidingValueWithx0:0 x1:200 y0:0 y1:1 x:scrollView.contentOffset.y];
    _forecastCollectionView.alpha = [self slidingValueWithx0:0 x1:200 y0:0 y1:1 x:scrollView.contentOffset.y];
    
    _sunMoonInfoView.alpha = [self slidingValueWithx0:250 x1:400 y0:0 y1:1 x:scrollView.contentOffset.y];
    
    //_precipitationPlot.alpha = [self slidingValueWithx0:500 x1:600 y0:0 y1:1 x:scrollView.contentOffset.y];
    
}

# pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.forecastCollectionView.frame.size.width / 5 - 10, self.forecastCollectionView.frame.size.height);
}

@end

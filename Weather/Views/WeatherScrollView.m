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
@property (nonatomic) GraphView *precipitationPlot; // add layer if you add it

// Sun/Moon View
@property (nonatomic) UIView *sunMoonInfoView;

@end

@implementation WeatherScrollView

- (UILabel *)pinnedLocationLabel {
    if (!_pinnedLocationLabel) {
        _pinnedLocationLabel = [[UILabel alloc] init];
        _pinnedLocationLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _pinnedLocationLabel.text = @"Atlanta";//_locationLabel.text;
        _pinnedLocationLabel.textColor = UIColor.darkTextColor;
        _pinnedLocationLabel.font = [UIFont fontWithName:@"Futura-Bold" size:16];
        _pinnedLocationLabel.alpha = 0;
    }
    return _pinnedLocationLabel;
}

- (UILabel *)pinnedTemperatureLabel {
    if (!_pinnedTemperatureLabel) {
        _pinnedTemperatureLabel = [[UILabel alloc] init];
        _pinnedTemperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _pinnedTemperatureLabel.font = [UIFont fontWithName:@"Futura-Bold" size:16];
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
        _locationLabel.text = @"Atlanta";
        _locationLabel.font = [UIFont fontWithName:@"Futura-Bold" size:36];
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
        _dateLabel.font = [UIFont fontWithName:@"Futura-Medium" size:16];
        _dateLabel.textColor = UIColor.darkGrayColor;
        // TODO: format based on user prefs
        _dateLabel.text = [NSDateFormatter stringFromDate:[NSDate date] withDateFormat:@"E MMM d"];
    }
    return _dateLabel;
}

- (UILabel *)temperatureLabel {
    if (!_temperatureLabel) {
        _temperatureLabel = [[UILabel alloc] init];
        _temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _temperatureLabel.font = [UIFont fontWithName:@"Futura-Bold" size:72];
        _temperatureLabel.textColor = UIColor.darkTextColor;
    }
    return _temperatureLabel;
}

- (UILabel *)conditionsLabel {
    if (!_conditionsLabel) {
        _conditionsLabel = [[UILabel alloc] init];
        _conditionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _conditionsLabel.font = [UIFont fontWithName:@"Futura-Medium" size:34];
        _conditionsLabel.textColor = UIColor.darkTextColor;
    }
    return _conditionsLabel;
}

- (UILabel *)weatherTickerLabel {
    if (!_weatherTickerLabel) {
        _weatherTickerLabel = [[UILabel alloc] init];
        _weatherTickerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _weatherTickerLabel.font = [UIFont fontWithName:@"Futura-Medium" size:20];
        _weatherTickerLabel.textColor = UIColor.darkGrayColor;
    }
    return _weatherTickerLabel;
}

- (CAGradientLayer *)animatingGradientLayer {
    if (!_animatingGradientLayer) {
        _animatingGradientLayer = [[CAGradientLayer alloc] init];
        _animatingGradientLayer.startPoint = CGPointZero;
        _animatingGradientLayer.endPoint = CGPointMake(1, 1);
        UIColor *darkerBlue = [UIColor colorWithRed:0.63 green:0.77 blue:0.99 alpha:1.00];
        UIColor *lightBlue = [UIColor colorWithRed:0.76 green:0.91 blue:0.98 alpha:1.00];
        _animatingGradientLayer.colors = @[(id)darkerBlue.CGColor, (id)lightBlue.CGColor];
    }
    return _animatingGradientLayer;
}

- (GraphView *)temperaturePlot {
    if (!_temperaturePlot) {
        _temperaturePlot = [[GraphView alloc] init];
        _temperaturePlot.labelUnits = @"°"; // set to user defaults settings!
        _temperaturePlot.strokeColor = self.backgroundColor;
        _temperaturePlot.labelFontColor = self.backgroundColor;
    }
    return _temperaturePlot;
}

- (UILabel *)forecastCollectionViewLabel {
    if (!_forecastCollectionViewLabel) {
        _forecastCollectionViewLabel = [[UILabel alloc] init];
        _forecastCollectionViewLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _forecastCollectionViewLabel.text = @"Weekly Forecast";
        _forecastCollectionViewLabel.font = [UIFont fontWithName:@"Futura-Medium" size:22];
        _forecastCollectionViewLabel.textColor = UIColor.grayColor;
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
        _precipitationPlot.backgroundColor = UIColor.blueColor;
    }
    return _precipitationPlot;
}

- (UIView *)sunMoonInfoView { // GradientView from fluid interfaces?
    if (!_sunMoonInfoView) {
        _sunMoonInfoView = [[UIView alloc] init];
        _sunMoonInfoView.translatesAutoresizingMaskIntoConstraints = NO;
        _sunMoonInfoView.backgroundColor = [UIColor.grayColor colorWithAlphaComponent:0.2];
        _sunMoonInfoView.layer.cornerRadius = 15.0;
    }
    return _sunMoonInfoView;
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
    
        self.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];//[UIColor whitishBackgroundColor];
        self.userInteractionEnabled = YES;
        /// POTENTIAL REFACTOR:
        ///
        /// WeatherViewController.m
        ///     viewDidLoad { self.weatherScrollView.delegate = self; }
        ///     ...
        ///     viewDidScroll { _weatherScrollView fadeLablesWithContentOffset: _weatherScrollView.contentOffset }
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
        
        /// Forecast CollectionView & Label
        [self addSubview:self.forecastCollectionViewLabel];
        [_forecastCollectionViewLabel.topAnchor pinTo:_temperaturePlot.bottomAnchor withPadding:15];
        [_forecastCollectionViewLabel.leadingAnchor pinTo:self.leadingAnchor withPadding:30];
        
        [self addSubview:self.forecastCollectionView];
        [_forecastCollectionView.topAnchor pinTo:_forecastCollectionViewLabel.bottomAnchor withPadding:10];
        [_forecastCollectionView.leadingAnchor pinTo:_forecastCollectionViewLabel.leadingAnchor withPadding:-5];
        [[_forecastCollectionView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:.85] setActive:YES];
        [[_forecastCollectionView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.2 constant:0] setActive:YES];
        
        // Precipitation Plot
        // [self addSubview:self.precipitationPlot];
        // MARK: Set top left positition of plot so if you display it, it will size accordingly from there
        
        // Sun/Moon Info View
        [self addSubview:self.sunMoonInfoView];
        //[_sunMoonInfoView.topAnchor pinTo:self.topAnchor withPadding:1200]; //1200
        [_sunMoonInfoView.topAnchor pinTo:self.forecastCollectionView.bottomAnchor withPadding:50]; //1200
        [_sunMoonInfoView.centerXAnchor pinTo:self.centerXAnchor];
        [[_sunMoonInfoView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:.9] setActive:YES];
        [[_sunMoonInfoView.heightAnchor constraintEqualToConstant:120] setActive:YES];
        [_sunMoonInfoView.bottomAnchor pinTo:self.bottomAnchor withPadding:-50];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _temperaturePlot.frame = CGRectMake(self.frame.size.width  * -0.01,
                                        self.frame.size.height * 2.0 / 3.0,
                                        self.frame.size.width  * 1.02,
                                        self.frame.size.height * 1.0/3.0);
    
//    _precipitationPlot.frame = CGRectMake(self.frame.size.width  * -0.01,
//                                          _forecastCollectionView.frame.size.height * 6.75,
//                                          self.frame.size.width  * 1.02,
//                                          self.frame.size.height * 0.25);
    
    _animatingGradientLayer.frame = CGRectMake(0, -1000, self.frame.size.width, 1000 + self.frame.size.height);
}

#pragma mark - Utils

- (void)configureCellBlock {
    _configureCell = ^(DailyForecastCell *cell, DailyForecast *dailyForecast) {
        [cell configureForForecast:dailyForecast];
    };
}

# pragma mark - Public Methods

- (void)displayLocationLabelsWithLocation:(NSString *)location { }

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

- (void)refreshTemperaturePlotWithData:(NSArray *)data {
    [_temperaturePlot plotWithData:data];
}

- (void)animateLayerColorsWith:(NSArray<UIColor *> *)colors {
    _animatingGradientLayer.colors = @[(id)colors[0].CGColor, (id)colors[1].CGColor];
    _animatingGradientLayer.startPoint = CGPointZero;
    _animatingGradientLayer.endPoint = CGPointMake(0, 1);
    
    CABasicAnimation *colorsAnimation = [CABasicAnimation animationWithKeyPath:@"colors"];
    colorsAnimation.fromValue = _animatingGradientLayer.colors;
    colorsAnimation.toValue = @[(id)colors[2].CGColor, (id)colors[3].CGColor];;
    colorsAnimation.duration = 10;
    colorsAnimation.repeatCount = INFINITY;
    colorsAnimation.autoreverses = YES;
    
    [_animatingGradientLayer addAnimation:colorsAnimation forKey:@"colorAnimation"];
    
    _temperaturePlot.pointFillColor = colors[3];
}

- (void)fadeLabelsWithContentOffset:(CGFloat)contentOffset { }

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // TODO: fade labels accordingly
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (scrollView != self) { return; }
    
    CGFloat locationLabelRatio = MIN(1, (2 * MAX(0, MIN(1, (scrollView.contentOffset.y / _locationLabel.frame.origin.y)))));
    _locationLabel.alpha = 1 - locationLabelRatio;
    
    CGFloat dateLabelRatio = MIN(1, (2 * MAX(0, MIN(1, (scrollView.contentOffset.y / _dateLabel.frame.origin.y)))));
    _dateLabel.alpha = 1 - dateLabelRatio;

    CGFloat pinnedLocationLabelRatio = MIN(1, MAX(0, MIN(1, ((scrollView.contentOffset.y - _locationLabel.frame.origin.y + _pinnedLocationLabel.frame.size.height) / _locationLabel.frame.origin.y))));
    _pinnedLocationLabel.alpha = pinnedLocationLabelRatio;
    
    _temperatureLabel.alpha = MAX(0, MIN(1, ((_temperatureLabel.frame.origin.y - scrollView.contentOffset.y) - 65) / (125 - 65)));
    _pinnedTemperatureLabel.alpha = (1 - _temperatureLabel.alpha) - _temperatureLabel.alpha;
    _conditionsLabel.alpha = MAX(0, MIN(1, ((_conditionsLabel.frame.origin.y - scrollView.contentOffset.y) - 85) / (125 - 85)));
    _weatherTickerLabel.alpha = MAX(0, MIN(1, ((_weatherTickerLabel.frame.origin.y - scrollView.contentOffset.y) - 85) / (125 - 85)));
    
    _forecastCollectionViewLabel.alpha = 1 - MAX(0, MIN(1, ((_forecastCollectionViewLabel.frame.origin.y - scrollView.contentOffset.y) - 600) / (800 - 600)));
//    _precipitationLabel.alpha = 1 - MAX(0, MIN(1, ((_precipitationLabel.frame.origin.y - scrollView.contentOffset.y) - 760) / (800 - 760)));
}

# pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.forecastCollectionView.frame.size.width / 5 - 10, self.forecastCollectionView.frame.size.height);
}

@end

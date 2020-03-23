//
//  WeatherController.m
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "WeatherController.h"

// Views
#import "DailyForecastCell.h"

// Categories
#import "NSDateFormatter+UnixConverter.h"
#import "WeatherController+WeatherController_Forecasts.h"
#import "NSString+ForecastConditions.h"

@interface WeatherController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIRefreshControl *refreshControl;

// Location Properties
@property (nonatomic) UILabel *locationLabel;

// Time & Date Properties
@property (nonatomic) UILabel *dateLabel;

// Current Forecast Properties
@property (nonatomic) UILabel *temperatureLabel;
@property (nonatomic) UILabel *conditionsLabel;
@property (nonatomic) UILabel *apparentTemperatureLabel;

// Weekly Forecast Properties
@property (nonatomic) UICollectionView *collectionView;

// Hourly Forecast Properties
// TODO: Hourly Temperature, Humidity, & Precipitation Charts

@end

@implementation WeatherController

- (DarkSky *)darksky {
    if (!_darksky) {
        _darksky = [DarkSky sharedManagager];
        [_darksky clearCache]; // MARK: clearCache enabled!
    }
    return _darksky;
}

-(CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = kCLLocationAccuracyKilometer;
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.95 alpha:1.0]];
    
    [self updateCurrentForecast];
    [self updateDailyForecasts];
    [self updateHourlyForecasts];
    
    [self configureScrollView];
    [self configureCollectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self handleLocationManagerAuthorization];
}

#pragma mark - Networking

- (void)updateCurrentForecast {
    typeof(self) weakSelf = self;
    [self getCurrentForecast:^(ForecastResponse forecast) {
        if (forecast == nil) { return; }
        weakSelf.currentForecast = [[CurrentForecast alloc] initWithDictionary:forecast];
        dispatch_async(dispatch_get_main_queue(), ^{ [weakSelf displayCurrentForecast]; });
    }];
}

- (void)updateDailyForecasts {
    typeof(self) weakSelf = self;
    [self getDailyForecasts:^(ForecastResponse dailyForecasts) {
        if (dailyForecasts == nil) { return; }
        // TODO: observe lifecycle of updatedDailyForecasts
        NSMutableArray<DailyForecast *> *updatedDailyForecasts = [[NSMutableArray alloc] init];
        for (NSDictionary *forecast in dailyForecasts) {
            DailyForecast *dailyForecast = [[DailyForecast alloc] initWithDictionary:forecast];
            [updatedDailyForecasts addObject:dailyForecast];
        }
        weakSelf.dailyForecasts = [updatedDailyForecasts copy];
        dispatch_async(dispatch_get_main_queue(), ^{ [weakSelf displayDailyForecasts]; });
    }];
}

- (void)updateHourlyForecasts {
    typeof(self) weakSelf = self;
    [self getHourlyForecasts:^(ForecastResponse hourlyForecasts) {
        if (hourlyForecasts == nil) { return; }
        // TODO: observe lifecycle of updatedHourlyForecasts
        NSMutableArray<HourlyForecast *> *updatedHourlyForecasts = [[NSMutableArray alloc] init];
        for (NSDictionary *forecast in hourlyForecasts) {
            HourlyForecast *hourlyForecast = [[HourlyForecast alloc] initWithDictionary:forecast];
            [updatedHourlyForecasts addObject:hourlyForecast];
        }
        weakSelf.hourlyForecasts = updatedHourlyForecasts;
        dispatch_async(dispatch_get_main_queue(), ^{ [weakSelf displayHourlyForecast]; });
    }];
}

#pragma mark - Subview Configuration

- (void)configureCollectionView {
    UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setSectionInset:UIEdgeInsetsMake(0, 5, 0, 5)];
    [layout setMinimumInteritemSpacing:0];
    
    CGRect collectionViewFrame = CGRectMake(25, self.view.frame.size.height + 20, self.view.frame.size.width - 50, self.view.frame.size.height / 5);
    _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:DailyForecastCell.class forCellWithReuseIdentifier:@"cell"];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.95 alpha:1.0]];
    [self.scrollView addSubview:_collectionView];
}

- (void)configureScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 1.5 * self.view.bounds.size.height);
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, -1000, self.view.bounds.size.width, 1000 + self.view.bounds.size.height - 50);
    layer.backgroundColor = [[UIColor colorWithRed:0.89 green:0.81 blue:0.71 alpha:1.0] CGColor];
    [_scrollView.layer addSublayer:layer];
    [self configureLocationLabel];
    [_scrollView addSubview:self.locationLabel];
    [self configureDateLabel];
    [_scrollView addSubview:self.dateLabel];
    [self configureTemperatureLabel];
    [_scrollView addSubview:self.temperatureLabel];
    [self setupConditionsLabel];
    [_scrollView addSubview:self.conditionsLabel];
    [self configureApparentTemperatureLabel];
    [_scrollView addSubview:self.apparentTemperatureLabel];
    [self configureRefreshControl];
    [_scrollView addSubview:_refreshControl];
    [self.view addSubview:_scrollView];
}

- (void)configureRefreshControl {
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = UIColor.lightTextColor;
    [_refreshControl addTarget:self action:@selector(handleRefreshCurrentForecast:) forControlEvents:UIControlEventValueChanged];
}

- (void)handleRefreshCurrentForecast:(UIRefreshControl *)sender {
    [self updateCurrentForecast];
    [sender endRefreshing];
}

- (void)configureLocationLabel {
    CGRect locationLabelFrame = CGRectMake(40, 80, 0, 0);
    _locationLabel = [[UILabel alloc] initWithFrame: locationLabelFrame];
    _locationLabel.text = @"Cupertino"; // MARK: user defaults - last stored location
    _locationLabel.font = [UIFont fontWithName:@"Futura-Bold" size:36];
    _locationLabel.textColor = UIColor.darkTextColor;
    [_locationLabel sizeToFit];
}

- (void)configureDateLabel {
    CGRect dateLabelFrame = CGRectMake(self.locationLabel.frame.origin.x, self.locationLabel.frame.origin.y + self.locationLabel.frame.size.height + 8, 0, 0);
    _dateLabel = [[UILabel alloc] initWithFrame:dateLabelFrame];
    _dateLabel.font = [UIFont fontWithName:@"Futura-Medium" size:16];
    _dateLabel.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.0];
    _dateLabel.text = [NSDateFormatter stringFromDate:[NSDate date] withDateFormat:@"E MMM d"];
    [_dateLabel sizeToFit];
}

- (void)configureTemperatureLabel {
    CGRect temperatureLabelFrame = CGRectMake(self.dateLabel.frame.origin.x, self.scrollView.frame.size.height / 3, 0, 0);
    _temperatureLabel = [[UILabel alloc] initWithFrame:temperatureLabelFrame];
    _temperatureLabel.font = [UIFont fontWithName:@"Futura-Bold" size:72];
    _temperatureLabel.textColor = UIColor.darkTextColor;
    _temperatureLabel.text = @"13°";
    [_temperatureLabel sizeToFit];
}

- (void)setupConditionsLabel {
    CGRect conditionsLabelFrame = CGRectMake(self.dateLabel.frame.origin.x, self.scrollView.frame.size.height / 3 + 90, 0, 0);
    _conditionsLabel = [[UILabel alloc] initWithFrame:conditionsLabelFrame];
    _conditionsLabel.font = [UIFont fontWithName:@"Futura-Medium" size:34];
    _conditionsLabel.textColor = UIColor.darkTextColor;
    _conditionsLabel.text = @"Heavy Rain";
    [_conditionsLabel sizeToFit];
}

- (void)configureApparentTemperatureLabel {
    CGRect apparentTemperatureLabelFrame = CGRectMake(self.dateLabel.frame.origin.x, self.scrollView.frame.size.height / 3 + 135, 0, 0);
    _apparentTemperatureLabel = [[UILabel alloc] initWithFrame:apparentTemperatureLabelFrame];
    _apparentTemperatureLabel.font = [UIFont fontWithName:@"Futura-Medium" size:20];
    _apparentTemperatureLabel.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.0];
    _apparentTemperatureLabel.text = @"Feels like 11°";
    [_apparentTemperatureLabel sizeToFit];
}

- (void)updateLocationLabelWithLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError *error) {
        
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *firstLocation = placemarks.firstObject;
            if (![self.locationLabel.text isEqualToString:firstLocation.locality]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.locationLabel setText:firstLocation.locality];
                    [self.locationLabel sizeToFit];
                });
            }
        }
    }];
}

#pragma mark - Forecast Update Handling

- (void)displayCurrentForecast {
    self.temperatureLabel.text = [NSString stringWithFormat:@"%@°",
    [_currentForecast.temperature stringValue]];
    [self.temperatureLabel sizeToFit];
    self.conditionsLabel.text = [NSString conditionsFrom:_currentForecast.icon];
    [self.conditionsLabel sizeToFit];
    self.apparentTemperatureLabel.text = [NSString stringWithFormat:@"Feels like %@°", _currentForecast.apparentTemperature];
    [self.apparentTemperatureLabel sizeToFit];
}

- (void)displayDailyForecasts {
    [_collectionView reloadData];
}

- (void)displayHourlyForecast {
    // update charts
}

# pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dailyForecasts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DailyForecastCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[DailyForecastCell alloc] init];
    }
    
    [cell setBackgroundColor:UIColor.lightTextColor];
    
    UIImage *iconImage = [UIImage imageNamed:_dailyForecasts[indexPath.row].icon];
    [cell.iconImageView setImage:iconImage];
    cell.iconImageView.image = [cell.iconImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [cell.iconImageView setTintColor:[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.0]];
    cell.dayLabel.text = _dailyForecasts[indexPath.row].dayOfTheWeek;
    [cell.dayLabel sizeToFit];
    cell.highTempLabel.text = [_dailyForecasts[indexPath.row].maxTemperature stringValue];
    [cell.highTempLabel sizeToFit];
    cell.lowTempLabel.text = [_dailyForecasts[indexPath.row].minTemperature stringValue];
    [cell.lowTempLabel sizeToFit];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width / 5 - 10, self.view.frame.size.height / 5);
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // MARK: check to see if already tracking? is it ok that it gets called twice?
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if ([locations count]) {
        NSLog(@"%@", locations.lastObject);
        [self updateLocationLabelWithLocation:locations.lastObject];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
}

- (CLLocationCoordinate2D)currentLocationCoordinate {
    return self.locationManager.location.coordinate;
}

- (void)handleLocationManagerAuthorization {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        // If status is not determined, then we should ask for authorization.
        [self.locationManager requestAlwaysAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        // If authorization has been denied previously, inform the user.
        NSLog(@"%s: location services authorization was previously denied by the user.", __PRETTY_FUNCTION__);
        // Display alert to the user.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location services" message:@"Location services were previously denied by the user. Please enable location services for this app in settings." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}]; // Do nothing action to dismiss the alert.
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

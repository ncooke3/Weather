//
//  WeatherController.m
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "WeatherController.h"
#import "DailyForecastCell.h"
#import "DarkSky.h"

@interface WeatherController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) UIScrollView *scrollView;

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

@implementation WeatherController {
    DarkSky *darksky;
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
    
    darksky = [DarkSky sharedManagager];
    [darksky clearCache]; // MARK: clearCache enabled!
    
    [self configureScrollView];
    [self configureCollectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self handleLocationManagerAuthorization];

}

#pragma mark - Networking

- (void)currentForecast {
    CLLocationCoordinate2D location = [self currentLocationCoordinate];
    NSNumber *time = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];

    [darksky getForecastForLatitude:location.latitude longitude:location.longitude time:time excluding:@[] extend:@"" language:@"" units:@"us" success:^(NSDictionary *forecastJSON) {
        
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [error description]);
        
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
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1.50 * self.view.frame.size.height);
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, -self.view.frame.size.width, self.view.frame.size.width, self.view.frame.size.width + self.view.frame.size.height - 50);
    layer.backgroundColor = [[UIColor colorWithRed:0.89 green:0.81 blue:0.71 alpha:1.0] CGColor];
    
    [_scrollView.layer addSublayer:layer];
    
    [self setupLocationLabel];
    [_scrollView addSubview:self.locationLabel];
    
    [self setupDateLabel];
    [_scrollView addSubview:self.dateLabel];
    
    [self setupTemperatureLabel];
    [_scrollView addSubview:self.temperatureLabel];
    
    [self setupConditionsLabel];
    [_scrollView addSubview:self.conditionsLabel];
    
    [self configureApparentTemperatureLabel];
    [_scrollView addSubview:self.apparentTemperatureLabel];
    
    [self.view addSubview:_scrollView];
}

- (void)setupLocationLabel {
    CGRect locationLabelFrame = CGRectMake(40, 80, 0, 0);
    self.locationLabel = [[UILabel alloc] initWithFrame: locationLabelFrame];
    
    // TODO: Access device location and update label accordingly.
    NSString *locationString = @"Cupertino";

    NSDictionary<NSAttributedStringKey, id> *locationStringAttributes = @{
        NSFontAttributeName: [UIFont fontWithName:@"Futura-Bold" size:36],
        NSForegroundColorAttributeName: UIColor.darkTextColor
    };
    NSAttributedString *locationAttributedString = [[NSAttributedString alloc] initWithString:locationString attributes:locationStringAttributes];
    
    [self.locationLabel setAttributedText:locationAttributedString];
    [self.locationLabel sizeToFit];
}

- (void)setupDateLabel {
    CGRect dateLabelFrame = CGRectMake(self.locationLabel.frame.origin.x, self.locationLabel.frame.origin.y + self.locationLabel.frame.size.height + 8, 0, 0);
    self.dateLabel = [[UILabel alloc] initWithFrame:dateLabelFrame];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // TODO: provide different options for changing presentation style
    [dateFormatter setDateFormat:@"E MMM d"];
    
    // TODO: make sure properly updates at midnight
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSDictionary<NSAttributedStringKey, id> *dateStringAttributes = @{
        NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:16],
        NSForegroundColorAttributeName: [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.0]
    };
    NSAttributedString *dateAttributedString = [[NSAttributedString alloc] initWithString:dateString attributes:dateStringAttributes];
    
    [self.dateLabel setAttributedText:dateAttributedString];
    [self.dateLabel sizeToFit];
}

- (void)setupTemperatureLabel {
    self.temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.dateLabel.frame.origin.x, self.scrollView.frame.size.height / 3, 0, 0)];
    
    NSDictionary<NSAttributedStringKey, id> *temperatureLabelAttributes = @{
        NSFontAttributeName: [UIFont fontWithName:@"Futura-Bold" size:72],
        NSForegroundColorAttributeName: UIColor.darkTextColor
    };
    NSAttributedString *temperatureAttributedString = [[NSAttributedString alloc] initWithString:@"13°" attributes:temperatureLabelAttributes];
    
    [self.temperatureLabel setAttributedText:temperatureAttributedString];
    [self.temperatureLabel sizeToFit];
}

- (void)setupConditionsLabel {
    self.conditionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.dateLabel.frame.origin.x, self.scrollView.frame.size.height / 3 + 90, 0, 0)];
    
    NSDictionary<NSAttributedStringKey, id> *conditionsLabelAttributes = @{
        NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:34],
        NSForegroundColorAttributeName: UIColor.darkTextColor
    };
    NSAttributedString *temperatureAttributedString = [[NSAttributedString alloc] initWithString:@"Heavy Rain" attributes:conditionsLabelAttributes];
    
    [self.conditionsLabel setAttributedText:temperatureAttributedString];
    [self.conditionsLabel sizeToFit];
}

- (void)configureApparentTemperatureLabel {
    self.apparentTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.dateLabel.frame.origin.x, self.scrollView.frame.size.height / 3 + 135, 0, 0)];
    
    NSDictionary<NSAttributedStringKey, id> *feelsLikeLabelAttributes = @{
        NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:20],
        NSForegroundColorAttributeName: [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.0]
    };
    NSAttributedString *temperatureAttributedString = [[NSAttributedString alloc] initWithString:@"Feels like 11°" attributes:feelsLikeLabelAttributes];
    
    [self.apparentTemperatureLabel setAttributedText:temperatureAttributedString];
    [self.apparentTemperatureLabel sizeToFit];
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
                });
            }
            
        }
    }];
}

# pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected cell");
}

# pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DailyForecastCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[DailyForecastCell alloc] init];
    }
    
    [cell setBackgroundColor:UIColor.lightTextColor];
    
    UIImage *iconImage = [UIImage imageNamed:@"partly-cloudy-day"];
    [cell.iconImageView setImage:iconImage];
    cell.iconImageView.image = [cell.iconImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [cell.iconImageView setTintColor:[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1.0]];
    
    
    [cell.dayLabel setText:@"Fri"];
    [cell.highTempLabel setText:@"12"];
    [cell.lowTempLabel setText:@"3"];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( self.collectionView.frame.size.width / 5 - 10, self.view.frame.size.height / 5);
    
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
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}]; // Do nothing action to dismiss the alert.
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

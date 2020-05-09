//
//  MenuViewController.m
//  Weather
//
//  Created by Nicholas Cooke on 4/7/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "MenuViewController.h"

// Models
#import "Store.h"
#import "ForecastDataSource.h"

// View Controllers
#import "WeatherViewController.h"
#import "MapViewController.h"

// Transition Delegates
#import "WeatherTransitioningDelegate.h"

// Views
#import "CityForecastCell+ConfigureForForecast.h"
#import "RoundButton.h"

// Categories
#import "UIView+Pinto.h"
#import "NSLayoutAnchor+Pinto.h"

@interface MenuViewController () <UICollectionViewDelegate>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) ForecastDataSource *dataSource;
@property (nonatomic) WeatherTransitioningDelegate *weatherTransitioningDelegate;
@property (nonatomic) UIButton *settingsButton;

@property (nonatomic) NSArray<Forecast *> *cityForecasts;

@end

@implementation MenuViewController

- (NOPersistentStore *)weatherCache {
    if (!_weatherCache) {
        _weatherCache = [NOPersistentStore cacheWithId:@"persistentStoreId"];
    }
    return _weatherCache;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:UICollectionViewFlowLayout.new];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        [_collectionView registerClass:CityForecastCell.class forCellWithReuseIdentifier:@"cityCell"];
    }
    return _collectionView;
}

- (void)layoutCollectionView {
    _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [_collectionView.topAnchor pinTo:self.view.topAnchor];
    [_collectionView.leadingAnchor pinTo:self.view.leadingAnchor];
    [_collectionView.trailingAnchor pinTo:self.view.trailingAnchor];
    [_collectionView.bottomAnchor pinTo:self.view.bottomAnchor];
}

- (void)configureCollectionViewDataSource {
    self.dataSource = [[ForecastDataSource alloc] initWithItems:[Store forecasts] cellIdentifier:@"cityCell" configureCellBlock:^(CityForecastCell *cell, Forecast *forecast) { [cell configureForForecast:forecast]; }];
    self.collectionView.dataSource = self.dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForNotifications];

    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    self.title = @"Weather";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    _weatherTransitioningDelegate = [[WeatherTransitioningDelegate alloc] init];
    
    [self.view addSubview:self.collectionView];
    [self layoutCollectionView];
    
    dispatch_group_t forecastGroup = dispatch_group_create();

    _cityForecasts = [self.weatherCache objectForKey:@"forecasts"];
    if (_cityForecasts == nil) {
        _cityForecasts = [NSArray new];
    }
    
    // Configure data source
    self.dataSource = [[ForecastDataSource alloc] initWithItems:_cityForecasts cellIdentifier:@"cityCell" configureCellBlock:^(CityForecastCell *cell, Forecast *forecast) { [cell configureForForecast:forecast]; }];
    self.collectionView.dataSource = self.dataSource;
    
    // Forecast Updating Code
    for (NSInteger index = 0; index < self.dataSource.items.count; index++) {
        Forecast *forecast = [self.dataSource itemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        dispatch_group_enter(forecastGroup);
        [forecast updateForecasts:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
                } completion:nil];
            });
            dispatch_group_leave(forecastGroup);
        }];
    }

    dispatch_group_notify(forecastGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.weatherCache setObject:self.dataSource.items forKey:@"forecasts"];
    });
    
    RoundButton *addCityButton = [[RoundButton alloc] initWithSystemImageNamed:@"plus.circle"];
    [self.view addSubview:addCityButton];
    [addCityButton.trailingAnchor pinTo:self.view.trailingAnchor withPadding:-40];
    [addCityButton.bottomAnchor pinTo:self.view.bottomAnchor withPadding:-40];
    [addCityButton addTarget:self action:@selector(handleAddCityButton) forControlEvents:UIControlEventTouchUpInside];

    RoundButton *settingsButton = [[RoundButton alloc] initWithSystemImageNamed:@"gear"];
    [self.view addSubview:settingsButton];
    [settingsButton.leadingAnchor pinTo:self.view.leadingAnchor withPadding:40];
    [settingsButton.bottomAnchor pinTo:self.view.bottomAnchor withPadding:-40];
    [settingsButton addTarget:self action:@selector(handleSettingsButton) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)handleAddCityButton {
    MapViewController *mapViewController = [MapViewController new];
    UINavigationController *addCityNavController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    [self.navigationController presentViewController:addCityNavController animated:YES completion:nil];
}

- (void)handleSettingsButton {
    
}

#pragma mark - NSNotificationCenter

- (void)registerForNotifications {
    [NSNotificationCenter.defaultCenter addObserverForName:@"com.ncooke.newForecastFetched" object:nil queue:nil usingBlock:^(NSNotification * notification) {
        NSLog(@"notification received");
        NSDictionary *info = notification.userInfo;
        if (info) {
            Forecast *updatedForecast = (Forecast *)info[@"forecast"];
            NSInteger index = [info[@"index"] integerValue];
            [self.dataSource.items replaceObjectAtIndex:index withObject:updatedForecast];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
                } completion:nil];
            });
        }
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell setHighlighted:YES];
    
    WeatherViewController *weatherViewController = [[WeatherViewController alloc] init];
    weatherViewController.forecast = [self.dataSource itemAtIndexPath:indexPath];
    weatherViewController.transitioningDelegate = _weatherTransitioningDelegate;
    _weatherTransitioningDelegate.startingCenter = [selectedCell convertPoint:selectedCell.center toView:self.view];
    weatherViewController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:weatherViewController animated:YES completion:^{ [selectedCell setHighlighted:NO]; }];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, 70);
}

@end

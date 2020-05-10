////
////  DevelopmentViewController.m
////  Weather
////
////  Created by Nicholas Cooke on 4/7/20.
////  Copyright © 2020 Nicholas Cooke. All rights reserved.
////
//
//#import "DevelopmentViewController.h"
//
//// Models
//#import "Store.h"
//#import "ForecastDataSource.h"
//
//// View Controllers
//#import "WeatherViewController.h"
//#import "MapViewController.h"
//
//// Transition Delegates
//#import "WeatherTransitioningDelegate.h"
//
//// Views
//#import "CityForecastCell+ConfigureForForecast.h"
//#import "RoundButton.h"
//
//// Categories
//#import "UIView+Pinto.h"
//#import "NSLayoutAnchor+Pinto.h"
//
//@interface DevelopmentViewController () <UITableViewDelegate>
//
//@property (nonatomic) ForecastDataSource *dataSource;
//@property (nonatomic) WeatherTransitioningDelegate *weatherTransitioningDelegate;
//@property (nonatomic) UIButton *settingsButton;
//@property (nonatomic) NSArray<Forecast *> *cityForecasts;
//
//@property (nonatomic) UITableView *tableView;
//
//@end
//
//@implementation DevelopmentViewController
//
//- (NOPersistentStore *)weatherCache {
//    if (!_weatherCache) {
//        _weatherCache = [NOPersistentStore cacheWithId:@"persistentStoreId"];
//    }
//    return _weatherCache;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 70;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self registerForNotifications];
//
//    self.view.backgroundColor = UIColor.systemBackgroundColor;
//    
//    self.title = @"Weather";
//    self.navigationController.navigationBar.prefersLargeTitles = YES;
//    
//    _weatherTransitioningDelegate = [[WeatherTransitioningDelegate alloc] init];
//    
//    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
//    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:_tableView];
//    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
//    [_tableView.topAnchor pinTo:self.view.topAnchor];
//    [_tableView.leadingAnchor pinTo:self.view.leadingAnchor];
//    [_tableView.trailingAnchor pinTo:self.view.trailingAnchor];
//    [_tableView.bottomAnchor pinTo:self.view.bottomAnchor];
//    
//    _tableView.delegate = self;
//    
//
//    _cityForecasts = [self.weatherCache objectForKey:@"forecasts"];
//    if (_cityForecasts == nil) {
//        _cityForecasts = [NSArray new];
//    }
//    
//    // Configure data source
//    self.dataSource = [[ForecastDataSource alloc] initWithItems:_cityForecasts cellIdentifier:@"cityCell" configureCellBlock:^(CityForecastCell *cell, Forecast *forecast) { [cell configureForForecast:forecast]; }];
////    self.collectionView.dataSource = self.dataSource;
//    
//    RoundButton *addCityButton = [[RoundButton alloc] initWithSystemImageNamed:@"plus.circle"];
//    [self.view addSubview:addCityButton];
//    [addCityButton.trailingAnchor pinTo:self.view.trailingAnchor withPadding:-40];
//    [addCityButton.bottomAnchor pinTo:self.view.bottomAnchor withPadding:-40];
//    [addCityButton addTarget:self action:@selector(handleAddCityButton) forControlEvents:UIControlEventTouchUpInside];
//
//    RoundButton *settingsButton = [[RoundButton alloc] initWithSystemImageNamed:@"gear"];
//    [self.view addSubview:settingsButton];
//    [settingsButton.leadingAnchor pinTo:self.view.leadingAnchor withPadding:40];
//    [settingsButton.bottomAnchor pinTo:self.view.bottomAnchor withPadding:-40];
//    [settingsButton addTarget:self action:@selector(handleSettingsButton) forControlEvents:UIControlEventTouchUpInside];
//    
//}
//
//- (void)refreshDisplayedForecasts {
//    dispatch_group_t forecastGroup = dispatch_group_create();
//    
//    for (NSInteger index = 0; index < self.dataSource.items.count; index++) {
//        Forecast *forecast = [self.dataSource itemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
//        dispatch_group_enter(forecastGroup);
//        [forecast updateForecasts:^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.collectionView performBatchUpdates:^{
//                    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
//                } completion:nil];
//            });
//            dispatch_group_leave(forecastGroup);
//        }];
//    }
//
//    dispatch_group_notify(forecastGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        [self.weatherCache setObject:self.dataSource.items forKey:@"forecasts"];
//    });
//}
//
//- (void)handleAddCityButton {
//    MapViewController *mapViewController = [MapViewController new];
//    UINavigationController *addCityNavController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
//    [self.navigationController presentViewController:addCityNavController animated:YES completion:nil];
//}
//
//- (void)handleSettingsButton {
//    
//}
//
//#pragma mark - NSNotificationCenter
//
//- (void)registerForNotifications {
//    [NSNotificationCenter.defaultCenter addObserverForName:@"com.ncooke.newForecastFetched" object:nil queue:nil usingBlock:^(NSNotification * notification) {
//        NSLog(@"notification received");
//        NSDictionary *info = notification.userInfo;
//        if (info) {
//            Forecast *updatedForecast = (Forecast *)info[@"forecast"];
//            NSInteger index = [info[@"index"] integerValue];
//            [self.dataSource.items replaceObjectAtIndex:index withObject:updatedForecast];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.collectionView performBatchUpdates:^{
//                    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
//                } completion:nil];
//            });
//        }
//    }];
//}
//
//#pragma mark - UITableViewDelegate
//
//
//
//@end

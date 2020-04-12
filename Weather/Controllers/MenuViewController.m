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

// Views
#import "CityForecastCell+ConfigureForForecast.h"

// Categories
#import "UIView+Pinto.h"
#import "NSLayoutAnchor+Pinto.h"

@interface MenuViewController () <UICollectionViewDelegate>

@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic) ForecastDataSource *dataSource;

@end

@implementation MenuViewController

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
    [_collectionView.topAnchor pinTo:self.view.safeAreaLayoutGuide.topAnchor];
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
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];
    
    self.navigationController.navigationBar.topItem.title = @"Weather"; // MARK: phone dark mode affects default color
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    [self.view addSubview:self.collectionView];
    [self layoutCollectionView];
    
    dispatch_group_t forecastGroup = dispatch_group_create();

    NSArray<Forecast *> * cityForecasts = [[Store forecasts] copy];
    
    for (Forecast *forecast in cityForecasts) {
        dispatch_group_enter(forecastGroup);
        [forecast updateForecasts:^{
            dispatch_group_leave(forecastGroup);
        }];
    }
    
    weakify(self)
    dispatch_group_notify(forecastGroup, dispatch_get_main_queue(), ^{
        strongify(self)
        self.dataSource = [[ForecastDataSource alloc] initWithItems:cityForecasts cellIdentifier:@"cityCell" configureCellBlock:^(CityForecastCell *cell, Forecast *forecast) { [cell configureForForecast:forecast]; }];
        self.collectionView.dataSource = self.dataSource;
    });
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell setHighlighted:YES];
    
    //NSArray<Forecast *> * cityForecasts = [[Store forecasts] copy];
    
    WeatherViewController *weatherViewController = [[WeatherViewController alloc] init];
    //weatherViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:weatherViewController animated:YES completion:nil];
    
    [selectedCell setHighlighted:NO];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, 70);
}

@end

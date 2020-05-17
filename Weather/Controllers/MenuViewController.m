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
#import "SettingsViewController.h"

// Transition Delegates
#import "WeatherTransitioningDelegate.h"

// Views
#import "CityForecastCell+ConfigureForForecast.h"
#import "RoundButton.h"

// Categories
#import "UIView+Pinto.h"
#import "NSLayoutAnchor+Pinto.h"

typedef NS_ENUM(NSUInteger, MenuControllerState) {
    MenuControllerStateNormal,
    MenuControllerStateEditing,
};

@interface MenuViewController () <UICollectionViewDelegate, AddForecastDelegate, SettingsDelegate>

@property (nonatomic) MenuControllerState state;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) ForecastDataSource *dataSource;
@property (nonatomic) WeatherTransitioningDelegate *weatherTransitioningDelegate;
@property (nonatomic) NSArray<Forecast *> *cityForecasts;

@property (nonatomic) RoundButton *settingsButton;
@property (nonatomic) RoundButton *deleteButton;

@property (nonatomic) RoundButton *addCityButton;
@property (nonatomic) UIButton *doneButton;

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
    self.dataSource = [[ForecastDataSource alloc] initWithItems:_cityForecasts cellIdentifier:@"cityCell" configureCellBlock:^(CityForecastCell *cell, Forecast *forecast) { [cell configureForForecast:forecast]; }];
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
    

    _cityForecasts = [self.weatherCache objectForKey:@"forecasts"];
    if (_cityForecasts == nil) {
        _cityForecasts = [NSArray new];
    }
    
    [self configureCollectionViewDataSource];
    
    _settingsButton = [[RoundButton alloc] initWithSystemImageNamed:@"gear"];
    [self.view addSubview:_settingsButton];
    [_settingsButton.leadingAnchor pinTo:self.view.leadingAnchor withPadding:40];
    [_settingsButton.bottomAnchor pinTo:self.view.bottomAnchor withPadding:-40];
    [_settingsButton addTarget:self action:@selector(handleSettingsButton) forControlEvents:UIControlEventTouchUpInside];
    
    _addCityButton = [[RoundButton alloc] initWithSystemImageNamed:@"ellipsis.circle.fill"];
    [self.view addSubview:_addCityButton];
    [_addCityButton.trailingAnchor pinTo:self.view.trailingAnchor withPadding:-40];
    [_addCityButton.bottomAnchor pinTo:self.view.bottomAnchor withPadding:-40];
    [_addCityButton addTarget:self action:@selector(handleEllipsisButton) forControlEvents:UIControlEventTouchUpInside];
    
    _doneButton = [self configuredDoneButton];
    [self.view addSubview:_doneButton];
    _doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [[_doneButton.centerXAnchor constraintEqualToAnchor:_addCityButton.centerXAnchor] setActive:YES];
    [[_doneButton.centerYAnchor constraintEqualToAnchor:_addCityButton.centerYAnchor] setActive:YES];
    [_doneButton addTarget:self action:@selector(handleDoneButton) forControlEvents:UIControlEventTouchUpInside];
    
    _deleteButton = [RoundButton buttonWithSystemImageNamed:@"trash.circle.fill" andTintColor:UIColor.systemRedColor];
    [self.view addSubview:_deleteButton];
    [_deleteButton.leadingAnchor pinTo:self.view.leadingAnchor withPadding:40];
    [_deleteButton.bottomAnchor pinTo:self.view.bottomAnchor withPadding:-40];
    [_deleteButton addTarget:self action:@selector(handleDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.userInteractionEnabled = NO;
    _deleteButton.alpha = 0;

}

- (void)refreshDisplayedForecasts {
    dispatch_group_t forecastGroup = dispatch_group_create();
    
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
}

- (UIButton *)configuredDoneButton {

    NSAttributedString *formattedDoneString = [[NSAttributedString alloc] initWithString:@"Done" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold], NSForegroundColorAttributeName: [UIColor systemBlueColor]}];
    NSAttributedString *selectedFormattedDoneString = [[NSAttributedString alloc] initWithString:@"Done" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold], NSForegroundColorAttributeName: [[UIColor systemBlueColor] colorWithAlphaComponent:0.7]}];
    
    UIButton *button = [UIButton new];
    [button setAttributedTitle:formattedDoneString forState:UIControlStateNormal];
    [button setAttributedTitle:selectedFormattedDoneString forState:UIControlStateHighlighted];
    
    button.contentEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    [button sizeToFit];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.userInteractionEnabled = NO;
        effectView.frame = button.bounds;
        [button insertSubview:effectView atIndex:0];
        button.backgroundColor = UIColor.clearColor;
    } else {
        button.backgroundColor = [UIColor systemBackgroundColor];
    }
    
    button.layer.cornerRadius = button.bounds.size.height / 2;
    button.clipsToBounds = YES;
    
    button.alpha = 0;
    button.enabled = NO;
    
    return button;
}

#pragma mark - State
- (void)toggleState {
    self.state ^= 1; // toggle state
    
    switch (self.state) {
        case MenuControllerStateNormal:
            self.collectionView.allowsMultipleSelection = 0;
            [self updateUIForNewState:self.state];
            break;
            
        case MenuControllerStateEditing:
            self.collectionView.allowsMultipleSelection = 1;
            [self updateUIForNewState:self.state];
            break;
    }
}

- (void)updateUIForNewState:(MenuControllerState)newState {
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.deleteButton.alpha = newState;
        self.doneButton.alpha = newState;
        self.addCityButton.alpha = newState ? -1 : 1;
        self.settingsButton.alpha = newState ? -1 : 1;
    } completion:^(UIViewAnimatingPosition finalPosition) {
        self.deleteButton.userInteractionEnabled = newState;
        self.doneButton.enabled = newState;
        self.addCityButton.enabled = !newState;
        self.settingsButton.enabled = !newState;
    }];
}

#pragma mark - Control Handlers

- (void)handleEllipsisButton {
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) { }];
    [actionController addAction:cancelAction];
    
    UIAlertAction *selectForecasts = [UIAlertAction actionWithTitle:@"Select Forecasts" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { [self toggleState]; }];
    [actionController addAction:selectForecasts];

    UIAlertAction *addForecast = [UIAlertAction actionWithTitle:@"Add Forecast" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self presentMapViewController]; }];
    [actionController addAction:addForecast];
    
    [self.navigationController presentViewController:actionController animated:YES completion:nil];
}

- (void)handleDeleteButton {
    NSMutableIndexSet *indicesToBeRemoved = [NSMutableIndexSet indexSet];
    for (NSIndexPath *indexPath in [self.collectionView indexPathsForSelectedItems]) {
        [indicesToBeRemoved addIndex:indexPath.row];
    }
    
    [self.dataSource.items removeObjectsAtIndexes:indicesToBeRemoved];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:[self.collectionView indexPathsForSelectedItems]];
    } completion:nil];
    [self.weatherCache setObject:self.dataSource.items forKey:@"forecasts"];
    
    [self toggleState];

}

- (void)handleDoneButton {
    [self toggleState];
    
    // Unhighlight any & all currently highlighted cells
    for (__kindof UICollectionViewCell *cell in self.collectionView.visibleCells) {
        cell.highlighted = NO;
    }
}

- (void)presentMapViewController {
    MapViewController *mapViewController = [MapViewController new];
    mapViewController.delegate = self;
    UINavigationController *addCityNavController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    [self.navigationController presentViewController:addCityNavController animated:YES completion:nil];
}

- (void)handleSettingsButton {
    SettingsViewController *settingsViewController = [SettingsViewController new];
    settingsViewController.delegate = self;
    UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [self.navigationController presentViewController:settingsNavController animated:YES completion:nil];
}

#pragma mark - SettingsDelegate

- (void)settingsDidChange {
    for (NSInteger index = 0; index < self.dataSource.items.count; index++) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
                } completion:nil];
            });
    }
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
    
    if (self.collectionView.allowsMultipleSelection == 0) {//(self.state == MenuControllerStateNormal) {
        WeatherViewController *weatherViewController = [[WeatherViewController alloc] init];
        weatherViewController.forecast = [self.dataSource itemAtIndexPath:indexPath];
        weatherViewController.transitioningDelegate = _weatherTransitioningDelegate;
        _weatherTransitioningDelegate.startingCenter = [selectedCell convertPoint:selectedCell.center toView:self.view];
        weatherViewController.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:weatherViewController animated:YES completion:^{ [selectedCell setHighlighted:NO]; }];
    } else {
        selectedCell.selected = YES;
    }

}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, 70);
}

#pragma mark - AddForecastDelegate

- (void)addForecastWithInfo:(NSDictionary *)info {
    if (info) {
        Forecast *newForecast = [[Forecast alloc] initForPlaceNamed:info[@"placeName"] atLocation:info[@"location"]];
        [self.dataSource.items addObject:newForecast];
        [newForecast updateForecasts:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.dataSource.items count] - 1 inSection:0]]];
                } completion:nil];
            });
        }];
        [self.weatherCache setObject:self.dataSource.items forKey:@"forecasts"];
    }
    
    
}

@end

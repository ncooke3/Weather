//
//  MenuViewController.h
//  Weather
//
//  Created by Nicholas Cooke on 4/7/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

// Frameworks
#import <Cashier/NOPersistentStore.h>

// Views
#import "CityForecastCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuViewController : UIViewController

@property (nonatomic) NOPersistentStore *weatherCache;

@property (nonatomic) CityForecastCell *selectedCell;

@property (nonatomic) UICollectionView *collectionView;

- (void)refreshDisplayedForecasts;

@end

NS_ASSUME_NONNULL_END

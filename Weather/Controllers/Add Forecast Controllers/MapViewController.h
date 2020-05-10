//
//  MapViewController.h
//  Weather
//
//  Created by Nicholas Cooke on 4/24/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AddForecastDelegate <NSObject>

- (void)addForecastWithInfo:(id)info;

@end

@interface MapViewController : UIViewController

@property (nonatomic) UISearchController *searchController;
@property (nonatomic, weak) id<AddForecastDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

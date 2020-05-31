//
//  WeatherControllerAnimator.h
//  Weather
//
//  Created by Nicholas Cooke on 4/20/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Controllers
#import "MenuViewController.h"
#import "WeatherViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherControllerAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, getter=isPresenting) BOOL presenting;
@property (nonatomic) CGPoint startingCenter;
@property (nonatomic) CGRect openingFrame;

- (instancetype)initWithMenuController:(MenuViewController *)menuController
                  andWeatherController:(WeatherViewController *)weatherController;

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext;
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext;

@end

NS_ASSUME_NONNULL_END

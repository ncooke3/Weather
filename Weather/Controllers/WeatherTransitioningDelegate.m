//
//  WeatherTransitioningDelegate.m
//  Weather
//
//  Created by Nicholas Cooke on 4/20/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "WeatherTransitioningDelegate.h"

// Animator Objects
#import "WeatherControllerAnimator.h"

@implementation WeatherTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    WeatherControllerAnimator *animator = [[WeatherControllerAnimator alloc] init];
    animator.startingCenter = _startingCenter;
    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    WeatherControllerAnimator *animator = [[WeatherControllerAnimator alloc] init];
    animator.presenting = NO;
    animator.startingCenter = _startingCenter;
    return animator;
}


@end

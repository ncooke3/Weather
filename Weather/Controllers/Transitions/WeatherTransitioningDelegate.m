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

// Controllers
#import "MenuViewController.h"
#import "WeatherViewController.h"

@interface WeatherTransitioningDelegate ()

@property (nonatomic) WeatherControllerAnimator *animator;

@end

@implementation WeatherTransitioningDelegate

// (lldb) po [((UINavigationController *)presenting) topViewController];
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    presenting = [(UINavigationController *)presenting topViewController];
    
    [self createAnimatorForPresentedController:presented andPresentingController:presenting];
    self.animator.presenting = YES;
    return self.animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    // MARK: close app in forecast then reopen, both cases of killing/not killing app
    self.animator.presenting = NO;
    return self.animator;
}

#pragma mark - Property Utils

- (WeatherControllerAnimator *)createAnimatorForPresentedController:(UIViewController *)presented andPresentingController:(UIViewController *)presenting {

    MenuViewController *menuController = (MenuViewController *)presenting;
    WeatherViewController *weatherController = (WeatherViewController *)presented;
    _animator = [[WeatherControllerAnimator alloc] initWithMenuController:menuController
                                                     andWeatherController:weatherController];
    
    return _animator;
}

@end

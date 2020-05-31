//
//  WeatherTransitioningDelegate.h
//  Weather
//
//  Created by Nicholas Cooke on 4/20/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic) CGPoint startingCenter;
@property (nonatomic) CGRect openingFrame;

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;

@end

NS_ASSUME_NONNULL_END

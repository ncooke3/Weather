//
//  WeatherControllerAnimator.h
//  Weather
//
//  Created by Nicholas Cooke on 4/20/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherControllerAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL presenting;
@property (nonatomic) CGPoint startingCenter;

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext;
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext;

@end

NS_ASSUME_NONNULL_END

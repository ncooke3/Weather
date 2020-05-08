//
//  WeatherControllerAnimator.m
//  Weather
//
//  Created by Nicholas Cooke on 4/20/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "WeatherControllerAnimator.h"

@implementation WeatherControllerAnimator

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {

    UIView *containerView = [transitionContext containerView];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    
    [containerView addSubview:toView];
    toView.frame = toViewFinalFrame;
    
    [toView layoutIfNeeded];
    
    CGPoint finishingCenter;
    
    // Set up the animation parameters.
    if (self.presenting) {
        finishingCenter = CGPointMake(toViewFinalFrame.size.width / 2, toViewFinalFrame.size.height / 2);
        toView.alpha = 0;
        toView.center = _startingCenter;
        toView.transform = CGAffineTransformMakeScale(0.25, 0.25);
        toView.layer.cornerRadius = 20;
    } else {
        finishingCenter = _startingCenter;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (self.presenting) {
            toView.center = finishingCenter;
            toView.transform = CGAffineTransformIdentity;
            toView.alpha = 1;
        } else {
            fromView.center = finishingCenter;
            fromView.transform = CGAffineTransformMakeScale(0.40, 0.40);
            fromView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        BOOL success = ![transitionContext transitionWasCancelled];
        
        // After a failed presentation or successful dismissal, remove the view.
        if ((self.presenting && !success) || (!self.presenting && success)) {
            [toView removeFromSuperview];
        }
        
        // Notify UIKit that the transition has finished
        [transitionContext completeTransition:success];
    }];
    
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return self.presenting ? 0.30 : 0.20;
}

@end

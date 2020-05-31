//
//  WeatherControllerAnimator.m
//  Weather
//
//  Created by Nicholas Cooke on 4/20/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "WeatherControllerAnimator.h"

@interface WeatherControllerAnimator ()

@property (nonatomic, strong) MenuViewController *menuController;
@property (nonatomic, strong) WeatherViewController *weatherController;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation WeatherControllerAnimator

- (instancetype)initWithMenuController:(MenuViewController *)menuController
                  andWeatherController:(WeatherViewController *)weatherController {
    self = [super init];
    if (self) {
        _menuController = menuController;
        _weatherController = weatherController;
        
    }
    return self;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect fromViewFrame = fromViewController.view.frame;
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    CityForecastCell *selectedCell = _menuController.selectedCell;
    CGRect selectedCellFrame = [_menuController.collectionView convertRect:selectedCell.frame toView:_menuController.view];

    if (self.isPresenting) {
        
        // Add the weatherController snapshot
        UIView *weatherControllerSnapshot = [toViewController.view resizableSnapshotViewFromRect:_menuController.view.frame
                                                                                afterScreenUpdates:YES
                                                                                     withCapInsets:UIEdgeInsetsZero];
        // MARK: Can you replace above surrounding lines with line below?
//      UIView *weatherControllerSnapshot = [_weatherController.view snapshotViewAfterScreenUpdates:YES];
        weatherControllerSnapshot.frame = _weatherController.view.frame;
        [containerView addSubview:weatherControllerSnapshot];
        
        // TODO: snapshot of label where we make a copy of it and return snapshot

    
        // Add the real weatherController- make it invisible
        toViewController.view.alpha = 0.0;
        [containerView addSubview:toViewController.view];
        
        UILabel *weatherControllerLocationLabel = _weatherController.weatherScrollView.locationLabel;
        UILabel *weatherControllerTemperatureLabel = _weatherController.weatherScrollView.temperatureLabel;
        

        // TODO: make a CALayer
        UIView *fadeView = [[UIView alloc] initWithFrame:selectedCellFrame];
        fadeView.backgroundColor = UIColor.secondarySystemBackgroundColor; //selectedCell.backgroundColor;
        [containerView addSubview:fadeView];

        // Forecast Cell snapshots
        UIView *cellTemperatureSnapshot = [selectedCell.temperatureLabel snapshotViewAfterScreenUpdates:YES];
        // TODO: rename cityLabel to locationLabel
        UIView *cellLocationLabelSnapshot = [selectedCell.cityLabel snapshotViewAfterScreenUpdates:YES];

        cellTemperatureSnapshot.frame = [selectedCell convertRect:selectedCell.temperatureLabel.frame toView:containerView];
        cellLocationLabelSnapshot.frame = [selectedCell convertRect:selectedCell.cityLabel.frame toView:containerView];

        [containerView addSubview:cellTemperatureSnapshot];
        [containerView addSubview:cellLocationLabelSnapshot];
        
        // Cell snapshots
        weatherControllerLocationLabel.alpha = 1;
        UIView *weatherControllerLocationLabelSnapshot = [weatherControllerLocationLabel snapshotViewAfterScreenUpdates:YES];
        weatherControllerTemperatureLabel.alpha = 1;
        UIView *weatherControllerTemperatureLabelSnapshot = [weatherControllerTemperatureLabel snapshotViewAfterScreenUpdates:YES];
        
        weatherControllerLocationLabel.alpha = 0;
        weatherControllerTemperatureLabel.alpha = 0;

        weatherControllerLocationLabelSnapshot.frame = weatherControllerLocationLabel.frame;
        weatherControllerTemperatureLabelSnapshot.frame = weatherControllerTemperatureLabel.frame;
        [containerView addSubview:weatherControllerLocationLabelSnapshot];
        [containerView addSubview:weatherControllerTemperatureLabelSnapshot];
        
        // Weather Controller Date Label
        UILabel *weatherControllerDateLabel = _weatherController.weatherScrollView.dateLabel;
        weatherControllerDateLabel.alpha = 1;
        UIView *cellLocationDateSnapshot = [weatherControllerDateLabel snapshotViewAfterScreenUpdates:YES];
        cellLocationDateSnapshot.frame = weatherControllerDateLabel.frame;
        cellLocationDateSnapshot.alpha = 0;
        cellLocationDateSnapshot.transform = CGAffineTransformMakeScale(0.9, 0.9);
        cellLocationDateSnapshot.center = CGPointMake(cellLocationDateSnapshot.center.x, cellLocationDateSnapshot.center.y + 15);
        [containerView addSubview:cellLocationDateSnapshot];
        
        
        // Weather Controller Conditions Label
        UILabel *weatherControllerConditionsLabel = _weatherController.weatherScrollView.conditionsLabel;
        weatherControllerConditionsLabel.alpha = 1;
        UIView *cellLocationConditionsSnapshot = [weatherControllerConditionsLabel snapshotViewAfterScreenUpdates:YES];
        cellLocationConditionsSnapshot.frame = weatherControllerConditionsLabel.frame;
        cellLocationConditionsSnapshot.alpha = 0;
        cellLocationConditionsSnapshot.transform = CGAffineTransformMakeScale(0.8, 0.8);
        cellLocationConditionsSnapshot.center = CGPointMake(cellLocationConditionsSnapshot.center.x, cellLocationConditionsSnapshot.center.y + 20);
        [containerView addSubview:cellLocationConditionsSnapshot];
        
        // Weather Controller WeatherTicker Label
        UILabel *weatherControllerWeatherTickerLabel = _weatherController.weatherScrollView.weatherTickerLabel;
        weatherControllerWeatherTickerLabel.alpha = 1;
        UIView *cellLocationWeatherTickerSnapshot = [weatherControllerWeatherTickerLabel snapshotViewAfterScreenUpdates:YES];
        cellLocationWeatherTickerSnapshot.frame = weatherControllerWeatherTickerLabel.frame;
        cellLocationWeatherTickerSnapshot.alpha = 0;
        cellLocationWeatherTickerSnapshot.transform = CGAffineTransformMakeScale(0.7, 0.7);
        cellLocationWeatherTickerSnapshot.center = CGPointMake(cellLocationWeatherTickerSnapshot.center.x, cellLocationWeatherTickerSnapshot.center.y + 25);
        [containerView addSubview:cellLocationWeatherTickerSnapshot];
      
        UIEdgeInsets topViewInsets = UIEdgeInsetsMake(CGRectGetMinY(selectedCellFrame), 0, 0, 0);
        _topView = [fromViewController.view resizableSnapshotViewFromRect:fromViewFrame
                                                       afterScreenUpdates:YES
                                                            withCapInsets:topViewInsets];
        _topView.frame = CGRectMake(0, 0, CGRectGetWidth(fromViewFrame), CGRectGetMinY(selectedCellFrame));
        [containerView addSubview:_topView];
        
        // Bottom View
        CGFloat bottomOffset = CGRectGetHeight(fromViewFrame) - CGRectGetMinY(selectedCellFrame) - CGRectGetHeight(selectedCellFrame);
        UIEdgeInsets bottomViewInsets = UIEdgeInsetsMake(0, 0, bottomOffset, 0);
        _bottomView = [fromViewController.view resizableSnapshotViewFromRect:fromViewFrame afterScreenUpdates:YES withCapInsets:bottomViewInsets];
      
        // TODO: break up lol
        _bottomView.frame = CGRectMake(0, CGRectGetMinY(selectedCellFrame) + CGRectGetHeight(selectedCellFrame), CGRectGetWidth(fromViewFrame), CGRectGetHeight(fromViewFrame) - CGRectGetMinY(selectedCellFrame) - CGRectGetHeight(selectedCellFrame));
        [containerView addSubview:_bottomView];
    
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [self morphViews:cellLocationLabelSnapshot
                  toView:weatherControllerLocationLabelSnapshot
             forDuration:duration
          withCompletion:^(BOOL finished) {
            [cellLocationLabelSnapshot removeFromSuperview];
            [weatherControllerLocationLabelSnapshot removeFromSuperview];
        }];

        [self morphViews:cellTemperatureSnapshot
                  toView:weatherControllerTemperatureLabelSnapshot
             forDuration:duration
          withCompletion:^(BOOL finished) {
            [cellTemperatureSnapshot removeFromSuperview];
            [weatherControllerTemperatureLabelSnapshot removeFromSuperview];
        }];
        
        [UIView animateKeyframesWithDuration:duration
                                       delay:0
                                     options:UIViewKeyframeAnimationOptionCalculationModeLinear
                                  animations:^{

            [UIView addKeyframeWithRelativeStartTime:0.0
                                  relativeDuration:1.0
                                        animations:^{
                self.topView.frame = CGRectMake(0,
                                                -self.topView.frame.size.height,
                                                self.topView.frame.size.width,
                                                self.topView.frame.size.height);
                self.bottomView.frame = CGRectMake(0,
                                                   CGRectGetHeight(self.menuController.view.frame),
                                                   CGRectGetWidth(self.bottomView.frame),
                                                   CGRectGetHeight(self.bottomView.frame));

                fadeView.alpha = 0.0;
                fadeView.frame = self.weatherController.view.frame;
            }];
          
            [UIView addKeyframeWithRelativeStartTime:0.95
                                relativeDuration:0.05
                                      animations:^{
                cellLocationDateSnapshot.alpha = 1;
                cellLocationDateSnapshot.transform = CGAffineTransformIdentity;
                cellLocationDateSnapshot.center = CGPointMake(cellLocationDateSnapshot.center.x, cellLocationDateSnapshot.center.y - 15);
                
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.90
                                relativeDuration:0.10
                                      animations:^{
                
                cellLocationConditionsSnapshot.alpha = 1;
                cellLocationConditionsSnapshot.transform = CGAffineTransformIdentity;
                cellLocationConditionsSnapshot.center = CGPointMake(cellLocationConditionsSnapshot.center.x, cellLocationConditionsSnapshot.center.y - 20);
                
                cellLocationWeatherTickerSnapshot.alpha = 1;
                cellLocationWeatherTickerSnapshot.transform = CGAffineTransformIdentity;
                cellLocationWeatherTickerSnapshot.center = CGPointMake(cellLocationWeatherTickerSnapshot.center.x, cellLocationWeatherTickerSnapshot.center.y - 25);
                
            }];
            
            
        } completion:^(BOOL finished) {
            
            [weatherControllerSnapshot removeFromSuperview];
            
            [fadeView removeFromSuperview];
            [cellLocationDateSnapshot removeFromSuperview];
            [cellLocationConditionsSnapshot removeFromSuperview];
            [cellLocationWeatherTickerSnapshot removeFromSuperview];
            
            toViewController.view.alpha = 1.0;

            [transitionContext completeTransition:finished];

        }];
        
    

        } else {
            // MARK: the `from` and `to` view controllers have switched!
            UIView *weatherControllerSnapshot = [fromViewController.view resizableSnapshotViewFromRect:fromViewFrame
                                                                                 afterScreenUpdates:YES
                                                                                      withCapInsets:UIEdgeInsetsZero];
            [containerView addSubview:weatherControllerSnapshot];
            
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] init];
            blurEffectView.frame = weatherControllerSnapshot.bounds;
            blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [weatherControllerSnapshot addSubview:blurEffectView];
            

            fromViewController.view.alpha = 0.0;

            UIView *fadeView = [[UIView alloc] initWithFrame:_weatherController.view.frame];
            fadeView.backgroundColor = _menuController.selectedCell.backgroundColor;
            [containerView addSubview:fadeView];
            fadeView.alpha = 0;
          
            [containerView addSubview:_topView];
            [containerView addSubview:_bottomView];
            
            UIView *cellSnapshot = [selectedCell snapshotViewAfterScreenUpdates:YES];
            cellSnapshot.frame = selectedCellFrame;
            cellSnapshot.transform = CGAffineTransformMakeScale(1.1, 1.1);
            cellSnapshot.alpha = 0;
            [containerView addSubview:cellSnapshot];
        
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            
            [UIView animateKeyframesWithDuration:duration
                                           delay:0
                                         options:UIViewKeyframeAnimationOptionCalculationModeLinear
                                      animations:^{
              
              [UIView addKeyframeWithRelativeStartTime:0.0
                                      relativeDuration:1.0
                                            animations:^{
                  self.topView.frame = CGRectMake(0, 0, self.topView.frame.size.width, self.topView.frame.size.height);
                  self.bottomView.frame = CGRectMake(0,
                                                     CGRectGetHeight(fromViewFrame) - CGRectGetHeight(self.bottomView.frame),
                                                     CGRectGetWidth(self.bottomView.frame),
                                                     CGRectGetHeight(self.bottomView.frame));
                  fadeView.frame = selectedCellFrame;
                  fadeView.alpha = 1.10;
                  blurEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
              }];
              
                [UIView addKeyframeWithRelativeStartTime:0.90
                                        relativeDuration:0.10
                                              animations:^{
                    cellSnapshot.alpha = 1;
                    cellSnapshot.transform = CGAffineTransformIdentity;
                }];
                
                
            } completion:^(BOOL finished) {
                  [fadeView removeFromSuperview];
                  [weatherControllerSnapshot removeFromSuperview];
                  toViewController.view.alpha = 1.0;
                  [transitionContext completeTransition:finished];
            }];


    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return self.presenting ? 0.35 : 0.33;
}


- (void)morphViews:(UIView *)fromView toView:(UIView *)toView forDuration:(NSTimeInterval)duration withCompletion:(void(^)(BOOL finished))completion {
      NSTimeInterval halfway = duration / 2;
  
      CGFloat scaleForfromView = CGRectGetHeight(toView.frame)/CGRectGetHeight(fromView.frame);
      CGFloat toeForfromView = CGRectGetHeight(fromView.frame)/CGRectGetHeight(toView.frame);
      
      CGPoint fromViewCenter = fromView.center;
      CGPoint toViewCenter = toView.center;
      
      toView.transform = CGAffineTransformMakeScale(toeForfromView, toeForfromView);
      toView.alpha = 0;
      toView.center = fromViewCenter;
      
      [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced animations:^{
          
        [UIView addKeyframeWithRelativeStartTime:0
                                relativeDuration:halfway
                                      animations:^{
            fromView.alpha = 0.2;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0
                                relativeDuration:halfway
                                      animations:^{
            toView.alpha = 0.5;
        }];

        
        [UIView addKeyframeWithRelativeStartTime:halfway
                                relativeDuration:halfway
                                      animations:^{
            toView.alpha = 1.0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:halfway
                                relativeDuration:halfway
                                      animations:^{
            fromView.alpha = 0.0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.0
                                relativeDuration:duration
                                      animations:^{
            fromView.center = toViewCenter;
            toView.transform = CGAffineTransformIdentity;
            toView.center = toViewCenter;
            fromView.transform = CGAffineTransformMakeScale(scaleForfromView, scaleForfromView);
        }];
        
      } completion:^(BOOL finished) {
        completion(finished);
      }];
}


@end

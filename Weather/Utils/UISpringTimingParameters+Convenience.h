//
//  UISpringTimingParameters+Convenience.h
//  Weather
//
//  Created by Nicholas Cooke on 3/29/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISpringTimingParameters (Convenience)

/// A design-friendly way to create a spring timing curve.
///
/// - Parameters:
///   - damping: The 'bounciness' of the animation. Value must be between 0 and 1.
///   - response: The 'speed' of the animation.
- (instancetype)initWithDamping:(CGFloat)damping response:(CGFloat)response;

@end

NS_ASSUME_NONNULL_END

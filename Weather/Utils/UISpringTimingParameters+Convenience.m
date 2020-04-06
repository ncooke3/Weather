//
//  UISpringTimingParameters+Convenience.m
//  Weather
//
//  Created by Nicholas Cooke on 3/29/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "UISpringTimingParameters+Convenience.h"

@implementation UISpringTimingParameters (Convenience)

- (instancetype)initWithDamping:(CGFloat)damping response:(CGFloat)response {
    CGFloat stiffness = powf(2 * M_PI / response, 2);
    CGFloat damp = 4 * M_PI * damping / response;
    
    self = [self initWithMass:1.0 stiffness:stiffness damping:damp initialVelocity:CGVectorMake(0, 0)];
    if (self) {
        
    }
    return self;
}

@end

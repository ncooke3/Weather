//
//  UIView+Pinto.m
//  Weather
//
//  Created by Nicholas Cooke on 4/4/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "UIView+Pinto.h"

@implementation UIView (Pinto)

- (void)pinToCenterOfView:(UIView *)view {
    [[self.centerYAnchor constraintEqualToAnchor:view.centerYAnchor] setActive:YES];
    [[self.centerXAnchor constraintEqualToAnchor:view.centerXAnchor] setActive:YES];
}

- (void)pinToCenterOfView:(UIView *)view withOffset:(UIOffset)offset {
    [[self.centerYAnchor constraintEqualToAnchor:view.centerYAnchor constant:offset.vertical] setActive:YES];
    [[self.centerXAnchor constraintEqualToAnchor:view.centerXAnchor constant:offset.horizontal] setActive:YES];
}

@end

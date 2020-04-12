//
//  NSLayoutAnchor+Pinto.m
//  Weather
//
//  Created by Nicholas Cooke on 4/2/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "NSLayoutAnchor+Pinto.h"

@implementation NSLayoutAnchor (Pinto)

- (void)pinTo:(NSLayoutAnchor *)anchor {
    [[self constraintEqualToAnchor:anchor] setActive:YES];
}

- (void)pinTo:(NSLayoutAnchor *)anchor withPadding:(CGFloat)padding {
    [[self constraintEqualToAnchor:anchor constant:padding] setActive:YES];
}

@end

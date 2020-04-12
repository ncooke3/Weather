//
//  NSLayoutAnchor+Pinto.h
//  Weather
//
//  Created by Nicholas Cooke on 4/2/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutAnchor (Pinto)

- (void)pinTo:(NSLayoutAnchor *)anchor;
- (void)pinTo:(NSLayoutAnchor *)anchor withPadding:(CGFloat)padding;

@end

NS_ASSUME_NONNULL_END

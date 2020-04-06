//
//  UIView+Pinto.h
//  Weather
//
//  Created by Nicholas Cooke on 4/4/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Pinto)

- (void)pinToCenterOfView:(UIView *)view;
- (void)pinToCenterOfView:(UIView *)view withOffset:(UIOffset)offset;

@end

NS_ASSUME_NONNULL_END

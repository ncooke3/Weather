//
//  RoundButton.h
//  Weather
//
//  Created by Nicholas Cooke on 4/24/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoundButton : UIControl

+ (instancetype)buttonWithSystemImageNamed:(NSString *)name andTintColor:(UIColor *)color;

// Convenience Initializer
- (instancetype)initWithSystemImageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

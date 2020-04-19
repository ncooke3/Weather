//
//  MoonButton.h
//  Weather
//
//  Created by Nicholas Cooke on 4/4/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MoonButtonDelegate <NSObject>

- (void)buttonChanged;

@end

@interface MoonButton : UIControl

/// Whether the button is on or off.
@property (nonatomic, getter=isMoon) BOOL moon;
@property (nonatomic, weak) id<MoonButtonDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

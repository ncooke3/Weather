//
//  SettingsViewController.h
//  Weather
//
//  Created by Nicholas Cooke on 5/9/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SettingsDelegate <NSObject>

- (void)settingsDidChange;

@end

@interface SettingsViewController : UIViewController

@property (nonatomic, weak) id<SettingsDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

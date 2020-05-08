//
//  LabeledButton.h
//  Weather
//
//  Created by Nicholas Cooke on 5/6/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LabeledButton : UIControl

@property (nonatomic) NSString *labelText;

- (instancetype)initWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END

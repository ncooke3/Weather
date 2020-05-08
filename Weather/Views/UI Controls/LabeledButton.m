//
//  LabeledButton.m
//  Weather
//
//  Created by Nicholas Cooke on 5/6/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "LabeledButton.h"

@interface LabeledButton ()

@property (nonatomic) UILabel *label;
@property (nonatomic) UIViewPropertyAnimator *animator;
@property (nonatomic) CALayer *dimmingLayer;
@property (nonatomic) UIVisualEffectView *backgroundBlurView;

@end

@implementation LabeledButton

- (void)setLabelText:(NSString *)labelText {
    _labelText = labelText;
    _label.text = labelText;
    [_label sizeToFit]; // could be a problem
}

- (UIVisualEffectView *)backgroundBlurView {
    if (!_backgroundBlurView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        _backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _backgroundBlurView.clipsToBounds = YES;
        _backgroundBlurView.userInteractionEnabled = NO;
    }
    return _backgroundBlurView;
}

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        
        [self addSubview:self.backgroundBlurView];
    
        _label = [UILabel new];
        _label.text = text;
        [_label sizeToFit];
        [self addSubview:_label];
        
        [self setFrame:CGRectMake(0, 0, _label.bounds.size.width + 40, _label.bounds.size.height + 20)];
        
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit | UIControlEventTouchCancel];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _backgroundBlurView.frame = self.bounds;
    _backgroundBlurView.layer.cornerRadius = self.bounds.size.width / 2;
}



@end

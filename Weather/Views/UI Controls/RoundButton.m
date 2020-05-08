//
//  RoundButton.m
//  Weather
//
//  Created by Nicholas Cooke on 4/24/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "RoundButton.h"

#import "UIView+Pinto.h"
#import "NSLayoutAnchor+Pinto.h"

@interface RoundButton ()

@property (nonatomic) UIViewPropertyAnimator *animator;
@property (nonatomic) CALayer *dimmingLayer;
@property (nonatomic) UIVisualEffectView *backgroundBlurView;

@end

@implementation RoundButton

- (CALayer *)dimmingLayer {
    _dimmingLayer.backgroundColor = UIColor.systemBackgroundColor.CGColor;
    return _dimmingLayer;
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

- (instancetype)initWithSystemImageNamed:(NSString *)name {
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self insertSubview:self.backgroundBlurView atIndex:0];
        
        UIImageView *imageView = [UIImageView new];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:imageView];
        [imageView pinToCenterOfView:self];
        
        UIImage *image = [UIImage systemImageNamed:name];
        if (!image) image = [UIImage new];
        
        imageView.image = [self configureSymbolImage:image];
        
        _dimmingLayer = [CALayer new];
        _dimmingLayer.opacity = 0.0;
        [self.layer addSublayer:_dimmingLayer];
        
        self.layer.masksToBounds = YES;
        
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit | UIControlEventTouchCancel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _dimmingLayer.frame = self.bounds;
    _dimmingLayer.cornerRadius = self.bounds.size.width / 2;
    
    _backgroundBlurView.frame = self.bounds;
    _backgroundBlurView.layer.cornerRadius = 0.5 * _backgroundBlurView.frame.size.width;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(45, 45);
}

//+ (BOOL)requiresConstraintBasedLayout {
//    return YES;
//}

#pragma mark - Utilities

- (UIImage *)configureSymbolImage:(UIImage *)image {
    UIFont *font = [UIFont systemFontOfSize:30];
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithFont:font];
    UIImageSymbolConfiguration *weightConfig = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightSemibold];
    config = [config configurationByApplyingConfiguration:weightConfig];
    image = [image imageByApplyingSymbolConfiguration:config];
    image = [image imageWithTintColor:UIColor.labelColor renderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

#pragma mark - Handlers

- (void)touchDown {
    [self.animator stopAnimation:YES];
    self.dimmingLayer.opacity = 0.6;
}

- (void)touchUp {
    self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.05 curve:UIViewAnimationCurveLinear animations:^{
        self.dimmingLayer.opacity = 0.0;
    }];
    [self.animator startAnimation];
}

@end

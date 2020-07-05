//
//  SolarLunarView.m
//  Weather
//
//  Created by Nicholas Cooke on 4/18/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "SolarLunarView.h"

// Views
#import "MoonButton.h"

// Categories
#import "NSLayoutAnchor+Pinto.h"

@interface SolarLunarView () <MoonButtonDelegate>

@property (nonatomic) MoonButton *button;
@property (nonatomic) UILabel *primaryLabel;
@property (nonatomic) UILabel *secondaryLabel;

@property (nonatomic) UIImageView *imageView;

@end

@implementation SolarLunarView

- (void)setData:(NSDictionary *)data {
    _data = data;
    
    _primaryLabel.text = _data[@"sunrisePhrase"];
    _secondaryLabel.text = _data[@"moonPhasePhrase"];
}

- (MoonButton *)button {
    if (!_button) {
        _button = [[MoonButton alloc] init];
        _button.delegate = self;
    }
    return _button;
}

- (UILabel *)primaryLabel {
    if (!_primaryLabel) {
        _primaryLabel = [[UILabel alloc] init];
        _primaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _primaryLabel.textColor = UIColor.secondaryLabelColor;
        _primaryLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    return _primaryLabel;
}

- (UILabel *)secondaryLabel {
    if (!_secondaryLabel) {
        _secondaryLabel = [[UILabel alloc] init];
        _secondaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _secondaryLabel.textColor = UIColor.grayColor;
        _secondaryLabel.font = [UIFont fontWithName:@"Futura-Medium" size:12];
        
        _secondaryLabel.text = @"Full Moon";
    }
    return _secondaryLabel;
}
   
- (instancetype)init {
    self = [super init];
    if (self) {
        
//        [self addSubview:self.button];
//        [_button.leadingAnchor pinTo:self.leadingAnchor withPadding:0];
//        [_button.centerYAnchor pinTo:self.centerYAnchor];
        
        _imageView = [UIImageView new];
        _imageView.backgroundColor = UIColor.systemPinkColor;
        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:30];
        _imageView.image = [[UIImage systemImageNamed:@"sunrise.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];// imageWithConfiguration:config];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView setTintColor:[UIColor secondaryLabelColor]];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_imageView];
        [_imageView.leadingAnchor pinTo:self.leadingAnchor withPadding:0];
        [_imageView.centerYAnchor pinTo:self.centerYAnchor];
        [[_imageView.widthAnchor constraintEqualToConstant:70] setActive:YES];
        [[_imageView.heightAnchor constraintEqualToConstant:70] setActive:YES];
        
        [self addSubview:self.primaryLabel];
//        [_primaryLabel.bottomAnchor pinTo:self.centerYAnchor withPadding:-2];
        [_primaryLabel.centerYAnchor pinTo:self.centerYAnchor];
//        [_primaryLabel.leadingAnchor pinTo:_button.trailingAnchor withPadding:30];
        [_primaryLabel.leadingAnchor pinTo:_imageView.trailingAnchor withPadding:15];
        
//        [self addSubview:self.secondaryLabel];
//        [_secondaryLabel.topAnchor pinTo:self.centerYAnchor withPadding:2];
////        [_secondaryLabel.leadingAnchor pinTo:_button.trailingAnchor withPadding:30];
//        [_secondaryLabel.leadingAnchor pinTo:imageView.trailingAnchor withPadding:30];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
    
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.layer.cornerRadius = CGRectGetWidth(_imageView.frame) / 2;
}

+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

- (void)buttonChanged {
    
    [UIView transitionWithView:_primaryLabel duration:0.25f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.primaryLabel.text = self.button.isMoon ? self.data[@"sunrisePhrase"] : self.data[@"sunsetPhrase"];
        self.secondaryLabel.text = self.button.isMoon ? self.data[@"moonPhasePhrase"] : self.data[@"humidityPhrase"];
    } completion:nil];
    
}

@end

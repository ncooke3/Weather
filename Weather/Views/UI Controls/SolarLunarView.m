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
        _primaryLabel.textColor = UIColor.grayColor; // MARK: color
        _primaryLabel.font = [UIFont fontWithName:@"Futura-Medium" size:16]; // MARK: font
        
        _primaryLabel.text = @"Sunrise at 6:43 AM";
    }
    return _primaryLabel;
}

- (UILabel *)secondaryLabel {
    if (!_secondaryLabel) {
        _secondaryLabel = [[UILabel alloc] init];
        _secondaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _secondaryLabel.textColor = UIColor.grayColor; // MARK: color
        _secondaryLabel.font = [UIFont fontWithName:@"Futura-Medium" size:12]; // MARK: font
        
        _secondaryLabel.text = @"Full Moon";
    }
    return _secondaryLabel;
}
   
- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self addSubview:self.button];
        [_button.leadingAnchor pinTo:self.leadingAnchor withPadding:0];
        [_button.centerYAnchor pinTo:self.centerYAnchor];
        
        [self addSubview:self.primaryLabel];
        [_primaryLabel.bottomAnchor pinTo:self.centerYAnchor withPadding:-2];
        [_primaryLabel.leadingAnchor pinTo:_button.trailingAnchor withPadding:30];
        
        [self addSubview:self.secondaryLabel];
        [_secondaryLabel.topAnchor pinTo:self.centerYAnchor withPadding:2];
        [_secondaryLabel.leadingAnchor pinTo:_button.trailingAnchor withPadding:30];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
    
    }
    return self;
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

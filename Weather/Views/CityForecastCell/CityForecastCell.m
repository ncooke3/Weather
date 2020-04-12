//
//  CityForecastCell.m
//  Weather
//
//  Created by Nicholas Cooke on 4/7/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "CityForecastCell.h"

// Categories
#import "NSLayoutAnchor+Pinto.h"

@implementation CityForecastCell

- (UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] init];
        _cityLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _cityLabel.textColor = UIColor.whiteColor;
    }
    return _cityLabel;
}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [[UIView alloc] init];
        _circleView.translatesAutoresizingMaskIntoConstraints = NO;
        _circleView.backgroundColor =  [UIColor colorWithRed:0.97 green:0.95 blue:0.93 alpha:1.00]; // Gradient View?
    }
    return _circleView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.circleView];
        [_circleView.leadingAnchor pinTo:self.contentView.leadingAnchor withPadding:18.0];
        [[_circleView.widthAnchor constraintEqualToConstant:40.0] setActive:YES];
        [[_circleView.heightAnchor constraintEqualToConstant:40.0] setActive:YES];
        [_circleView.centerYAnchor pinTo:self.contentView.centerYAnchor];

        [self.contentView addSubview:self.cityLabel];
        [_cityLabel.leadingAnchor pinTo:_circleView.trailingAnchor withPadding:20];
        [_cityLabel.centerYAnchor pinTo:self.contentView.centerYAnchor];
        
        self.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.1];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.circleView.layer setCornerRadius:_circleView.bounds.size.width / 2];
}

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:highlighted ? 0.2 : 0.1];
}

@end

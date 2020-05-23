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

@interface CityForecastCell ()

@property (nonatomic) UIViewPropertyAnimator *animator;

@end

@implementation CityForecastCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.tintColor = UIColor.secondaryLabelColor;
    }
    return _imageView;
}

- (UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] init];
        _cityLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _cityLabel.textColor = [UIColor labelColor];
        _cityLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    }
    return _cityLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _timeLabel.textColor = UIColor.whiteColor;
    }
    return _timeLabel;
}

- (UILabel *)temperatureLabel {
    if (!_temperatureLabel) {
        _temperatureLabel = [UILabel new];
        _temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _temperatureLabel.textColor = [UIColor labelColor];
    }
    return _temperatureLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self.contentView addSubview:self.imageView];
        [_imageView.leadingAnchor pinTo:self.contentView.safeAreaLayoutGuide.leadingAnchor withPadding:18.0];
        [[_imageView.widthAnchor constraintEqualToConstant:40.0] setActive:YES];
        [[_imageView.heightAnchor constraintEqualToConstant:40.0] setActive:YES];
        [_imageView.centerYAnchor pinTo:self.contentView.centerYAnchor];

        [self.contentView addSubview:self.cityLabel];
        [_cityLabel.leadingAnchor pinTo:self.imageView.trailingAnchor withPadding:20];
        [_cityLabel.bottomAnchor pinTo:self.contentView.centerYAnchor];
        
        [self.contentView addSubview:self.timeLabel];
        [_timeLabel.leadingAnchor pinTo:_cityLabel.leadingAnchor];
        [_timeLabel.topAnchor pinTo:_cityLabel.bottomAnchor withPadding:5];
        _timeLabel.textColor = [UIColor secondaryLabelColor];
        _timeLabel.text = @"6:09 AM";
        _timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        
        [self.contentView addSubview:self.temperatureLabel];
        [_temperatureLabel.trailingAnchor pinTo:self.contentView.trailingAnchor withPadding:-15];
        [_temperatureLabel.centerYAnchor pinTo:self.contentView.centerYAnchor];
        _temperatureLabel.text = @"--";
        _temperatureLabel.font = [UIFont boldSystemFontOfSize:38];
        _temperatureLabel.textColor = [UIColor labelColor];
        
        self.backgroundColor = [UIColor secondarySystemBackgroundColor];
    }
    return self;
}

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.backgroundColor = highlighted ? [UIColor tertiarySystemBackgroundColor] : [UIColor secondarySystemBackgroundColor];
}

- (void)dragStateDidChange:(UICollectionViewCellDragState)dragState {
  switch (dragState) {
    case UICollectionViewCellDragStateNone:
      self.layer.opacity = 1;
      break;
    case UICollectionViewCellDragStateLifting:
      break;
    case UICollectionViewCellDragStateDragging:
      self.layer.opacity = 0;
      break;
  }
}

@end

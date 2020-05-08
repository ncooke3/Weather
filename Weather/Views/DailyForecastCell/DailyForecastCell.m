//
//  DailyForecastCell.m
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DailyForecastCell.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DailyForecastCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dayLabel.textColor = [UIColor labelColor];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_dayLabel];
        
        CGRect iconFrame = CGRectMake(0, 0, self.contentView.frame.size.width * 0.5, self.contentView.frame.size.width * 0.5);
        _iconImageView = [[UIImageView alloc] initWithFrame:iconFrame];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImageView];
        
        _highTempLabel = [[UILabel alloc] init];
        _highTempLabel.textColor = UIColor.labelColor;
        _highTempLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_highTempLabel];
        
        _lowTempLabel = [[UILabel alloc] init];
        _lowTempLabel.textColor = UIColor.secondaryLabelColor;
        _lowTempLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_lowTempLabel];
        
        self.layer.cornerRadius = 8;
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_dayLabel setCenter:CGPointMake(self.contentView.frame.size.width * 0.5, self.contentView.frame.size.height * 0.2)];
    [_iconImageView setCenter:CGPointMake(self.contentView.frame.size.width * 0.5, self.contentView.frame.size.height * 0.4)];
    [_highTempLabel setCenter:CGPointMake(self.contentView.frame.size.width * 0.5, self.contentView.frame.size.height * 0.6)];
    [_lowTempLabel setCenter:CGPointMake(self.contentView.frame.size.width * 0.5, self.contentView.frame.size.height * 0.8)];
}

@end

NS_ASSUME_NONNULL_END


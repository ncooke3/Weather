//
//  DailyForecastCell.m
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DailyForecastCell.h"

#define contentViewWidth  self.contentView.frame.size.width
#define contentViewHeight self.contentView.frame.size.height

NS_ASSUME_NONNULL_BEGIN

@implementation DailyForecastCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_dayLabel setTextColor:UIColor.darkGrayColor];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_dayLabel];
        
        CGRect iconFrame = CGRectMake(0, 0, contentViewWidth * 0.5, contentViewWidth * 0.5);
        _iconImageView = [[UIImageView alloc] initWithFrame:iconFrame];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImageView];
        
        _highTempLabel = [[UILabel alloc] init];
        [_highTempLabel setTextColor:[UIColor.redColor colorWithAlphaComponent:0.5]];
        _highTempLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_highTempLabel];
        
        _lowTempLabel = [[UILabel alloc] init];
        [_lowTempLabel setTextColor:[UIColor.blueColor colorWithAlphaComponent:0.5]];
        _lowTempLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_lowTempLabel];
    }
    return self;
    
}


- (void)layoutSubviews {
    [super layoutSubviews];

    [_dayLabel setCenter:CGPointMake(contentViewWidth * 0.5, contentViewHeight * 0.2)];
    [_iconImageView setCenter:CGPointMake(contentViewWidth * 0.5, contentViewHeight * 0.4)];
    [_highTempLabel setCenter:CGPointMake(contentViewWidth * 0.5, contentViewHeight * 0.6)];
    [_lowTempLabel setCenter:CGPointMake(contentViewWidth * 0.5, contentViewHeight * 0.8)];
}

@end

NS_ASSUME_NONNULL_END


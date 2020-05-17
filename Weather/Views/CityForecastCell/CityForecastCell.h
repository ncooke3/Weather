//
//  CityForecastCell.h
//  Weather
//
//  Created by Nicholas Cooke on 4/7/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CityForecastCell : UICollectionViewCell

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *cityLabel;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *temperatureLabel;


@end

NS_ASSUME_NONNULL_END

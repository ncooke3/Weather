//
//  DailyForecastCell.h
//  Weather
//
//  Created by Nicholas Cooke on 3/7/20.//  Created by Nicholas Cooke on 3/21/20.//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyForecastCell : UICollectionViewCell

@property (nonatomic) UILabel *dayLabel;
@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UILabel *highTempLabel;
@property (nonatomic) UILabel *lowTempLabel;

@end

NS_ASSUME_NONNULL_END

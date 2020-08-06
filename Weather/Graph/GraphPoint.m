//
//  GraphPoint.m
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "GraphPoint.h"

// Categories
#import "UISpringTimingParameters+Convenience.h"

@interface GraphPoint ()
@property (nonatomic) UIViewPropertyAnimator *animator;
@end

@implementation GraphPoint

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor labelColor];
        _label.backgroundColor = UIColor.clearColor;
        _label.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _label.alpha = 1;
        [self addSubview:_label];
        [_label setCenter:CGPointMake(self.center.x, self.center.y)];
        
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0, 0);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.layer setCornerRadius:self.bounds.size.width / 2];
}

- (void)expand {
    UISpringTimingParameters *timingParameters = [[UISpringTimingParameters alloc] initWithDamping:0.7 response:0.3];
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:10.0 timingParameters:timingParameters];
    __weak typeof(self) weakSelf = self;
    [animator addAnimations:^{
        weakSelf.transform = CGAffineTransformMakeScale(1.75, 1.75);
        weakSelf.label.transform = CGAffineTransformInvert(weakSelf.transform);
        weakSelf.associatedLabel.center = CGPointMake(weakSelf.associatedLabel.center.x, weakSelf.associatedLabel.center.y - 5);
        weakSelf.alpha = 1.0;
    }];
    [animator startAnimation];
}

- (void)shrink {
    UISpringTimingParameters *timingParameters = [[UISpringTimingParameters alloc] initWithDamping:0.7 response:0.2];
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 timingParameters:timingParameters];
    __weak typeof(self) weakSelf = self;
    [animator addAnimations:^{
        weakSelf.transform = CGAffineTransformMakeScale(0.8, 0.8);
        weakSelf.label.transform = weakSelf.transform;
        weakSelf.associatedLabel.center = CGPointMake(self.associatedLabel.center.x, self.associatedLabel.center.y + 5);
        weakSelf.alpha = 0.0;
    }];
    [animator startAnimation];
}

@end

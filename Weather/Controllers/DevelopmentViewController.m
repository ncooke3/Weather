//
//  DevelopmentViewController.m
//  Weather
//
//  Created by Nicholas Cooke on 4/11/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DevelopmentViewController.h"

// Views
#import "MoonButton.h"

// Categories
#import "UIView+Pinto.h"
#import "NSLayoutAnchor+Pinto.h"
#import "UIColor+WeatherColors.h"

@interface DevelopmentViewController ()

@property (nonatomic) UIView *sunMoonView;

@end

@implementation DevelopmentViewController

- (UIView *)sunMoonView { // GradientView from fluid interfaces?
    if (!_sunMoonView) {
        _sunMoonView = [[UIView alloc] init];
        _sunMoonView.translatesAutoresizingMaskIntoConstraints = NO;
        _sunMoonView.backgroundColor = [UIColor.grayColor colorWithAlphaComponent:0.2];
        _sunMoonView.layer.cornerRadius = 15.0;
    }
    return _sunMoonView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.sunMoonView];
    [_sunMoonView pinToCenterOfView:self.view];
    [[_sunMoonView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.9] setActive:YES];
    [[_sunMoonView.heightAnchor constraintEqualToConstant:120] setActive:YES];
    
    MoonButton *moonButton = [[MoonButton alloc] init];
    
    [_sunMoonView addSubview:moonButton];
    [moonButton.leadingAnchor pinTo:_sunMoonView.leadingAnchor withPadding:30];
    //[moonButton.topAnchor pinTo:_sunMoonView.topAnchor withPadding:20];
    [moonButton.centerYAnchor pinTo:_sunMoonView.centerYAnchor];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor moonColor];
    label.text = @"Sunrise in 5 hours.";
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [_sunMoonView addSubview:label];
    [label.centerYAnchor pinTo:_sunMoonView.centerYAnchor];
    [label.leadingAnchor pinTo:moonButton.trailingAnchor withPadding:30];
    
}


@end

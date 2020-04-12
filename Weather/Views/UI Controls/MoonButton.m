//
//  MoonButton.m
//  Weather
//
//  Created by Nicholas Cooke on 4/4/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "MoonButton.h"

// Categories
#import "UISpringTimingParameters+Convenience.h"
#import "UIColor+WeatherColors.h"

CGFloat distanceBetweenPoints(CGPoint p1, CGPoint p2) {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
}

typedef NS_ENUM(NSUInteger, ForceState) {
    ForceStateReset,
    ForceStateActivated,
    ForceStateConfirmed,
};

@interface MoonButton ()

@property (nonatomic) UIViewPropertyAnimator *animator;
@property (nonatomic) UIColor *moonColor;
@property (nonatomic) UIColor *sunColor;

/// Whether the button is on or off.
@property (nonatomic, getter=isMoon) BOOL moon;
/// The current state of the force press.
@property (nonatomic) ForceState forceState;
/// Whether the touch has exited the bounds of the button.
/// This is used to cancel touches that move outside of its bounds.
@property (nonatomic) BOOL touchExited;
@property (nonatomic) UIImpactFeedbackGenerator *activationFeedbackGenerator;
@property (nonatomic) UIImpactFeedbackGenerator *confirmationFeedbackGenerator;
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat maxWidth;
@property (nonatomic) UIColor *offColor;
@property (nonatomic) UIColor *onColor;
@property (nonatomic) CAShapeLayer *sunLayer;
@property (nonatomic) CAShapeLayer *moonLayer;
@property (nonatomic) CGFloat activationForce;
@property (nonatomic) CGFloat confirmationForce;
@property (nonatomic) CGFloat resetForce;
@end

@implementation MoonButton

// TODO: try replacing with factory methods?

- (CAShapeLayer *)sunLayer {
    if (!_sunLayer) {
        _sunLayer = [[CAShapeLayer alloc] init];
        _sunLayer.backgroundColor = [UIColor colorWithRed:0.98 green:0.80 blue:0.37 alpha:1.00].CGColor;
    }
    return _sunLayer;
}

- (CAShapeLayer *)moonLayer {
    if (!_moonLayer) {
        _moonLayer = [[CAShapeLayer alloc] init];
        _moonLayer.backgroundColor = [UIColor moonColor].CGColor;
    }
    return _moonLayer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _moon = YES; /// Moon at initialization?
        _forceState = ForceStateReset;
        _touchExited = NO;
        _activationFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        _confirmationFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        _minWidth = 50.0;
        _maxWidth = 92.0;
        _activationForce = 0.50;
        _confirmationForce = 0.49;
        _resetForce = 0.40;
        [self.layer addSublayer:self.moonLayer];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.moonLayer setFrame:self.bounds];
    [self.sunLayer setFrame:self.bounds];
    
    [self.moonLayer setCornerRadius:self.bounds.size.width / 2];
    [self.sunLayer setCornerRadius:self.bounds.size.width / 2];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(_minWidth, _minWidth);
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    _touchExited = NO;
    [self touchMoved:[[touches allObjects] firstObject]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self touchMoved:[[touches allObjects] firstObject]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self touchEnded:[[touches allObjects] firstObject]];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self touchEnded:[[touches allObjects] firstObject]];
}

# pragma mark - Handlers

- (void)touchMoved:(UITouch *)touch {
    if (!touch || _touchExited) { return; }
    
    CGFloat cancelDistance = _minWidth / 2 + 20;
    
    CGFloat distance = distanceBetweenPoints([touch locationInView:self], CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2));
    if (distance >= cancelDistance) {
        // the touch has moved outside of the bounds of the button
        _touchExited = YES;
        _forceState = ForceStateReset;
        [self animateToRest];
        return;
    }
    
    CGFloat force = touch.force / touch.maximumPossibleForce;
    CGFloat scale = 1 + (_maxWidth / _minWidth - 1) * force; // MARK: 1 + (-1) == 0 ?
    
    // update the button's size and color
    self.transform = CGAffineTransformMakeScale(scale, scale);

    switch (_forceState) {
        case ForceStateReset:
            if (force >= _activationForce) {
                _forceState = ForceStateActivated;
                [_activationFeedbackGenerator impactOccurred];
            }
            break;
        case ForceStateActivated:
            if (force <= _confirmationForce) {
                _forceState = ForceStateConfirmed;
                [self MB_activate];
            }
            break;
        case ForceStateConfirmed:
            if (force <= _resetForce) {
                _forceState = ForceStateReset;
            }
            break;
    }
    
}

- (void)touchEnded:(UITouch *)touch {
    if (_touchExited) { return; }
    if (_forceState == ForceStateActivated) { [self MB_activate]; }
    _forceState = ForceStateReset;
    [self animateToRest];
}

- (void)MB_activate {
    _moon = !_moon;
    CAShapeLayer *newLayer = self.isMoon ? self.moonLayer : self.sunLayer;
    [newLayer setFrame:self.bounds];
    [self.layer insertSublayer:newLayer atIndex:0];
    [_confirmationFeedbackGenerator impactOccurred];
}

- (void)animateToRest {
    UISpringTimingParameters *timingParameters = [[UISpringTimingParameters alloc] initWithDamping:0.4 response:0.2];
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.0 timingParameters:timingParameters];
    [animator addAnimations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
        [self.layer addSublayer:self.isMoon ? self.moonLayer : self.sunLayer];
    }];
    [animator setInterruptible:YES];
    [animator startAnimation];
}

@end

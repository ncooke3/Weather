//
//  GraphView.m
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "GraphView.h"
#import "GraphPoint.h"

NSInteger const kGapBetweenBackgroundVerticalBars = 4;
NSInteger const kPointLabelOffsetFromPointCenter = 25;
NSInteger const kPointLabelHeight = 20;

@interface GraphView ()

@property (nonatomic, strong) UIView *graphView;

@end

@implementation GraphView

- (void)setGraphData:(NSArray *)graphData {
    _graphData = graphData;
    [self plotGraphData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _strokeColor = [UIColor colorWithRed:0.71f green: 1.0f blue: 0.196f alpha: 1.0f];
        _strokeWidth = 2;
        _pointFillColor = [UIColor colorWithRed: 0.219f green: 0.657f blue: 0 alpha: 1.0f];
        _graphWidth = self.frame.size.width; // 2
        _labelingInterval = 1;
        _labelFont = [UIFont fontWithName:@"Futura-Medium" size:12];
        _labelFontColor = [UIColor whiteColor];
        _showPoints = NO;
        _showLabels = NO;
        _drawFilledGraph = NO;
        _animatedGraphDrawing = YES;
        _graphView = [[UIView alloc] init];
        [self addSubview:_graphView];
        self.contentSize = CGSizeMake(self.graphWidth, self.frame.size.height);
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(_graphWidth, self.frame.size.height);
}

#pragma mark - Graph Plotting

- (void)plotGraphData {
    if (!_graphData || [_graphData count] == 0) { return; }
    _coordinateDataPoints = [self coordinatePointsFromDataPoints:_graphData];
    [self drawCurvedLineBetweenPoints:_coordinateDataPoints withAnimation:_animatedGraphDrawing];
    // Now draw all the points
    if (_showPoints) {
        [self drawPointswithStrokeColour:_strokeColor andFill:_pointFillColor fromArray:_coordinateDataPoints];
    }
}

# pragma mark - Data Preparation
- (NSArray<NSValue *> *)coordinatePointsFromDataPoints:(NSArray<NSNumber *> *)dataPoints {
    
    NSMutableArray *coordinatePoints = [[NSMutableArray alloc] init];

    // Either the graphView needs to be instantiated with the data or we need a didSet or a prep method?
    // Configure graphView Frame

    NSInteger xCoordinateOffset = (_graphWidth / [_graphData count]) / 2;

    _graphView.frame = CGRectMake(-2.1 * xCoordinateOffset, 0, _graphWidth, self.frame.size.height);
//    self.frame = CGRectMake(_graphView.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height); // MARK: you can play with changing the scrollviews size
    
    // Get range and extreme values
    NSArray *dataInformation = [self rangeAndExtremesOf:_graphData];
    NSInteger lowest = [dataInformation[0] integerValue];
    NSInteger highest = [dataInformation[1] integerValue];
    NSInteger range = [dataInformation[2] integerValue];
    
    // Handle case where range is 0
    if (range == 0) {                   // in case all numbers are zero or all the same value
        lowest = 0;                     // makes it so that flat line isnt on x axis
        if (highest == 0) highest = 10; //arbitary number in case all numbers are 0
        range = highest * 2;
    }
    
    for (NSInteger counter = 1; counter <= [_graphData count]; counter++) {
        
        NSInteger xCoordinate = ((_graphWidth + (2.1 * xCoordinateOffset)) / [_graphData count]) * counter;
        
        NSInteger labelRelatedOffset = kPointLabelHeight + kPointLabelOffsetFromPointCenter;
        NSInteger topInset = 15;
        NSInteger bottomInset = 15;
        float graphViewHeightGraphableAreaRatio = (self.frame.size.height - labelRelatedOffset) / (self.frame.size.height + topInset + bottomInset);
        float yAxisRatio = ((self.frame.size.height * graphViewHeightGraphableAreaRatio) / range);
        NSInteger yCoordinateContributionFromDataPoint = ([[_graphData objectAtIndex:counter - 1] integerValue] * yAxisRatio);
        NSInteger yCoordinateContributionFromMininumDataPoint = (lowest * yAxisRatio);
        NSInteger yCoordinate = self.frame.size.height - yCoordinateContributionFromDataPoint + yCoordinateContributionFromMininumDataPoint - bottomInset;
        
        CGPoint point = CGPointMake(xCoordinate, yCoordinate);
        
        if (_showLabels) {
            if (!(counter % _labelingInterval)) {
                if (counter != 1 && counter != [_graphData count]) {
                    [self createPointLabelForPoint:point withLabelText:[NSString stringWithFormat:@"%@°", [[_graphData objectAtIndex:counter - 1] stringValue]]];
                }
            }
        }
        [coordinatePoints addObject:[NSValue valueWithCGPoint:point]];
    }
    return coordinatePoints;
}

#pragma mark - Drawing

// Catmull-Rom Algorithm
- (void)drawCurvedLineBetweenPoints:(NSArray *)points withAnimation:(BOOL)animation {
    float granularity = 100;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithObject:[points firstObject]];
    [mutableArray addObjectsFromArray:points];
    [mutableArray addObject:[points lastObject]];
    
    points = [NSArray arrayWithArray:mutableArray];
    
    [path moveToPoint:[[points firstObject] CGPointValue]];
    
    for (int index = 1; index < points.count - 2 ; index++) {
        
        CGPoint point0 = [[points objectAtIndex:index - 1] CGPointValue];
        CGPoint point1 = [[points objectAtIndex:index] CGPointValue];
        CGPoint point2 = [[points objectAtIndex:index + 1] CGPointValue];
        CGPoint point3 = [[points objectAtIndex:index + 2] CGPointValue];
        
        for (int i = 1; i < granularity ; i++) {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi;
            pi.x = 0.5 * (2*point1.x+(point2.x-point0.x)*t + (2*point0.x-5*point1.x+4*point2.x-point3.x)*tt + (3*point1.x-point0.x-3*point2.x+point3.x)*ttt);
            pi.y = 0.5 * (2*point1.y+(point2.y-point0.y)*t + (2*point0.y-5*point1.y+4*point2.y-point3.y)*tt + (3*point1.y-point0.y-3*point2.y+point3.y)*ttt);
            
            if (pi.y > _graphView.frame.size.height) {
                pi.y = _graphView.frame.size.height;
            } else if (pi.y < 0) {
                pi.y = 0;
            }
            
            if (pi.x > point0.x) {
                [path addLineToPoint:pi];
            }
        }
        
        [path addLineToPoint:point2];
    }
    
    [path addLineToPoint:[[points lastObject] CGPointValue]];
    [path setLineCapStyle:kCGLineCapRound];
    
    self.graphBezierPath = path;
    
    if (_drawFilledGraph) {
        CGPoint bottomLeftPoint = CGPointMake([[points firstObject] CGPointValue].x, self.frame.size.height);
        CGPoint bottomRightPoint = CGPointMake([[points lastObject] CGPointValue].x, self.frame.size.height);
        [path addLineToPoint: bottomRightPoint];
        [path addLineToPoint:bottomLeftPoint];
        [path addLineToPoint:[[points firstObject] CGPointValue]];
        [path closePath];
    }
    
    CAShapeLayer *shapeView = [[CAShapeLayer alloc] init];
    shapeView.path = [path CGPath];
    shapeView.strokeColor = _strokeColor.CGColor;
    shapeView.fillColor = _drawFilledGraph ? _strokeColor.CGColor : UIColor.clearColor.CGColor;
    shapeView.lineWidth = _strokeWidth;
    [shapeView setLineCap:kCALineCapRound];
    [_graphView.layer addSublayer:shapeView];
    
    if (animation) {
        shapeView.strokeStart = 0.0;

        CABasicAnimation* strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.fillMode = kCAFillModeForwards;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        strokeAnimation.duration = 1.0;
        strokeAnimation.fromValue = @(0.0);
        strokeAnimation.toValue = @(1.0);
        [shapeView addAnimation:strokeAnimation forKey:@"strokeAnim"];

        CABasicAnimation *fillColorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
        fillColorAnimation.duration = 1.0;
        fillColorAnimation.fromValue = (id)[[UIColor clearColor] CGColor];
        fillColorAnimation.toValue = (id)[_strokeColor CGColor];
        [fillColorAnimation setRemovedOnCompletion:NO];
        [fillColorAnimation setFillMode:kCAFillModeBoth];

        [shapeView addAnimation:fillColorAnimation forKey:@"fillColor"];
    }
}

- (void)createPointLabelForPoint:(CGPoint)point withLabelText:(NSString *)text {
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x , point.y, 30, kPointLabelHeight)];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    [tempLabel setTextColor:_labelFontColor];
    [tempLabel setBackgroundColor:UIColor.clearColor];
    [tempLabel setFont:_labelFont];
    [tempLabel setAdjustsFontSizeToFitWidth:YES];
    [tempLabel setMinimumScaleFactor:0.6];
    tempLabel.alpha = 0;
    [_graphView addSubview:tempLabel];
    [tempLabel setCenter:CGPointMake(point.x, point.y - kPointLabelOffsetFromPointCenter)];
    [tempLabel setText:text];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempLabel.alpha = 1.0;
    } completion:nil];
}

- (void)drawPointswithStrokeColour:(UIColor *)strokeColor andFill:(UIColor *)fillColor fromArray:(NSArray *)pointsArray {
    for (id point in pointsArray) {
        GraphPoint *graphPoint = [[GraphPoint alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [graphPoint setStrokeColour:strokeColor];
        [graphPoint setFillColour:fillColor];
        [graphPoint setCenter:[point CGPointValue]];
        [graphPoint setBackgroundColor:UIColor.clearColor];
        [_graphView addSubview:graphPoint];
    }
}

#pragma mark - Graph Data Utils

- (NSArray *)rangeAndExtremesOf:(NSArray<NSNumber *> *)data {
    NSInteger minimum = NSIntegerMax;
    NSInteger maximum = -NSIntegerMax;
    for (NSNumber *dataPoint in data) {
        NSInteger dataPointInt = [dataPoint integerValue];
        minimum = MIN(minimum, dataPointInt);
        maximum = MAX(maximum, dataPointInt);
    }
    NSInteger range = maximum - minimum;
    return @[@(minimum), @(maximum), @(range)];
}

@end

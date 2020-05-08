//
//  GraphView.m
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "GraphView.h"

// Views
#import "GraphPoint.h"

// Categories
#import "UISpringTimingParameters+Convenience.h"

NSInteger const kGapBetweenBackgroundVerticalBars = 4;
NSInteger const kPointLabelOffsetFromPointCenter = 25;
NSInteger const kPointLabelHeight = 20;

@interface GraphView () <UIGestureRecognizerDelegate>

@property (nonatomic) CAShapeLayer *shapeView;
@property (nonatomic) UIView *graphView;
@property (nonatomic) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic) NSMutableArray<GraphPoint *> *graphPoints;
@property (nonatomic) NSMutableArray<NSValue *> *dataCoordinatePoints;
@property (nonatomic) GraphPoint *currentlyExpandedGraphPoint;
@property (nonatomic) UIImpactFeedbackGenerator *feedbackGenerator;

@end

@implementation GraphView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _strokeColor = UIColor.systemIndigoColor;
        _strokeWidth = 2;
        _pointFillColor = UIColor.darkGrayColor;
        _graphWidth = self.frame.size.width; // 2
        _labelingInterval = 1;
        _labelFont = [UIFont fontWithName:@"Futura-Medium" size:12];
        _labelFontColor = [UIColor whiteColor];
        _labelUnits = @"";
        _drawFilledGraph = YES;
        _animated = YES;
        _graphView = [[UIView alloc] init];
        [self addSubview:_graphView];
        self.contentSize = CGSizeMake(self.graphWidth, self.frame.size.height);
        
        _feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        
        _gestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        [_gestureRecognizer addTarget:self action:@selector(pannedWithRecognizer:)];
        _gestureRecognizer.delegate = self;
        [_graphView addGestureRecognizer:_gestureRecognizer];
        
        _graphPoints = [[NSMutableArray alloc] init];
    
        self.clipsToBounds = NO;
    }
    return self;
}

#pragma mark - UITraitCollection

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    _shapeView.fillColor = _strokeColor.CGColor;
    _shapeView.strokeColor = _strokeColor.CGColor;
}

#pragma mark - Gesture Recongizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (fabs([_gestureRecognizer translationInView:_graphView].x) < 10) {
        return YES;
    } else {
        return NO;
    }
    
}

#pragma mark - Handlers

- (void)pannedWithRecognizer:(UIPanGestureRecognizer *)recognizer {
    if (fabs([_gestureRecognizer translationInView:_graphView].x) < 15 && _currentlyExpandedGraphPoint == nil) {
        return;
    }
    
    if (recognizer.state == 1 || recognizer.state == 2) {
        CGPoint touchPoint = [recognizer locationInView:_graphView];
        GraphPoint *pannedGraphPoint = [self closestGraphPointFromTouchPoint:touchPoint];
        // User has scrubbed to a new point
        if (pannedGraphPoint != _currentlyExpandedGraphPoint) {
            if (_currentlyExpandedGraphPoint != nil) [_currentlyExpandedGraphPoint shrink];
            pannedGraphPoint.backgroundColor = _pointFillColor;
            [pannedGraphPoint expand];
            _currentlyExpandedGraphPoint = pannedGraphPoint;
            [_feedbackGenerator impactOccurred];
        }
    } else if (recognizer.state >= 3) {
        [_currentlyExpandedGraphPoint shrink];
        _currentlyExpandedGraphPoint = nil;
    }
}

#pragma mark - Graph Plotting

- (void)plotWithData:(NSArray<NSArray *> *)data {
    if (!data || [data count] == 0) { return; }
    _graphWidth = self.frame.size.width;
    
    _dataCoordinatePoints = [self coordinatePointsFromGraphData:data];
    
    [self drawCurvedLineBetweenPoints:_dataCoordinatePoints];
    
    [self addPointsAndLabelsAtPoints:_dataCoordinatePoints forData:data];
}

- (void)plotGraphData {
    if (!_graphData || [_graphData count] == 0) { return; }
    
    _dataCoordinatePoints = [self coordinatePointsFromGraphData:_graphData];
    
    [self drawCurvedLineBetweenPoints:_dataCoordinatePoints];
    
    [self addPointsAndLabelsAtPoints:_dataCoordinatePoints forData:_graphData];
}

# pragma mark - Data Processing

- (NSMutableArray<NSValue *> *)coordinatePointsFromGraphData:(NSArray<NSArray *> *)dataPoints {
    
    NSMutableArray *coordinatePoints = [[NSMutableArray alloc] init];

    NSInteger xCoordinateOffset = (_graphWidth / [dataPoints count]) / 2;

    _graphView.frame = CGRectMake(-2.1 * xCoordinateOffset, 0, _graphWidth, self.frame.size.height);
//    self.frame = CGRectMake(_graphView.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height); // MARK: you can play with changing the scrollviews size
    
    // Get range and extreme values
    NSArray *dataInformation = [self rangeAndExtremesOf:dataPoints];
    NSInteger lowest = [dataInformation[0] integerValue];
    NSInteger highest = [dataInformation[1] integerValue];
    NSInteger range = [dataInformation[2] integerValue];
    
    // Handle case where range is 0
    if (range == 0) {                   // in case all numbers are zero or all the same value
        lowest = 0;                     // makes it so that flat line isnt on x axis
        if (highest == 0) highest = 10; //arbitary number in case all numbers are 0
        range = highest * 2;
    }
    
    for (NSInteger counter = 1; counter <= [dataPoints count]; counter++) {
        
        NSInteger xCoordinate = ((_graphWidth + (2.1 * xCoordinateOffset)) / [dataPoints count]) * counter;
        
        NSInteger labelRelatedOffset = kPointLabelHeight + kPointLabelOffsetFromPointCenter;
        NSInteger topInset = 15;
        NSInteger bottomInset = 45; // This should push the graph's line up a bit.
        float graphViewHeightGraphableAreaRatio = (self.frame.size.height - labelRelatedOffset) / (self.frame.size.height + topInset + bottomInset);
        float yAxisRatio = ((self.frame.size.height * graphViewHeightGraphableAreaRatio) / range);
        NSInteger yCoordinateContributionFromDataPoint = ([[[dataPoints objectAtIndex:counter - 1] lastObject] integerValue] * yAxisRatio);
        NSInteger yCoordinateContributionFromMininumDataPoint = (lowest * yAxisRatio);
        NSInteger yCoordinate = self.frame.size.height - yCoordinateContributionFromDataPoint + yCoordinateContributionFromMininumDataPoint - bottomInset;
        
        CGPoint point = CGPointMake(xCoordinate, yCoordinate);

        [coordinatePoints addObject:[NSValue valueWithCGPoint:point]];
    }
    return coordinatePoints;
}

- (NSArray *)rangeAndExtremesOf:(NSArray<NSArray *> *)data {
    NSInteger minimum = NSIntegerMax;
    NSInteger maximum = -NSIntegerMax;
    for (NSArray *dataPoint in data) {
        NSInteger dataPointInt = [dataPoint.lastObject integerValue];
        minimum = MIN(minimum, dataPointInt);
        maximum = MAX(maximum, dataPointInt);
    }
    NSInteger range = maximum - minimum;
    return @[@(minimum), @(maximum), @(range)];
}

#pragma mark - Drawing

// Catmull-Rom Algorithm
- (void)drawCurvedLineBetweenPoints:(NSArray *)points {
    float granularity = 100;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithObject:[[points firstObject] copy]];
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
    
    if (_drawFilledGraph) {
        CGPoint bottomLeftPoint = CGPointMake([[points firstObject] CGPointValue].x, self.frame.size.height);
        CGPoint bottomRightPoint = CGPointMake([[points lastObject] CGPointValue].x, self.frame.size.height);
        [path addLineToPoint: bottomRightPoint];
        [path addLineToPoint:bottomLeftPoint];
        [path addLineToPoint:[[points firstObject] CGPointValue]];
        [path closePath];
    }
    
    _shapeView = [[CAShapeLayer alloc] init];
    _shapeView.path = [path CGPath];
    _shapeView.strokeColor = _strokeColor.CGColor;
    _shapeView.fillColor = _drawFilledGraph ? _strokeColor.CGColor : UIColor.clearColor.CGColor;
    _shapeView.lineWidth = _strokeWidth;
    [_shapeView setLineCap:kCALineCapRound];
    [_graphView.layer addSublayer:_shapeView];
        
}

- (UILabel *)labelForPoint:(CGPoint)point withLabelText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(point.x , point.y, 30, -kPointLabelHeight)];
    label.backgroundColor = UIColor.clearColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = _labelFontColor;
    label.font = _labelFont;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.6;
    label.alpha = 0;
    
    // MARK: This is not really how we should be doing this
    if ([_labelUnits isEqualToString:@"%"]) {
        NSAttributedString *smallerPercent = [[NSAttributedString alloc] initWithString:_labelUnits attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSBaselineOffsetAttributeName:@(1)}];
        NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] init];
        [labelText appendAttributedString:smallerPercent];
        [labelText appendAttributedString:[[NSAttributedString alloc] initWithString:[(NSNumber*)text stringValue]]];
        [labelText appendAttributedString:smallerPercent];
        [labelText addAttribute:NSForegroundColorAttributeName value:UIColor.clearColor range:NSMakeRange(0, 1)];
        label.attributedText = labelText;
    } else {
        NSString *centeredText = [NSMutableString stringWithFormat:@"%@%@%@",_labelUnits, text, _labelUnits];
        NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:centeredText];
        [labelText addAttribute:NSForegroundColorAttributeName value:UIColor.clearColor range:NSMakeRange(0, 1)];
        label.attributedText = labelText;
    }
    
    return label;
}

- (void)addPointsAndLabelsAtPoints:(NSArray<NSValue *> *)coordinatePoints forData:(NSArray<NSArray *> *)data {
    [_dataCoordinatePoints removeObjectAtIndex:0]; // cuts off first point
    [_dataCoordinatePoints removeLastObject]; // cuts off last point
    
    // Loop through graph data and corresponding coordinatePoints
    for (NSUInteger index = 0; index < [coordinatePoints count]; index++) {
        CGPoint point = [coordinatePoints[index] CGPointValue];
        
        // Create data point for data item
        GraphPoint *graphPoint = [[GraphPoint alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        graphPoint.label.text = data[index + 1].firstObject;
        [graphPoint setCenter:point];
        [_graphView addSubview:graphPoint];
        [_graphPoints addObject:graphPoint];
        
        // Add value label for data item
        UILabel *valueLabel = [self labelForPoint:point withLabelText:data[index + 1].lastObject];
        [_graphView addSubview:valueLabel];
        [valueLabel setCenter:CGPointMake(point.x, point.y - kPointLabelOffsetFromPointCenter)];
        
        // Assign floating label to point
        graphPoint.associatedLabel = valueLabel;
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            valueLabel.alpha = 1.0;
        } completion:nil];
        
    }
}

#pragma mark - Utils

- (GraphPoint *)closestGraphPointFromTouchPoint:(CGPoint)touchPoint {
    NSUInteger index = [_dataCoordinatePoints indexOfObject:@(touchPoint.x) inSortedRange:NSMakeRange(0, [_dataCoordinatePoints count] - 1) options:NSBinarySearchingInsertionIndex | NSBinarySearchingInsertionIndex usingComparator:^(NSNumber * dataCoordinate, NSNumber *touchPointX) {
        return [@([dataCoordinate CGPointValue].x) compare:touchPointX];
    }];
    return [_graphPoints objectAtIndex:index];
}

@end

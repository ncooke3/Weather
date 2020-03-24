//
//  GraphView.h
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphView : UIScrollView

// CGPoints for the graph's data
@property (nonatomic) NSArray<NSValue *> *coordinateDataPoints;

@property (nonatomic) UIBezierPath *graphBezierPath;

// Array of NSNumbers used to plot points on graph
@property (strong, nonatomic) NSArray *graphData;

// Interval between points in which to add data labels
@property (assign) NSInteger labelingInterval;

// Colour of the graph line
@property (strong, nonatomic) UIColor *strokeColor;

// Choose whether or not to fill area under curve with strokeFillColor
// defaults to NO
@property (assign) BOOL drawFilledGraph;

@property (assign) BOOL animatedGraphDrawing;

//Colour of the graph, defaults to clear
@property (strong, nonatomic) UIColor *strokeFillColor;

// Fill colour for the point on the graph
@property (strong, nonatomic) UIColor *pointFillColor;

// Width of the stroke of the graph line
@property NSUInteger strokeWidth;

// Choose whether to hide the points and just show line
// defaults to NO
@property (assign) BOOL showPoints;

// Choose whether to hide the labels floating above the points
@property (assign) BOOL showLabels;

// Choose how wide in pts the graph should be
// defaults to width of screen (landscape) x2
@property (assign) NSUInteger graphWidth;

// Font to use on the x and y axis labels
@property (strong, nonatomic) UIFont *labelFont;

// Font colour of the x and y axis labels
@property (strong, nonatomic) UIColor *labelFontColor;

- (void)plotGraphData;

@end

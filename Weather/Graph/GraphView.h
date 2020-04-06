//
//  GraphView.h
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphView : UIScrollView

// Array of NSNumbers used to plot points on graph
// Expected Type is @[@"labelTextFor", @(numerical value)];
@property (nonatomic) NSArray<NSArray *> *graphData;

// Interval between points in which to add data labels
@property (assign) NSInteger labelingInterval;

// Colour of the graph line
@property (strong, nonatomic) UIColor *strokeColor;

// Choose whether or not to fill area under curve with strokeFillColor
// defaults to YES
@property (assign) BOOL drawFilledGraph;

@property (assign, getter=isAnimated) BOOL animated;

//Colour of the graph, defaults to clear
@property (nonatomic) UIColor *strokeFillColor;

// Fill colour for the point on the graph
@property (nonatomic) UIColor *pointFillColor;

// Width of the stroke of the graph line
@property NSUInteger strokeWidth;

// Choose how wide in pts the graph should be
// defaults to width of screen (landscape) x2
@property (assign) NSUInteger graphWidth;

// Font to use on the x and y axis labels
@property (nonatomic) UIFont *labelFont;

// Font colour of the x and y axis labels
@property (nonatomic) UIColor *labelFontColor;

@property (nonatomic) NSString *labelUnits;

- (void)plotGraphData;
- (void)plotWithData:(NSArray<NSArray *> *)data;
@end

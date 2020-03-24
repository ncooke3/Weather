//
//  GraphPoint.m
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "GraphPoint.h"

@implementation GraphPoint

@synthesize strokeColour, fillColour;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* stroke = strokeColour;
    UIColor* fill = fillColour;
    
    //// Oval 2 Drawing
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2, 2, 16, 16)];
    [fill setFill];
    [oval2Path fill];
    [stroke setStroke];
    oval2Path.lineWidth = 2.5;
    [oval2Path stroke];
}


@end

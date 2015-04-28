//
//  BaseView.m
//  BezierInterpolation
//
//  Created by Wagner Truppel on 5/15/09.
//  Copyright Wagner Truppel 2009. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

// ========================================================================= //
                         #pragma mark public methods
// ========================================================================= //

- (void) dealloc
{
    [avgCurvatureTF release];
    [points release];

    [super dealloc];
}

// ========================================================================= //

- (void) processPoints: (NSArray*) pointsA
{
    /* meant to be implemented by subclasses */
}

// ========================================================================= //

@end

void drawPoint(id pointAsValue)
{
    NSPoint p = [(NSValue*) pointAsValue pointValue];

	[[NSBezierPath bezierPathWithOvalInRect:
		NSMakeRect(p.x - POINT_SIZE / 2, p.y - POINT_SIZE / 2,
		           POINT_SIZE, POINT_SIZE)]
       fill];
}

// ========================================================================= //

void drawLine(id pointAsValueA, id pointAsValueB)
{
    NSPoint a = [(NSValue*) pointAsValueA pointValue];
    NSPoint b = [(NSValue*) pointAsValueB pointValue];

	NSBezierPath *path = [NSBezierPath bezierPath];
	[path moveToPoint: a];
	[path lineToPoint: b];
	[path stroke];
}

// ========================================================================= //

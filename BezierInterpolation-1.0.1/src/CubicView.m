//
//  CubicView.m
//  BezierInterpolation
//
//  Created by Wagner Truppel on 5/15/09.
//  Copyright Wagner Truppel 2009. All rights reserved.
//

#import "CubicView.h"

@implementation CubicView

// ========================================================================= //
                         #pragma mark public methods
// ========================================================================= //

- (void) dealloc;
{
    [qPoints release];
    [rPoints release];

    [super dealloc];
}

// ========================================================================= //

- (void) drawRect: (NSRect) rect
{
    [super drawRect: rect];

    int i;

    for (i = 0; i < [points count]-1; ++i)
    {
        drawLine([points objectAtIndex: i], [points objectAtIndex: i+1]);
    }

	NSBezierPath *path = [NSBezierPath bezierPath];

    for (i = 0; i < [points count]-1; ++i)
    {
        NSPoint p0 = [(NSValue*) [ points objectAtIndex: i]   pointValue];
        NSPoint p1 = [(NSValue*) [ points objectAtIndex: i+1] pointValue];

        NSPoint q0 = [(NSValue*) [qPoints objectAtIndex: i]   pointValue];
        NSPoint r0 = [(NSValue*) [rPoints objectAtIndex: i]   pointValue];

        [path moveToPoint: p0];
        [path curveToPoint: p1 controlPoint1: q0 controlPoint2: r0];
    }

	[[NSColor greenColor] set];
	[path stroke];

	[[NSColor blueColor] set];
    for (i = 0; i < [points count]; ++i)
    {
        drawPoint([points objectAtIndex: i]);
    }

	[[NSColor redColor] set];
    for (i = 0; i < [points count]-1; ++i)
    {
        drawPoint([qPoints objectAtIndex: i]);
    }

	[[NSColor yellowColor] set];
    for (i = 0; i < [points count]-1; ++i)
    {
        drawPoint([rPoints objectAtIndex: i]);
    }
}

// ========================================================================= //

- (void) processPoints: (NSArray*) pointsA
{
    [points release];
     points = [pointsA retain];

    [qPoints release];
     qPoints = [[NSMutableArray alloc] initWithCapacity: NUM_POINTS];

    [rPoints release];
     rPoints = [[NSMutableArray alloc] initWithCapacity: NUM_POINTS];

    int i;
    for (i = 0; i < NUM_POINTS; ++i)
    {
        [qPoints addObject: [NSNull null]];
        [rPoints addObject: [NSNull null]];
    }

    NSPoint pNm2 = [(NSValue*) [points objectAtIndex: NUM_POINTS-2] pointValue];
    NSPoint pNm1 = [(NSValue*) [points objectAtIndex: NUM_POINTS-1] pointValue];

    NSPoint rNm2 = NSMakePoint(0, 0);
    NSPoint qNm2 = NSMakePoint(0, 0);

    rNm2.x = (pNm2.x + 2.0 * pNm1.x) / 3.0;
    rNm2.y = (pNm2.y + 2.0 * pNm1.y) / 3.0;

    qNm2.x = (2.0 * pNm2.x + pNm1.x) / 3.0;
    qNm2.y = (2.0 * pNm2.y + pNm1.y) / 3.0;

    [qPoints replaceObjectAtIndex: NUM_POINTS - 2
                       withObject: [NSValue valueWithPoint: qNm2]];

    [rPoints replaceObjectAtIndex: NUM_POINTS - 2
                       withObject: [NSValue valueWithPoint: rNm2]];

    int n;
    for (n = NUM_POINTS-3; n >= 0; --n)
    {
        NSPoint pn   = [(NSValue*) [ points objectAtIndex: n]   pointValue];
        NSPoint pnp1 = [(NSValue*) [ points objectAtIndex: n+1] pointValue];
        NSPoint qnp1 = [(NSValue*) [qPoints objectAtIndex: n+1] pointValue];

        NSPoint qn = NSMakePoint(0, 0);
        NSPoint rn = NSMakePoint(0, 0);

        qn.x = (11.0 * pn.x + 9.0 * qnp1.x - 8.0 * pnp1.x) / 12.0;
        qn.y = (11.0 * pn.y + 9.0 * qnp1.y - 8.0 * pnp1.y) / 12.0;

        rn.x = 2.0 * pnp1.x - qnp1.x;
        rn.y = 2.0 * pnp1.y - qnp1.y;

        [qPoints replaceObjectAtIndex: n
                           withObject: [NSValue valueWithPoint: qn]];

        [rPoints replaceObjectAtIndex: n
                           withObject: [NSValue valueWithPoint: rn]];
    }

    double S = 0.0;
    double x, y;
    double xp, yp;

    for (n = 0; n <= NUM_POINTS-2; ++n)
    {
        NSPoint qn   = [(NSValue*) [qPoints objectAtIndex: n]   pointValue];
        NSPoint rn   = [(NSValue*) [rPoints objectAtIndex: n]   pointValue];

        NSPoint pn   = [(NSValue*) [ points objectAtIndex: n]   pointValue];
        NSPoint pnp1 = [(NSValue*) [ points objectAtIndex: n+1] pointValue];

        x = 3.0 * qn.x - 2.0 * pn.x - pnp1.x;
        y = 3.0 * qn.y - 2.0 * pn.y - pnp1.y;

        S += (x*x + y*y) / 3.0;

        x = pn.x + rn.x - 2.0 * qn.x;
        y = pn.y + rn.y - 2.0 * qn.y;

        S += 9.0 * (x*x + y*y) / 5.0;

        x = 3.0 * qn.x - 3.0 * rn.x + pnp1.x - pn.x;
        y = 3.0 * qn.y - 3.0 * rn.y + pnp1.y - pn.y;

        S += (x*x + y*y) / 7.0;

        x = 3.0 * qn.x - 2.0 * pn.x - pnp1.x;
        y = 3.0 * qn.y - 2.0 * pn.y - pnp1.y;

        xp = pn.x + rn.x - 2.0 * qn.x;
        yp = pn.y + rn.y - 2.0 * qn.y;

        S += 3.0 * (x*xp + y*yp) / 2.0;

        xp = 3.0 * qn.x - 3.0 * rn.x + pnp1.x - pn.x;
        yp = 3.0 * qn.y - 3.0 * rn.y + pnp1.y - pn.y;

        S += 2.0 * (x*xp + y*yp) / 5.0;

        x = pn.x + rn.x - 2.0 * qn.x;
        y = pn.y + rn.y - 2.0 * qn.y;

        S += (x*xp + y*yp);
    }

    S /= 1000.0;
    S /= (NUM_POINTS-1);

    [avgCurvatureTF setDoubleValue: S];
    [self setNeedsDisplay: YES];
}

// ========================================================================= //

@end

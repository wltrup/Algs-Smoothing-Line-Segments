//
//  QuadraticView.m
//  BezierInterpolation
//
//  Created by Wagner Truppel on 5/15/09.
//  Copyright Wagner Truppel 2009. All rights reserved.
//

#import "QuadraticView.h"

@implementation QuadraticView

// ========================================================================= //
                         #pragma mark public methods
// ========================================================================= //

- (void) dealloc;
{
    [qPoints release];
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

        [path moveToPoint: p0];
        [path curveToPoint: p1 controlPoint1: q0 controlPoint2: p1];
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
}

// ========================================================================= //

- (void) processPoints: (NSArray*) pointsA
{
    [points release];
     points = [pointsA retain];

    [qPoints release];
     qPoints = [[NSMutableArray alloc] initWithCapacity: NUM_POINTS];

    int i;
    for (i = 0; i < NUM_POINTS; ++i)
    {
        [qPoints addObject: [NSNull null]];
    }

    NSPoint p0   = [(NSValue*) [points objectAtIndex:            0] pointValue];
    NSPoint pNm1 = [(NSValue*) [points objectAtIndex: NUM_POINTS-1] pointValue];

    int s = (NUM_POINTS % 2 == 0) ? 1 : -1;
    NSPoint qNm2 = NSMakePoint(0, 0);

    qNm2.x = (s * p0.x + pNm1.x) / 2.0;
    qNm2.y = (s * p0.y + pNm1.y) / 2.0;

    int k;
    for (k = 1; k <= NUM_POINTS-2; ++k)
    {
        s = ((NUM_POINTS + k) % 2 == 0) ? 1 : -1;

        NSPoint pk = [(NSValue*) [points objectAtIndex: k] pointValue];

        qNm2.x += (s * 2.0 * k * pk.x);
        qNm2.y += (s * 2.0 * k * pk.y);
    }

    qNm2.x /= (NUM_POINTS - 1);
    qNm2.y /= (NUM_POINTS - 1);

    [qPoints replaceObjectAtIndex: NUM_POINTS - 2
                       withObject: [NSValue valueWithPoint: qNm2]];

    int n;
    for (n = 0; n < NUM_POINTS-2; ++n)
    {
        s = ((NUM_POINTS - n) % 2 == 0) ? 1 : -1;
        NSPoint qn = NSMakePoint(0, 0);

        qn.x = s * qNm2.x;
        qn.y = s * qNm2.y;

        s = 1;
        for (k = 0; k <= NUM_POINTS-3-n; ++k)
        {
            NSPoint pnk1 = [(NSValue*) [points objectAtIndex: n+k+1]
                                            pointValue];

            qn.x += s * 2.0 * pnk1.x;
            qn.y += s * 2.0 * pnk1.y;

            s = -s;
        }

        [qPoints replaceObjectAtIndex: n
                           withObject: [NSValue valueWithPoint: qn]];
    }

    double S = 0.0;

    for (n = 0; n <= NUM_POINTS-2; ++n)
    {
        NSPoint qn   = [(NSValue*) [qPoints objectAtIndex: n]   pointValue];
        NSPoint pn   = [(NSValue*) [ points objectAtIndex: n]   pointValue];
        NSPoint pnp1 = [(NSValue*) [ points objectAtIndex: n+1] pointValue];

        double x = 2.0 * qn.x - pn.x - pnp1.x;
        double y = 2.0 * qn.y - pn.y - pnp1.y;

        S += (x*x + y*y);
    }

    S /= 30000.0;
    S /= (NUM_POINTS-1);

    [avgCurvatureTF setDoubleValue: S];
    [self setNeedsDisplay: YES];
}

// ========================================================================= //

@end

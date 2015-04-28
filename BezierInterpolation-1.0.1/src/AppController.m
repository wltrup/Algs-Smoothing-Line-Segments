//
//  AppController.m
//  BezierInterpolation
//
//  Created by Wagner Truppel on 5/15/09.
//  Copyright Wagner Truppel 2009. All rights reserved.
//

#import "AppController.h"

NSInteger comparePoints(id pointAsValueA, id pointAsValueB, void* context);

@implementation AppController

// ========================================================================= //
                         #pragma mark public methods
// ========================================================================= //

- (void) awakeFromNib
{
    srandom(time(NULL));
    [NSBezierPath setDefaultLineWidth: 2.0];
    [self actionReSeed: self];
}

// ========================================================================= //

- (void) dealloc
{
    [quadraticView release];
    [    cubicView release];

    [super dealloc];
}

// ========================================================================= //
                          #pragma mark IB actions
// ========================================================================= //

- (IBAction) actionReSeed: (id) sender
{
	NSRect bounds = [quadraticView bounds];

	NSMutableArray* points = [[NSMutableArray alloc]
	    initWithCapacity: NUM_POINTS];

    int i;
    for (i = 0; i < NUM_POINTS; ++i)
    {
        NSPoint p = NSMakePoint(
            POINT_SIZE + random() % (int) (bounds.size.width  - 2*POINT_SIZE),
            POINT_SIZE + random() % (int) (bounds.size.height - 2*POINT_SIZE));

        [points addObject: [NSValue valueWithPoint: p]];
    }

    [points sortUsingFunction: comparePoints context: nil];

	[quadraticView processPoints: points];
	[    cubicView processPoints: points];

    [points release];
     points = nil;
}

// ========================================================================= //

@end

NSInteger comparePoints(id pointAsValueA, id pointAsValueB, void* context)
{
    NSPoint a = [(NSValue*) pointAsValueA pointValue];
    NSPoint b = [(NSValue*) pointAsValueB pointValue];

    if (a.x < b.x)
    {
        return NSOrderedAscending;
    }
    else
    if (a.x > b.x)
    {
        return NSOrderedDescending;
    }
    else
    if (a.y < b.y)
    {
        return NSOrderedAscending;
    }
    else
    if (a.y > b.y)
    {
        return NSOrderedDescending;
    }
    else
    {
        return NSOrderedSame;
    }
}

// ========================================================================= //

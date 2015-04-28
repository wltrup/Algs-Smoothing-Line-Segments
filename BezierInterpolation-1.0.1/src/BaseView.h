//
//  BaseView.h
//  BezierInterpolation
//
//  Created by Wagner Truppel on 5/15/09.
//  Copyright Wagner Truppel 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// ========================================================================= //
                           #pragma mark constants
// ========================================================================= //

#define NUM_POINTS                  5
#define POINT_SIZE                  8

// ========================================================================= //

void drawPoint(id pointAsValue);
void drawLine(id pointAsValueA, id pointAsValueB);

// ========================================================================= //

@interface BaseView: NSView
{
    @protected

        IBOutlet NSTextField* avgCurvatureTF;
                 NSArray*     points;
}

// ========================================================================= //
                            #pragma mark methods
// ========================================================================= //

- (void) dealloc;

// ========================================================================= //

- (void) processPoints: (NSArray*) pointsA;

// ========================================================================= //

@end

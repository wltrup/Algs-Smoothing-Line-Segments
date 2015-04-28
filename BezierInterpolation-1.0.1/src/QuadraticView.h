//
//  QuadraticView.h
//  BezierInterpolation
//
//  Created by Wagner Truppel on 5/15/09.
//  Copyright Wagner Truppel 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BaseView.h"

@interface QuadraticView: BaseView
{
    @private

        NSMutableArray* qPoints;
}

// ========================================================================= //
                            #pragma mark methods
// ========================================================================= //

- (void) dealloc;

// ========================================================================= //

- (void) drawRect: (NSRect) rect;

// ========================================================================= //

- (void) processPoints: (NSArray*) pointsA;

// ========================================================================= //

@end

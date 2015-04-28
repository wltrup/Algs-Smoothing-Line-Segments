//
//  AppController.h
//  BezierInterpolation
//
//  Created by Wagner Truppel on 5/15/09.
//  Copyright Wagner Truppel 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BaseView.h"

@interface AppController: NSObject
{
    @private

        IBOutlet BaseView* quadraticView;
        IBOutlet BaseView*     cubicView;
}

// ========================================================================= //
                            #pragma mark methods
// ========================================================================= //

- (void) awakeFromNib;

// ========================================================================= //

- (void) dealloc;

// ========================================================================= //
                          #pragma mark IB actions
// ========================================================================= //

- (IBAction) actionReSeed: (id) sender;

// ========================================================================= //

@end

//
//  KMScrollView.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 27/07/2014.
//  Copyright (c) 2014 Mammadov. All rights reserved.
//

#import "KMScrollView.h"
//#import "KMAppDelegate.h"
//#import "KMCommon.h"

@implementation KMScrollView {
    
    NSTrackingArea * trackingArea;
    
    
}


- (void)drawRect:(NSRect)dirtyRect {
    
    
    NSRect frame = [self bounds];
    
    //NSColor * satan = [[[KMCommon alloc] init] getColorfromHex: @"211f1f"];
        
    [[NSColor clearColor] setFill];
    //[satan setFill];
    
    NSRectFill(frame);
    
    [super drawRect:dirtyRect];
    
    
}


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTrackingArea];

    }
    
  
    return self;
}





- (void)mouseEntered:(NSEvent *)theEvent {
    
    [self setHasHorizontalScroller:YES];
    
    //We need it here due to a BUG with trackpad. Without this it wount work for the view
    //[self setScrollerStyle:NSScrollerStyleLegacy];
    [self setScrollerStyle:NSScrollerStyleOverlay];
    
}

- (void)mouseExited:(NSEvent *)theEvent {
    
    [self setHasHorizontalScroller:NO];
    
}





- (NSTrackingArea *) getTrackingAreaWithRect : (NSRect) trackingRect  sender: (NSDictionary*)  sender {
    
    return [[NSTrackingArea alloc] initWithRect: trackingRect
                                        options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow )
                                          owner:self userInfo:sender];
    
}

- (void) setTrackingArea {

    trackingArea = [self getTrackingAreaWithRect:[super bounds] sender:nil];
    [self addTrackingArea:trackingArea];
    
}

- (void) updateTrackingAreas {
    
    //Tracking window changes as well
    
    if (trackingArea) {

        //Remove first tracking area
        [self removeTrackingArea:trackingArea];
    
    }
        
    //Set again
    [self setTrackingArea];

}



@end

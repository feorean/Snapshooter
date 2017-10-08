//
//  KMSimpleNavigationView.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 23/03/2015.
//  Copyright (c) 2015 Mammadov. All rights reserved.
//

#import "KMSimpleNavigationView.h"
#import "KMAppDelegate.h"

@implementation KMSimpleNavigationView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                    options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow )
                                                      owner:self userInfo:nil];
        [self addTrackingArea:trackingArea];
    }
    
    

   
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect rect = [self bounds];
 /*
    //NSColor * satan = [[[KMCommon alloc] init] getColorfromHex: @"2a1111"];
    
    
    [[NSColor grayColor] setFill];
    //[[NSColor whiteColor] setFill];
    
    NSRectFill(frame);

    
    [super drawRect:dirtyRect];

    NSRect rect = NSMakeRect([self bounds].origin.x + 3, [self bounds].origin.y + 3, [self bounds].size.width - 6, [self bounds].size.height - 6);
    */
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5.0 yRadius:5.0];
    [path addClip];
    
    
    [[[NSColor grayColor] colorWithAlphaComponent:0.2] set];
    NSRectFill(rect);
    
    [super drawRect:dirtyRect];
    
}


- (void)mouseEntered:(NSEvent *)theEvent {
    

    
}

- (void)mouseExited:(NSEvent *)theEvent {
    

    
}

- (void)mouseDown:(NSEvent *)theEvent {

    KMAppDelegate * kmAppDeligate = (KMAppDelegate * ) [[NSApplication sharedApplication] delegate] ;
    
    if ([[self valueForKeyPath:@"name"] isEqual: @"Next"] ) {
        
        [kmAppDeligate selectNextElement];
        
    }
    
    if ([[self valueForKeyPath:@"name"] isEqual: @"Back"] ) {
        
        [kmAppDeligate selectBackElement];
        
    }

    
}



-(void)awakeFromNib{
 


}

@end

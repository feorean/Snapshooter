//
//  KMPopupUserMenu.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 29/12/2015.
//  Copyright © 2015 Mammadov. All rights reserved.
//

#import "KMPopupUserMenu.h"

@implementation KMPopupUserMenu

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

- (void)drawRect:(NSRect)dirtyRect {

    
    NSRect rect = [self bounds];

    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5.0 yRadius:5.0];
    [path addClip];
    
    
    
    [[[NSColor grayColor] colorWithAlphaComponent:0.2] set];
    NSRectFill(rect);
    
    [[NSColor whiteColor] set];
    [path stroke];
    
    
    [super drawRect:dirtyRect];
}

@end

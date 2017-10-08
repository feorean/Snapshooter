//
//  KMFilterPanelView.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 15/02/2016.
//  Copyright © 2016 Mammadov. All rights reserved.
//

#import "KMFilterPanelView.h"
#import "KMCommon.h"

@implementation KMFilterPanelView

- (void)drawRect:(NSRect)dirtyRect {
    
/*    NSRect rect = [self bounds];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5.0 yRadius:5.0];
    [path addClip];
    
    
    NSColor * satan = [[[KMCommon alloc] init] getColorfromHex: @"2a1111"];
    
    
    //[[NSColor blackColor] setFill];
    [satan setFill];
    //[[[NSColor grayColor] colorWithAlphaComponent:0.8] set];
    //NSRectFill(rect);
    
    [[NSColor whiteColor] set];
    [path stroke];
*/    
    
    [super drawRect:dirtyRect];
}

@end

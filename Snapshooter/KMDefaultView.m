//
//  KMDefaultView.m
//  Image Browser Test
//
//  Created by Khalid Mammadov on 25/07/2014.
//  Copyright (c) 2014 Mammadov. All rights reserved.
//

#import "KMDefaultView.h"
#import "KMCommon.h"

@implementation KMDefaultView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect frame = [self bounds];

    NSColor * satan = [[[KMCommon alloc] init] getColorfromHex: @"2a1111"];
    
/*    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:5.0 yRadius:5.0];
    
    
    [[NSColor yellowColor] set];
    [path stroke];*/
    
    
    //[[NSColor blackColor] setFill];
    [satan setFill];
    
    NSRectFill(frame);    //  [self setCompositingOperation:NSCompositeDestinationAtop];
    
    
    [super drawRect:dirtyRect];
}






@end

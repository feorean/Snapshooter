//
//  KMScrollerView.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 27/07/2014.
//  Copyright (c) 2014 Mammadov. All rights reserved.
//

#import "KMScrollerView.h"
#import "KMCommon.h"

@implementation KMScrollerView

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
    
    NSColor * satan = [[[KMCommon alloc] init] getColorfromHex: @"211f1f"];
    
    
    //[[NSColor clearColor] setFill];
    [satan setFill];
    
    NSRectFill(frame);    //  [self setCompositingOperation:NSCompositeDestinationAtop];
    
    
    [super drawRect:dirtyRect];
    
    //NSLog(@"Scroller view draw called");
    
    
    // Drawing code here.
}

@end

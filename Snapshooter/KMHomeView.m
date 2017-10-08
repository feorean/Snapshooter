//
//  KMHomeView.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 06/02/2016.
//  Copyright © 2016 Mammadov. All rights reserved.
//

#import "KMHomeView.h"
#import "KMCommon.h"

@implementation KMHomeView

- (void)drawRect:(NSRect)dirtyRect {
    NSRect frame = [self bounds];
    
    
    //[[NSColor blackColor] setFill];
    
    NSColor * satan = [[[KMCommon alloc] init] getColorfromHex: @"211f1f"];
    
    
    //[[NSColor clearColor] setFill];
    [satan setFill];
    
    NSRectFill(frame);
    
    
    [super drawRect:dirtyRect];
}

@end

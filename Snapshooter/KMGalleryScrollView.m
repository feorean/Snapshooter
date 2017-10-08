//
//  KMGalleryScrollView.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 06/02/2016.
//  Copyright © 2016 Mammadov. All rights reserved.
//

#import "KMGalleryScrollView.h"
#import "KMCommon.h"

@implementation KMGalleryScrollView

- (void)drawRect:(NSRect)dirtyRect {

    
    NSRect frame = [self bounds];
    
    //NSColor * satan = [[[KMCommon alloc] init] getColorfromHex: @"211f1f"];
    
    
    
    [[NSColor clearColor] setFill];
    //[satan setFill];
    
    NSRectFill(frame);    //  [self setCompositingOperation:NSCompositeDestinationAtop];
    
    
    [super drawRect:dirtyRect];
    
}

@end

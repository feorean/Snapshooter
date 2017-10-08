//
//  KMRoundedCornerPanel.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 30/03/2015.
//  Copyright (c) 2015 Mammadov. All rights reserved.
//

#import "KMRoundedCornerPanel.h"

@implementation KMRoundedCornerPanel


- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag];
    
    if ( self )
    {
        [self setStyleMask:NSBorderlessWindowMask];
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
    }
    
    return self;
}

@end

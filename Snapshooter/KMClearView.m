//
//  KMClearView.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 05/03/2016.
//  Copyright © 2016 Mammadov. All rights reserved.
//

#import "KMClearView.h"

@implementation KMClearView

- (void)drawRect:(NSRect)dirtyRect {
    
    NSRect frame = [self bounds];
    
    [[NSColor clearColor] setFill];
    
    NSRectFill(frame);
    
    self.layer.backgroundColor = [NSColor clearColor].CGColor;
    
    [super drawRect:dirtyRect];
}

@end

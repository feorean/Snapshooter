//
//  KMImageView.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 26/07/2014.
//  Copyright (c) 2014 Mammadov. All rights reserved.
//

#import "KMImageView.h"
#import "KMAppDelegate.h"



@implementation KMImageView {
    
    NSPoint mouseDownPoint;
}

@synthesize delegate;



- (void)drawRect:(NSRect)dirtyRect
{
    
    [super drawRect:dirtyRect];

}


- (void) scrollWheel:(NSEvent *)theEvent {
    
    if ([theEvent deltaY] > 0 ) { //Down
        
        [delegate selectBackElement];
        
    } else { //Up

        [delegate selectNextElement];
        
    };
}


- (void)mouseDragged:(NSEvent *)theEvent {
    
    NSWindow * wdw = [self window];
    NSPoint mousePosInView= [wdw.contentView convertPoint:wdw.mouseLocationOutsideOfEventStream toView:self];
    

    [delegate imageViewMouseMovedFrom:mouseDownPoint to:mousePosInView];
    
    //NSLog(@"Dragging... pos x=%fl y=%f", mousePosInView.x, mousePosInView.y);
    
    mouseDownPoint = mousePosInView;
}

- (void)mouseDown:(NSEvent *)theEvent {
    
    NSWindow * wdw = [self window];
    NSPoint mousePosInView= [wdw.contentView convertPoint:wdw.mouseLocationOutsideOfEventStream toView:self];
    
    //initial value
    mouseDownPoint = mousePosInView;
    
    //NSLog(@"Mouse down... pos x=%fl y=%f", mousePosInView.x, mousePosInView.y);
}

- (void)mouseUp:(NSEvent *)theEvent {
    
    [delegate imageViewMouseClickUp];
}

@end

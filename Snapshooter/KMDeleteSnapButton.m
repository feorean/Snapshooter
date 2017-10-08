//
//  KMDeleteSnapButton.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 30/12/2015.
//  Copyright © 2015 Mammadov. All rights reserved.
//

#import "KMDeleteSnapButton.h"
#import "KMAppDelegate.h"

@implementation KMDeleteSnapButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


- (void)mouseDown:(NSEvent *)theEvent {
    
    KMAppDelegate * kmAppDeligate = (KMAppDelegate * ) [[NSApplication sharedApplication] delegate] ;

    [kmAppDeligate deleteSelectedImages:nil];
    
}


@end

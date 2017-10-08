//
//  KMSaveAsButton.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 30/12/2015.
//  Copyright © 2015 Mammadov. All rights reserved.
//

#import "KMSaveAsButton.h"
#import "KMAppDelegate.h"

@implementation KMSaveAsButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


- (void)mouseDown:(NSEvent *)theEvent {
    
    KMAppDelegate * kmAppDeligate = (KMAppDelegate * ) [[NSApplication sharedApplication] delegate] ;
    
    
    [kmAppDeligate saveImageOnDisk:nil];
    
    
    
}


@end

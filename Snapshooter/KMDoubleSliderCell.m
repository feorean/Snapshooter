//
//  KMDoubleSliderCell.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 05/08/2014.
//  Copyright (c) 2014 Mammadov. All rights reserved.
//

#import "KMDoubleSliderCell.h"
#import "KMDoubleSlider.h"
#import "KMAppDelegate.h"


@implementation KMDoubleSliderCell

- (void)mouseUp:(NSEvent *)anEvent
{
    NSLog(@"cool");
}



/*
 - (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)untilMouseUp {
 
 BOOL	result;
 
 result = [ super trackMouse:theEvent inRect:cellFrame ofView:controlView untilMouseUp:untilMouseUp ];
 
 
 NSLog(@"Bingo");
 
 return result;
 }*/


/*
+ (BOOL)prefersTrackingUntilMouseUp {
    
    BOOL	result;
    
    result = [ super prefersTrackingUntilMouseUp ];
    
    NSLog(@"Bingo2");
    
    return result;
}
*/

- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView {
    
  //  NSLog(@"startTrackingAt");
    
    
    
    return [ super startTrackingAt:startPoint inView:controlView ];
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag {
    
    [super stopTracking:lastPoint at:stopPoint inView:controlView mouseIsUp:flag];
    
    KMAppDelegate * kmAppDeligate = (KMAppDelegate * ) [[NSApplication sharedApplication] delegate] ;
    
    
    //Set Model Lo and Hi values for later use
    [kmAppDeligate setDoubleSliderHiValue:[NSNumber numberWithInteger:[super intHiValue]]];
    [kmAppDeligate setDoubleSliderLoValue:[NSNumber numberWithInteger:[super intLoValue]]];
    
    

    // [kmAppDeligate changeGlobalFromToDates:loVal hiValue:hiVal];
    [kmAppDeligate reloadImageBrowser];
    
     
    [kmAppDeligate.panelShowTime orderOut:self];
    
    
}

- (BOOL)continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)controlView {
    
    BOOL result = [super continueTracking:lastPoint at:currentPoint inView:controlView];
    

    
    return result;
    
}


@end

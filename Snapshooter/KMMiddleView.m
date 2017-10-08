//
//  KMMiddleView.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 02/08/2014.
//  Copyright (c) 2014 Mammadov. All rights reserved.
//

#import "KMMiddleView.h"
#import "KMCommon.h"
#import "KMAppDelegate.h"

@implementation KMMiddleView

- (id)initWithFrame:(NSRect)frame
{

    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTrackingAreas];
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect frame = [self bounds];
    
    NSColor * satan = [[[KMCommon alloc] init] getColorfromHex: @"211f1f"];
        
    //[[NSColor grayColor] setFill];
    [satan setFill];
    
    NSRectFill(frame);    //  [self setCompositingOperation:NSCompositeDestinationAtop];
    
    
    [super drawRect:dirtyRect];
}

- (NSTrackingArea *) getTrackingAreaWithRect : (NSRect) trackingRect  sender: (NSDictionary*)  sender {
 
    return [[NSTrackingArea alloc] initWithRect: trackingRect
                                        options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow )
                                          owner:self userInfo:sender];
    
}

- (void) setTrackingAreas {
    
    NSRect  trackingRect;
    NSDictionary * senderInfo = @{ @"Sender"     : @"Right"};
    
    //Get right tracking area
    trackingRect = [self bounds];
    trackingRect.size.width = trackingRect.size.width/8;
    trackingRect.size.height = trackingRect.size.height*.6;// 80%  trackingRect.size.height-30;//Minus Top bar
    trackingRect.origin.x = trackingRect.size.width * 7;
    trackingRect.origin.y = [self bounds].size.height/5; //Move down for top bar
    
    //Add right tracking area to the view
    rightTrackingArea = [self getTrackingAreaWithRect:trackingRect sender: senderInfo];
    [self addTrackingArea:rightTrackingArea];
    
    //Get left tracking area
    trackingRect.origin.x = 0;
    
    senderInfo = @{ @"Sender"     : @"Left"};
    
    //Add left tracking area to the view
    leftTrackingArea = [self getTrackingAreaWithRect:trackingRect sender:senderInfo];
    [self addTrackingArea:leftTrackingArea];
    

}

- (void) updateTrackingAreas {
    
    //Tracking window changes as well
    
    //Remove first all tracking areas
    [self removeTrackingArea:leftTrackingArea];
    [self removeTrackingArea:rightTrackingArea];
    
    //Set again
    [self setTrackingAreas];
    
}


-(void) showNavigationView : (NSString * ) sender {
    
    KMAppDelegate * kmAppDeligate = (KMAppDelegate * ) [[NSApplication sharedApplication] delegate] ;
  
    if ( [sender  isEqual: @"Left"] ) {
        
        [kmAppDeligate addLeftView];
        
    }
    
    if ([sender isEqual: @"Right"] )  {
    
        [kmAppDeligate addRightView];
        
    }
    
}

-(void) hideNavigationView : (NSString * ) sender {
    
    KMAppDelegate * kmAppDeligate = (KMAppDelegate * ) [[NSApplication sharedApplication] delegate] ;
    
    if ( [sender  isEqual: @"Left"] ) {
        
        [kmAppDeligate removeLeftView];
        
    }
    
    if ([sender isEqual: @"Right"] )  {
        
        [kmAppDeligate removeRightView];
        
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {

    NSString * sender = [[[theEvent trackingArea] userInfo] objectForKey:@"Sender"];

    
    [self showNavigationView:sender];
    
}

- (void)mouseExited:(NSEvent *)theEvent {

    NSString * sender = [[[theEvent trackingArea] userInfo] objectForKey:@"Sender"];

    [self hideNavigationView:sender];
    
}
@end

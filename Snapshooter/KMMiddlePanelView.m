//
//  KMMiddlePanelView.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 19/02/2016.
//  Copyright © 2016 Mammadov. All rights reserved.
//

#import "KMMiddlePanelView.h"
#import "KMCommon.h"
#import "KMAppDelegate.h"

@implementation KMMiddlePanelView

- (id)initWithFrame:(NSRect)frame
{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        [self setTrackingAreas];
        
    }
    
    return self;
}

- (NSTrackingArea *) getTrackingAreaWithRect : (NSRect) trackingRect  sender: (NSDictionary*)  sender {
    
    return [[NSTrackingArea alloc] initWithRect: trackingRect
                                        options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow )
                                          owner:self userInfo:sender];
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


- (void) setTrackingAreas {
    
    KMAppDelegate * kmAppDeligate = (KMAppDelegate * ) [[NSApplication sharedApplication] delegate] ;
    
    NSRect  trackingRect;
    NSDictionary * senderInfo = @{ @"Sender"     : @"FilterMenu"};
  
    //Add for Filter menu
    //trackingRect = [self bounds];
    //trackingRect.size.width = trackingRect.size.width;
    trackingRect = [kmAppDeligate mFilterPanelView].frame;
    trackingRect.origin.x = 0;
    trackingRect.origin.y = [self bounds].size.height - trackingRect.size.height;
    popupUserMenu = [self getTrackingAreaWithRect:trackingRect sender:senderInfo];
    [self addTrackingArea:popupUserMenu];
    
    
    //Add bottom image view area
    senderInfo = @{ @"Sender"     : @"BottomList"};
    
    //Add for bottom image browser
    trackingRect = [self bounds];
    trackingRect.size.height = trackingRect.size.height/8;
    trackingRect.origin.y = 0;
    bottomListView = [self getTrackingAreaWithRect:trackingRect sender:senderInfo];
    [self addTrackingArea:bottomListView];
    
    //Add bottom image view area
    senderInfo = @{ @"Sender"     : @"GalleryList"};
    
    //Add for gallery image browser
    trackingRect = [kmAppDeligate.mGalleryView frame];
    //trackingRect.size.height = trackingRect.size.height/8;
    //trackingRect.origin.y = 0;
    galleryListView = [self getTrackingAreaWithRect:trackingRect sender:senderInfo];
    //[self addTrackingArea:galleryListView];
    

}

- (void) updateTrackingAreas {
    
    //Remove first all tracking areas
    [self removeTrackingArea:popupUserMenu];
    [self removeTrackingArea:bottomListView];
    //[self removeTrackingArea:galleryListView];
    
    //Set again
    [self setTrackingAreas];
    
}


-(void) showNavigationView : (NSString * ) sender {
    
    KMAppDelegate * kmAppDeligate = (KMAppDelegate * ) [[NSApplication sharedApplication] delegate] ;
    
    if ([sender isEqual: @"FilterMenu"] )  {
        
        //[kmAppDeligate addPopupUserMenuView];
        [kmAppDeligate showAvailabLePanels];
        
    }
    
    if ([sender isEqual: @"BottomList"] )  {
        
        //[kmAppDeligate showBottomScrollView];
        [kmAppDeligate showAvailabLePanels];
        
    }
    
    if ([sender isEqual: @"GalleryList"] )  {
        
        //[kmAppDeligate showBottomScrollView];
        [kmAppDeligate showAvailabLePanels];
        
    }
    
}

-(void) hideNavigationView : (NSString * ) sender {
    
    KMAppDelegate * kmAppDeligate = (KMAppDelegate * ) [[NSApplication sharedApplication] delegate] ;
    
    if ([sender isEqual: @"FilterMenu"] )  {
        
        //[kmAppDeligate removePopupUserMenuView];
        [kmAppDeligate hideAvailablePanels];
    }
    
    if ([sender isEqual: @"BottomList"] )  {
        
        [kmAppDeligate hideAvailablePanels];
        //[kmAppDeligate hideAvailablePanels];
        
    }
    
    if ([sender isEqual: @"GalleryList"] )  {
        
        //[kmAppDeligate showBottomScrollView];
        [kmAppDeligate hideAvailablePanels];
        
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

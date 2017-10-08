//
//  KMSimpleNavigationView.h
//  Snapshooter
//
//  Created by Khalid Mammadov on 23/03/2015.
//  Copyright (c) 2015 Mammadov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KMSimpleNavigationView : NSView {
    
    NSColor * backgrounColor;
    NSTrackingArea * trackingArea;
    
}


@property (strong) NSString * name;

@end

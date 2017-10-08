//
//  KMRoundedCornerView.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 30/03/2015.
//  Copyright (c) 2015 Mammadov. All rights reserved.
//

#import "KMRoundedCornerView.h"
#import "KMCommon.h"

@implementation KMRoundedCornerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    
    NSBezierPath* thePath = [NSBezierPath bezierPath];
    NSRect rect = [self frame];

    NSColor * satan = [[[KMCommon alloc] init] getColorfromHex: @"211f1f"];
    
    satan = [satan colorWithAlphaComponent:0.7];
    
    //[[NSColor grayColor] setFill];

    
    [thePath appendBezierPathWithRoundedRect:rect xRadius:15 yRadius:15];
    [thePath addClip];
    [satan set];
    NSRectFill(rect);
    
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end

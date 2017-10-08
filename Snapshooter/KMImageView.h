//
//  KMImageView.h
//  Snapshooter
//
//  Created by Khalid Mammadov on 26/07/2014.
//  Copyright (c) 2014 Mammadov. All rights reserved.
//

#import <Quartz/Quartz.h>
#import <Cocoa/Cocoa.h>

@interface KMImageView : NSView 

- (id) delegate;
- (void) setDelegate: (id) newDelegate;

@property id delegate;



@end

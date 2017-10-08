//
//  KMDoubleSlider.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 05/08/2014.
//  Copyright (c) 2014 Mammadov. All rights reserved.
//


#import "KMDoubleSlider.h"
#import "KMAppDelegate.h"
#import "KMCommon.h"

@implementation KMDoubleSlider

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
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    //NSLog(@"cool");
}

/*
- (void)updateBoundControllerHiValue:(double)val
{
    double inval = val;
    
    [super updateBoundControllerHiValue:inval];
    
    [self afterHiChanged:[NSNumber numberWithDouble:inval]];
    
}

// For Snapshooter
- (void) afterHiChanged: (NSNumber *) val {
    
      NSLog(@"After high changed: %@", val);
    
}
 
*/

- (void)updateBoundControllerLoOrHi:(NSString*)loOrHi value: (double)val {

    KMAppDelegate * kmAppDeligate = (KMAppDelegate * ) [[NSApplication sharedApplication] delegate] ;
    
    NSDate *fromDate;
    NSDate *toDate;
    NSDate *setDate;
    NSNumber * hiValue = [NSNumber numberWithInteger:val];
    NSNumber * loValue = [NSNumber numberWithInteger:val];
    
    
    KMDateTimeFormatters *dateTimeFormatters = [[KMDateTimeFormatters alloc] init];

    
    [kmAppDeligate calculateDatesFromLoHi: loValue hivalue:hiValue fromdate:&fromDate todate:&toDate];
    
    //Set date depending of caller
    setDate = [loOrHi compare:@"Hi"] ? toDate : fromDate;

    [kmAppDeligate.labelPanelDate setStringValue:[[dateTimeFormatters getDateFormatter] stringFromDate:setDate ] ];
    [kmAppDeligate.labelPanelTime setStringValue:[[dateTimeFormatters getTimeFormatter] stringFromDate:setDate ] ];
    
    [kmAppDeligate.panelShowTime makeKeyAndOrderFront:self];
}

- (void)updateBoundControllerLoValue:(double)val {
    
    [self updateBoundControllerLoOrHi:@"Lo" value:val];
    
}

- (void)updateBoundControllerHiValue:(double)val {
    
    [self updateBoundControllerLoOrHi:@"Hi" value:val];
    
}


@end

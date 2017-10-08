//
//  KMDatePickerCell.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 11/08/2014.
//  Copyright (c) 2014 Mammadov. All rights reserved.
//

#import "KMDatePickerCell.h"

@implementation KMDatePickerCell


- (NSColor *)backgroundColor {
    
    NSDateFormatter *sourceDateFormatter = [[NSDateFormatter alloc] init];
    [sourceDateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSColor * bcolor = [NSColor greenColor];

    
    //NSLog(@"date: %@", [self dateValue]);
    
    return bcolor;
}

- (BOOL)drawsBackground {
    
//    NSLog(@"date: %@", [self dateValue]);
    
    
    return [super drawsBackground];
}


- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    //NSLog(@"aaa");
    
    
    [super drawWithFrame:cellFrame inView:controlView];
    
 //   NSLog(@"ok %@", [self stringValue]);

    
    
}


- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    return [NSColor blackColor];
    
}


- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    
    [super highlight:flag withFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{

    
}


- (void)drawCellInside:(NSCell *)aCell {
    
}


- (void)datePickerCell:(NSDatePickerCell *)aDatePickerCell validateProposedDateValue:(NSDate **)proposedDateValue timeInterval:(NSTimeInterval *)proposedTimeInterval {
    
}


-(BOOL) startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView {

    NSView * v  = [[NSView alloc] initWithFrame:[controlView frame]];
    
    NSColor *backgroundColor = [NSColor blackColor];
    [backgroundColor setFill];
    
    NSRect rc = [v bounds];
    
    NSRectFill(rc);
    
    
    [v setBounds:rc];
    
    return  [super startTrackingAt:startPoint inView:controlView];
}


-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    return self;
    
}


-(id) initImageCell:(NSImage *)image {
    
    
    
    return nil;// [NSImage imageNamed:@"stop"];
}


-(id) initTextCell:(NSString *)aString {
    
   self =  [super initTextCell:@"calambur"];
    
    
    return self;
}

@end

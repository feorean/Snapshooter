//
//  KMGraphDoubleSlider.m
//  GraphSlider
//
//  Created by Khalid Mammadov on 01/04/2015.
//  Copyright (c) 2015 Mammadov. All rights reserved.
//

#import "KMGraphDoubleSlider.h"
#import "KMAppDelegate.h"



@implementation KMGraphDoubleSlider{
    
    //id delegate;
   
}

@synthesize graphArray     = _graphArray;
@synthesize leftKnobValue  = _leftKnobValue;
@synthesize rightKnobValue = _rightKnobValue;

@synthesize backgroundColor = _backgroundColor;
@synthesize graphColor      = _graphColor;
@synthesize lineColor       = _lineColor;

@synthesize delegate;



- (id) delegate {
    return delegate;
}

- (void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        leftKnob = [CALayer layer];
        
        leftKnob.bounds = (CGRect){(CGPoint){ .x = 0, .y = 0 }, (CGSize){ .width = 15, .height = 20 }};
        knobWidth = leftKnob.bounds.size.width;
        halfKnob = (NSUInteger)knobWidth/2;
        leftKnob.contents = [NSImage imageNamed:@"Left_knob"];
        
        leftKnob.shadowOpacity = 0.5;
        leftKnob.shadowOffset = (NSSize){ .width =  5, .height = -7};
        
        
        rightKnob = [CALayer layer];
        rightKnob.bounds = (CGRect){(CGPoint){ .x = 0, .y = 0 }, (CGSize){ .width = 15, .height = 20 }};
        rightKnob.contents = [NSImage imageNamed:@"Right_knob"];
        
        rightKnob.shadowOpacity = 0.5;
        rightKnob.shadowOffset = (NSSize){ .width =  5, .height = -7};
        
        [self resetKnobsPositions];
        
        [self setWantsLayer:YES];
        
        [[self layer] addSublayer:leftKnob];
        
        [[self layer] addSublayer:rightKnob];
        
        
        //[[self layer] setBackgroundColor:CGColorRetain([NSColor colorWithCalibratedRed:255 green:255 blue:255 alpha:1].CGColor)];
        [self layer].backgroundColor = [self backgroundColor].CGColor;
        [self setLineColor:[NSColor grayColor]];
        [self setGraphColor:[NSColor blackColor]];
        
        
    }
    return self;
}

- (void) resetKnobsPositions {
    
    leftKnob.position = (CGPoint){ .x = knobWidth, .y = ([self bounds].size.height/4)*3 };
    rightKnob.position = (CGPoint){ .x = [self bounds].size.width-knobWidth, .y = [self bounds].size.height/4};
    
}

-(BOOL) mouseDownCanMoveWindow {
    
    return NO;
    
}


- (NSNumber * ) getXdevider : (NSMutableArray * ) rangeArray{
    
    if (rangeArray.count == 0) {
        
        return nil;
        
    }
    
    
    NSPoint maxXvalue = [(NSValue *)rangeArray[[rangeArray count]-1] pointValue];
    
    
    //Devider can not be null! (zero devision error), so lets fix it
    if (maxXvalue.x == 0) {
        
        maxXvalue.x = 1;
        
    }
    
    return [NSNumber numberWithDouble:(maxXvalue.x/(self.bounds.size.width-knobWidth*2))];
    
}


- (NSNumber * ) getYdevider : (NSMutableArray * ) rangeArray{
    
    if (rangeArray.count == 0) {
        
        return nil;
        
    }
    
    NSNumber * maxYvalue = [self getAvgYvalueFrom:rangeArray];
    
    //Devider can not be null! (zero devision error), so lets fix it
    if ([maxYvalue isEqualToNumber:[NSNumber numberWithDouble:0.0]]) {
        
        maxYvalue = [NSNumber numberWithDouble:1.0];
        
    }
    
    return [NSNumber numberWithDouble:(maxYvalue.integerValue/self.bounds.size.height)*8];
    
}

- (NSUInteger ) convertXpointToNumber : (NSUInteger )pointX : (NSMutableArray * ) rangeArray {
    
    if (rangeArray.count == 0) {
        
        return 0;
        
    }
    
    
    NSNumber * multiplierX = [self getXdevider:rangeArray];
    
    return ((pointX-knobWidth) * [multiplierX doubleValue]);
    
}

- (void) drawGraph {
    
    graphPath = [NSBezierPath bezierPath];
    
    
    [graphPath setLineWidth:1.];
    
    
    for (id point in _graphArrayConverted) {
        
        //Move to point
        NSPoint tempPoint = [(NSValue *)point pointValue];
        tempPoint.y = //[self bounds].size.height/2-tempPoint.y/2;
        [self bounds].size.height/2;
        [graphPath moveToPoint:tempPoint];
        
        //Line to point
        //Reset
        tempPoint = [(NSValue *)point pointValue];
        
        tempPoint.y = //[self bounds].size.height/2+tempPoint.y/2;
        [self bounds].size.height/2+tempPoint.y;
        [graphPath lineToPoint:tempPoint];
        
        [graphPath stroke];
        
    }
    
}


- (void)drawRect:(NSRect)dirtyRect
{
    
    [super drawRect:dirtyRect];
    

    //Draw nice central line
    cetralLine = [NSBezierPath bezierPath];
    
    [cetralLine setLineWidth:2.0];
    [[NSColor blackColor] set];
    //Draw black colour first
    [cetralLine moveToPoint:NSMakePoint(knobWidth, [self bounds].size.height/2)];
    [cetralLine lineToPoint:NSMakePoint([self bounds].size.width-knobWidth, [self bounds].size.height/2)];
    [cetralLine stroke];
    
    [cetralLine setLineWidth:1.0];
    [[self lineColor] set];
    //Draw grey overlay colour then
    [cetralLine moveToPoint:NSMakePoint(knobWidth, [self bounds].size.height/2)];
    [cetralLine lineToPoint:NSMakePoint([self bounds].size.width-knobWidth, [self bounds].size.height/2)];
    [cetralLine stroke];
    
    
    [[self graphColor] set];
    //Draw The graph
    [self drawGraph];
    
    
}


- (void)mouseDragged:(NSEvent *)theEvent {
    
     NSWindow * wdw = [self window];
     //NSLog(@"Mouse position in view:%@", NSStringFromPoint([wdw mouseLocationOutsideOfEventStream]));
    
     NSPoint mousePosInView= [wdw.contentView convertPoint:wdw.mouseLocationOutsideOfEventStream
                                                   toView:self];
    
     //NSLog(@"Dragging... pos x=%fl y=%f", mousePosInView.x, mousePosInView.y);
    
    
    
    
    //Magnet
    if (currentKnob == NSRightKnob
        && ((mousePosInView.x > self.bounds.size.width-halfKnob)
            || (mousePosInView.x > self.bounds.size.width-halfKnob - 2  ))){
            
            mousePosInView.x = self.bounds.size.width-knobWidth;
            
        }
    
    
    if ( mousePosInView.x > leftKnob.position.x + halfKnob/4 //Check if close to the other Knob
        & mousePosInView.x + halfKnob <= self.bounds.size.width-halfKnob //Check if close to the border
        & currentKnob == NSRightKnob) {
        
        
        rightKnob.position = (CGPoint){ .x = mousePosInView.x, .y = [self bounds].size.height/4};
        
        //Now change the value and send a message
        _rightKnobValue = [NSNumber numberWithInteger:[self convertXpointToNumber:rightKnob.position.x :_graphArray]];
        [self rightKnobDragged:theEvent];
        
    }
    
    if ( mousePosInView.x < rightKnob.position.x - halfKnob/4
        & mousePosInView.x - halfKnob >= halfKnob
        & currentKnob == NSLeftKnob) {
        
        
        leftKnob.position = (CGPoint){ .x = mousePosInView.x, .y = [self bounds].size.height*3/4};
        
        //Now change the value and send a message
        _leftKnobValue = [NSNumber numberWithInteger:[self convertXpointToNumber:leftKnob.position.x :_graphArray]];
        [self leftKnobDragged:theEvent];
    }
    
    
}

- (void)mouseDown:(NSEvent *)theEvent {
    
    //NSLog(@"Mouse down!");
 
    NSWindow * wdw = [self window];
    //NSLog(@"Mouse position in view:%@", NSStringFromPoint([wdw mouseLocationOutsideOfEventStream]));
    
    NSPoint mousePosInView= [wdw.contentView convertPoint:wdw.mouseLocationOutsideOfEventStream
                                                   toView:self];
    
    //Find which Knob is currently selected
    if ( mousePosInView.x >= rightKnob.position.x - halfKnob-5
        & mousePosInView.x <= rightKnob.position.x + halfKnob+5
        & mousePosInView.y < self.bounds.size.height/2 //Bottom
        ) {
        
        currentKnob = NSRightKnob;
        
        
    } else if ( mousePosInView.x >= leftKnob.position.x - halfKnob-5
               & mousePosInView.x <= leftKnob.position.x + halfKnob+5
               & mousePosInView.y >= self.bounds.size.height/2) {//Top
        
        currentKnob = NSLeftKnob;
        
    } else {
        
        currentKnob = NSNothing;
        
         //Bottom
         if (mousePosInView.x > knobWidth
         & mousePosInView.x < self.bounds.size.width - knobWidth
         & mousePosInView.y < self.bounds.size.height/2) {
         
         clickedSide = NSBottomSide;
         
         } else if (mousePosInView.x > knobWidth
         & mousePosInView.x < self.bounds.size.width - knobWidth
         & mousePosInView.y >= self.bounds.size.height/2) {
         
         clickedSide = NSTopSide;
         
         } else {
         
         clickedSide = NSIncorrectArea;
         
         }
         
         
        
    }
    
}


//---Set up delegate methods
- (void) leftKnobMoved:(NSEvent *)theEvent {
    
    if ( [delegate respondsToSelector:@selector(leftKnobMoved:)] ) {
        
        //Call the method on delegate
        [delegate performSelector:@selector(leftKnobMoved:) withObject:theEvent ];
    }
}

- (void) rightKnobMoved:(NSEvent *)theEvent {
    
    if ( [delegate respondsToSelector:@selector(rightKnobMoved:)] ) {
        
        //Call the method on delegate
        [delegate performSelector:@selector(rightKnobMoved:) withObject:theEvent ];
        
    }
}
- (void) leftKnobDragged:(NSEvent *)theEvent {
    
    if ( [delegate respondsToSelector:@selector(leftKnobDragged:)] ) {
        
        //Call the method on delegate
        [delegate performSelector:@selector(leftKnobDragged:) withObject:theEvent ];
        
    }
}

- (void) rightKnobDragged:(NSEvent *)theEvent {
    
    if ( [delegate respondsToSelector:@selector(rightKnobDragged:)] ) {
        
        //Call the method on delegate
        [delegate performSelector:@selector(rightKnobDragged:) withObject:theEvent ];
        
    }
}

//---End delegate






- (void) mouseUp:(NSEvent *)theEvent {
    
    
    switch (currentKnob) {
        case NSRightKnob:
            [self rightKnobMoved:theEvent];
            break;
        case NSLeftKnob:
            [self leftKnobMoved:theEvent];
            break;
        default:
            
            
             switch (clickedSide) {
             
             case NSTopSide:
             currentKnob = NSLeftKnob;
             [self mouseDragged:theEvent];
             [self leftKnobMoved:theEvent];
             break;
             
             case NSBottomSide:
             currentKnob = NSRightKnob;
             [self mouseDragged:theEvent];
             [self rightKnobMoved:theEvent];
             break;
             
             default:
             //Nothing selected. Click in rundom place
             break;
             }
            
            break;
    }
    
    
    
    
}


-(NSPoint) getMaxYvalueFrom: (NSArray * ) arrayOfPoints {
    
    if (arrayOfPoints.count == 0) {
        
        return NSMakePoint(0, 0);
        
    }
    
    NSPoint tempPoint = [(NSValue *)arrayOfPoints[0] pointValue];
    
    for (int i=1; i<[arrayOfPoints count]; i++) {
        
        //Get point from the array
        
        if (tempPoint.y < [(NSValue *)arrayOfPoints[i] pointValue].y) {
            
            tempPoint = [(NSValue *)arrayOfPoints[i] pointValue];
            
        }
        
    }
    
    return tempPoint;
    
}

-(NSNumber * ) getAvgYvalueFrom: (NSArray * ) arrayOfPoints {
    
    NSNumber * avgY = [[NSNumber alloc] initWithInt:0];
    
    for (int i=1; i<[arrayOfPoints count]; i++) {
        
        avgY = [[NSNumber alloc] initWithInt:[avgY integerValue]+[(NSValue *)arrayOfPoints[i] pointValue].y];
        
    }
    
    return [NSNumber numberWithInteger:avgY.doubleValue/arrayOfPoints.count];
    
}


- (NSMutableArray *) convertInputNumbersToPoints: (NSMutableArray * ) inputArray {
    
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:inputArray copyItems:YES];
    
    
    if ( array.count > 0 ) {
        
        //Get X,Y deviders
        NSNumber * deviderX = [self getXdevider:array];
        NSNumber * deviderY = [self getYdevider:array];
        
        //Add 50% to decrease Y values when devided
        deviderY = [NSNumber numberWithDouble:deviderY.doubleValue*1.5];
        
        for (int i=0; i<[array count]; i++) {
            
            //Get point from the array
            NSPoint tempPoint = [(NSValue *)array[i] pointValue];
            
            tempPoint.x = tempPoint.x / [deviderX doubleValue] + knobWidth;
            tempPoint.y = tempPoint.y / [deviderY doubleValue];
            //Set adjusted object
            [array replaceObjectAtIndex:i withObject:[NSValue valueWithPoint:tempPoint]];
            
            
        }
        
    }
    
    return array;
    
}

//Setters
- (void) setGraphArray : (NSMutableArray * ) pointArray {
 
    if (!pointArray) {
        
        return;
        
    }
    
    
    //Save the original values
    _graphArray = [[NSMutableArray alloc] initWithArray:pointArray copyItems:YES ];
    
    //Convert to internal format
    _graphArrayConverted = [self convertInputNumbersToPoints:pointArray];
    
    [self resetKnobsPositions];
    
    [self setNeedsDisplay:YES];
    
}



- (NSNumber *) leftKnobValue {
    
    return _leftKnobValue;
    
}


- (NSNumber *) rightKnobValue {
    
    return _rightKnobValue;
    
}


- (NSArray * ) graphArray {
    
    return _graphArray;
    
}

-(void) setBackgroundColor: (NSColor *) color {
    
    _backgroundColor = color;
    
}

-(NSColor *) backgroundColor {
    
    return _backgroundColor;
    
}

-(void) setLineColor: (NSColor *) color {
    
    _lineColor = color;
    
}

-(NSColor *) lineColor {
    
    return _lineColor;
    
}

-(void) setGraphColor: (NSColor *) color {
    
    _graphColor = color;
    
}

-(NSColor *) graphColor {
    
    return _graphColor;
    
}


-(void) viewDidEndLiveResize {
    
    [self setGraphArray:[self graphArray]];
    
    
}



@end

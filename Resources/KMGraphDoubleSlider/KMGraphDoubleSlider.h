//
//  KMGraphDoubleSlider.h
//  GraphSlider
//
//  Created by Khalid Mammadov on 01/04/2015.
//  Copyright (c) 2015 Mammadov. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef NSInteger NSCurrentSelecedKnob;
enum {
    
    NSNothing         = -1,
    NSLeftKnob        =  0,
    NSRightKnob        =  1

};

typedef NSInteger NSClickedArea;
enum {
    
    NSIncorrectArea         = -1,
    NSTopSide               =  0,
    NSBottomSide            =  1
    
};

//This protocol is to be able to create Events and send them to main "m" file (Deligate object)
@protocol DobleSliderKnobEvents <NSObject>
@optional
- (void) leftKnobMoved:(NSEvent *)theEvent;
- (void) rightKnobMoved:(NSEvent *)theEvent;
- (void) leftKnobDragged:(NSEvent *)theEvent;
- (void) rightKnobDragged:(NSEvent *)theEvent;
@end


@interface KMGraphDoubleSlider : NSView <DobleSliderKnobEvents> {
    
    CALayer *leftKnob;
    
    CALayer *rightKnob;

    NSCurrentSelecedKnob currentKnob;
    NSClickedArea        clickedSide;
    
    NSBezierPath * graphPath;
    NSBezierPath * cetralLine;
    
    NSUInteger knobWidth;
    NSUInteger halfKnob;
    
    NSMutableArray *  _graphArrayConverted;
    
    
    
}

- (void) leftKnobMoved:(NSEvent *)theEvent;
- (void) rightKnobMoved:(NSEvent *)theEvent;
- (void) leftKnobDragged:(NSEvent *)theEvent;
- (void) rightKnobDragged:(NSEvent *)theEvent;

- (id) delegate;
- (void) setDelegate: (id) newDelegate;

@property (nonatomic) NSMutableArray *  graphArray;

@property (nonatomic) NSNumber *  leftKnobValue;
@property (nonatomic) NSNumber *  rightKnobValue;

@property (nonatomic) NSColor *  backgroundColor;
@property (nonatomic) NSColor *  graphColor;
@property (nonatomic) NSColor *  lineColor;

@property id delegate;

@end

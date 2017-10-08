//
//  KMImageLayerDelegate.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 09/02/2016.
//  Copyright © 2016 Mammadov. All rights reserved.
//

#import "KMImageLayerDelegate.h"
#import "KMAppDelegate.h"

@implementation KMImageLayerDelegate {

KMAppDelegate * delegate;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        delegate = (KMAppDelegate * ) [[NSApplication sharedApplication] delegate] ;
        
    }
    return self;
}

- (void)displayLayer:(CALayer *)theLayer {
    
    //KMAppDelegate * delegate = [[NSApplication sharedApplication]delegate];
    
    NSSlider * zoomTool = delegate.toolZoomSnap;
    
    float defaultZoomValue = 0.641111f;
    float zoomMultiplier = ([zoomTool floatValue] - defaultZoomValue)/defaultZoomValue+1;
    
    zoomMultiplier = (zoomMultiplier==0)?1:zoomMultiplier;
    
//    NSLog(@"Zoom value:%f", zoomMultiplier);
    
    NSURL * imageURL = [delegate currentLoadedImageURL];
    
    NSImage * image = [[NSImage alloc] initWithContentsOfURL:imageURL];
    
    NSImageRep *rep = [[image representations] objectAtIndex:0];
//    NSSize imageSize = NSMakeSize(rep.pixelsWide, rep.pixelsHigh);
    
//    NSLog(@"Image Size:%@",  NSStringFromSize(imageSize));
//    NSLog(@"View Frame:%@",  NSStringFromSize(delegate.mImageView.frame.size));
//    NSLog(@"View Bounds:%@", NSStringFromRect(delegate.mImageView.bounds));


    NSSize viewFrameSize = delegate.mImageView.frame.size;
    
    float widthRatio = (rep.pixelsWide/viewFrameSize.width);
    float heightRatio = (rep.pixelsHigh/viewFrameSize.height);
    float devisionRatio = (widthRatio>heightRatio)?widthRatio:heightRatio;
    
    //NSLog(@"WidthRatio:%f", widthRatio);
    //NSLog(@"HeightRatio:%f", heightRatio);
    
    CGRect rect = CGRectMake((viewFrameSize.width-rep.pixelsWide/devisionRatio)/2,
                       (viewFrameSize.height - rep.pixelsHigh/devisionRatio)/2,
                       (rep.pixelsWide/devisionRatio),
                       (rep.pixelsHigh/devisionRatio));
    
    CGRect rectBounds = CGRectMake((viewFrameSize.width-rep.pixelsWide/devisionRatio)/2 ,
                             (viewFrameSize.height - rep.pixelsHigh/devisionRatio)/2 ,
                             (rep.pixelsWide/devisionRatio)*zoomMultiplier,
                             (rep.pixelsHigh/devisionRatio)*zoomMultiplier);
    theLayer.frame = rect;
    theLayer.bounds = rectBounds;
    
//    NSLog(@"The Rect:%@", NSStringFromRect(rect));
//    NSLog(@"TheLayer Bounds:%@", NSStringFromRect(theLayer.bounds));
    
    //Avoid frame for logo image
    if ([[imageURL lastPathComponent] isEqualToString:@"snap_front.png"]) {
        theLayer.borderWidth = 0.0f;
        theLayer.cornerRadius = 0.0f;
    } else {
        theLayer.borderWidth = 1.0f;
        theLayer.cornerRadius = 1.0f;
        //theLayer.masksToBounds = YES;
        theLayer.borderColor = CGColorRetain([NSColor colorWithCalibratedRed:255 green:255 blue:255 alpha:1].CGColor);//WHITE
    }
    
/*    CABasicAnimation * fadeAnim;
    fadeAnim = [CABasicAnimation animationWithKeyPath:@"contents"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 3.0;
    [theLayer addAnimation:fadeAnim forKey:@"contents"];
*/
    
    theLayer.contents = image;


//    NSLog(@"Layer Frame:%@", NSStringFromRect(theLayer.frame));
    //NSLog(@"Layer Bounds:%@", NSStringFromRect(theLayer.bounds));

#ifdef DEBUG
    NSLog(@"Display Layer Called");
#endif
}

@end

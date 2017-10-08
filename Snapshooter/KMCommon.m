//
//  KMCommon.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 02/08/2014.
//  Copyright (c) 2014 Mammadov. All rights reserved.
//

#import "KMCommon.h"
#import <Quartz/Quartz.h>
/* 
 *  Public functions
 */







@implementation KMCommon





void SKScanHexColor(NSString * hexString, float * red, float * green, float * blue, float * alpha) {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    if (red) { *red = ((baseValue >> 24) & 0xFF)/255.0f; }
    if (green) { *green = ((baseValue >> 16) & 0xFF)/255.0f; }
    if (blue) { *blue = ((baseValue >> 8) & 0xFF)/255.0f; }
    if (alpha) { *alpha = ((baseValue >> 0) & 0xFF)/255.0f; }
}



-(NSColor * ) getColorfromHex: (NSString * ) hex {
    
    //@"211f1f"
    float red, green, blue, alpha;
    SKScanHexColor(hex, &red, &green, &blue, &alpha);
    
    NSColor * color = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
        
    return color;
    
}


- (NSURL *) getInternalImageURL: (NSString *) imagestr {
    
    NSString *   path;
    
    //Setting front image
    path = [[NSBundle mainBundle] pathForResource: [imagestr componentsSeparatedByString:@"."][0]
                                           ofType: [imagestr pathExtension]];
    
    return [NSURL fileURLWithPath: path];
}


- (NSString *) getFileNameFormPath: (NSString *) path {
    
    return [[path lastPathComponent] stringByDeletingPathExtension];
    
}

- (NSString *) getDateStrFromFileName: (NSString *) dateStr {
    
    return [[dateStr componentsSeparatedByString:@"_" ] objectAtIndex:3 ];
    
}

- (NSString *) getDateStrFromPath: (NSString *) path {
    
    return [self getDateStrFromFileName:[self getFileNameFormPath:path]];
    
}

- (NSString *) getReadibleDateStrFromDateStr: (NSString *) dateStr {
    
    //Format date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    //Convert to date
    NSDate * date = [dateFormatter dateFromString:dateStr];
    
    //Set new (easy readible) format
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    
    return [dateFormatter stringFromDate:date];
    
}

+ (NSString *) getReadibleDateStrFromDate: (NSDate *) date {
    
    //Format date
    KMDateTimeFormatters * dtformatter = [[KMDateTimeFormatters alloc] init];

    
    return [[dtformatter dateTimeFormatter] stringFromDate:date];
    
    //return [[KMDateTimeFormatters dateTimeformatter_] stringFromDate:date];
    
}

- (NSString *) getReadibleDateStrFromPathWithDateStr: (NSString *) path {
 
    return [self getReadibleDateStrFromDateStr:[self getDateStrFromPath:path]];
    
}

@end

/*
@implementation KMDownloadFileObject

@synthesize fileName;
@synthesize fileSize;
@synthesize fileStatus;
@synthesize fileUploadInfoDict;
@synthesize downloadSeq;
@synthesize taskRequestCounter;

@end */

@implementation KMDateTimeFormatters

@synthesize dateFormatter;
@synthesize timeFormatter;
@synthesize dateTimeFormatter;
@synthesize numberDateTimeFormatter;

-(id)init {
    
    self = [super init];
    
    if (!(dateFormat) && !(timeFormat)) {
        
        dateFormat = @"dd MMM yyyy";
        timeFormat = @"HH:mm:ss";
        
    }
    
    return self;
    
}

/*
+ (NSDateFormatter *) dateTimeformatter_ {
    
    return [[NSDateFormatter alloc] init];
} */

- (id)initWithDateTimeFormat: (NSString * ) date timeFormat: (NSString *) time {
    
    dateFormat = date;
    timeFormat = time;
    
    return [self init];
}

- (NSDateFormatter *) dateFormatter {
    
    if (!dateFormatter) {
    
        dateFormatter       = [[NSDateFormatter alloc] init];
        [dateFormatter      setDateFormat:dateFormat];
        
    }
    
    return dateFormatter;
    
}

- (NSDateFormatter *) timeFormatter {
    
    if (!timeFormatter) {
        
        timeFormatter       = [[NSDateFormatter alloc] init];
        [timeFormatter      setDateFormat:timeFormat];
        
    }

    return timeFormatter;
    
}


- (NSDateFormatter *) dateTimeFormatter {
 
    if (!dateTimeFormatter) {
        
        dateTimeFormatter   = [[NSDateFormatter alloc] init];
        [dateTimeFormatter  setDateFormat:[[dateFormat stringByAppendingString:@" "] stringByAppendingString: timeFormat]];
        
    }

    return dateTimeFormatter;
    
}

- (NSDateFormatter *) numberDateTimeFormatter {
    
    if (!numberDateTimeFormatter) {
    
        numberDateTimeFormatter   = [[NSDateFormatter alloc] init];
        [numberDateTimeFormatter  setDateFormat:[dateFormat stringByAppendingString: timeFormat]];
        
    }
    
    return numberDateTimeFormatter;
    
}


@end


//****************************************************************
//------Image object class. Used to hold one image at a time
//****************************************************************





@implementation KMImageObject

@synthesize imagePath = _imagePath;
@synthesize imageSubtitle = _imageSubtitle;
@synthesize imageCreateDate = _imageCreateDate;
@synthesize imageFileName = _imageFileName;
@synthesize imageFileSize = _imageFileSize;
@synthesize imageId = _imageId;
@synthesize imageScreenName = _imageScreenName;
@synthesize imageStatus;
@synthesize fileUploadInfoDict;
@synthesize taskRequestCounter;

- (NSString *)  imageRepresentationType
{
    return IKImageBrowserPathRepresentationType;
}

- (id)  imageRepresentation
{
    return _imagePath;
}

- (NSString *) imageUID
{
    return _imagePath;
}

- (void) setImagePath:(NSString *)imagePath {
    
    _imagePath = imagePath;
    
}

- (NSString * ) imagePath {
    
    return _imagePath;
}

- (void) setImageSubtitle:(NSString *)imageSubtitle {
    
    _imageSubtitle = imageSubtitle;
}

- (NSString *) imageSubtitle {
    
    return _imageSubtitle;
}

- (void) setImageCreateDate:(NSDate *)imageCreateDate {
    
    _imageCreateDate = imageCreateDate;
    
}

- (NSDate *) imageCreateDate {
    
    return _imageCreateDate;
}


- (void) setImageFileName:(NSString *)imageFileName {
    
    _imageFileName = imageFileName;
}

- (NSString *) imageFileName {
    
    return _imageFileName;
}

- (void) setImageFileSize:(NSInteger )imageFileSize {
    
    _imageFileSize = imageFileSize;
    
}

- (NSInteger ) imageFileSize {
    
    return _imageFileSize;
}

- (void) setImageId:(NSInteger )imageId {
    
    _imageId = imageId;
}

- (NSInteger ) imageId {
    
    return _imageId;
}

- (void) setImageScreenName:(NSString *)imageScreenName {
    
    _imageScreenName = imageScreenName;
}

- (NSString *) imageScreenName {
    
    return _imageScreenName;
}


@end

//********** END ********************************

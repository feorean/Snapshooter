//
//  KMCommon.h
//  Snapshooter
//
//  Created by Khalid Mammadov on 02/08/2014.
//  Copyright (c) 2014 Mammadov. All rights reserved.
//

//#import <Foundation/Foundation.h>


@interface KMCommon : NSObject


- (NSColor *)   getColorfromHex: (NSString * ) hex;
- (NSURL *) getInternalImageURL: (NSString * ) imagestr;

- (NSString *) getFileNameFormPath:     (NSString *) path;
- (NSString *) getDateStrFromFileName:  (NSString *) dateStr;
- (NSString *) getDateStrFromPath:      (NSString *) path;
- (NSString *) getReadibleDateStrFromDateStr: (NSString *) dateStr;
- (NSString *) getReadibleDateStrFromPathWithDateStr: (NSString *) path;
+ (NSString *) getReadibleDateStrFromDate: (NSDate *) date;
    
@end

/*
@interface KMDownloadFileObject : NSObject

@property (nonatomic)  NSString      * fileName;
@property (nonatomic)  NSUInteger      fileSize;
@property (nonatomic)  NSDictionary  * fileUploadInfoDict;
@property (nonatomic)  NSString      * fileStatus;
@property (nonatomic)  int             downloadSeq;
@property (nonatomic)  int             taskRequestCounter;

@end
*/

@interface KMImageObject : NSObject

@property (nonatomic)  NSString  * imagePath;
@property (nonatomic)  NSString  * imageSubtitle;
@property (nonatomic)  NSDate    * imageCreateDate;
@property (nonatomic)  NSString  * imageCreateDay;
@property (nonatomic)  NSString  * imageFileName;
@property (nonatomic)  NSString  * imageFileNameXS;
@property (nonatomic)  NSInteger  imageFileSize;
@property (nonatomic)  NSInteger  imageFileSizeXS;
@property (nonatomic)  NSInteger  imageId;
@property (nonatomic)  NSString  * imageScreenName;
@property (nonatomic)  NSString  * imageStatus;
@property (nonatomic)  NSDictionary  * fileUploadInfoDict;
@property (nonatomic)  int             taskRequestCounter;

@end

@interface KMDateTimeFormatters : NSObject {

    NSString * dateFormat ;
    NSString * timeFormat ;
    
}


- (id)initWithDateTimeFormat: (NSString * ) date timeFormat: (NSString *) time;

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSDateFormatter *timeFormatter;
@property (nonatomic) NSDateFormatter *dateTimeFormatter;
@property (nonatomic) NSDateFormatter *numberDateTimeFormatter;


@end
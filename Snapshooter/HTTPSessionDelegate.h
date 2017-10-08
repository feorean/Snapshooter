//
//  HTTPSessionDelegate.h
//  HTTP_Test
//
//  Created by Khalid Mammadov on 11/10/2015.
//  Copyright © 2015 Mammadov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMCommon.h"


typedef void (^CompletionHandlerType)();

typedef enum { Authenticated, NotConnected } AthenticationStatus;

@interface HTTPSessionDelegate : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate> {
    
    NSMutableDictionary * downloadRequestQueue;
    NSMutableDictionary * uploadRequestQueue;
    NSMutableDictionary * uploadProgressQueue;
    NSTimer             * downloadRequestQueueSchedule;
    NSTimer             * uploadRequestQueueSchedule;
    NSTimer             * uploadProgressQueueSchedule;
    
    NSString * savedUsername;
    NSString * savedPassword;
    
    
    NSUInteger runCounter;
    
    NSURLSession * defaultSession;
    
    
    NSMutableArray * taskList;
    NSMutableArray * requestList;

}

@property AthenticationStatus connectionStatus;
//@property NSURLSession *defaultSession;

- (NSUInteger) getDownloadRequestQueueCount;

- (void) addCompletionHandler: (CompletionHandlerType) handler forSession: (NSString *)identifier;
- (void) callCompletionHandlerForSession: (NSString *)identifier;

- (void) URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data;
- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location;

- (void) requestURL: (NSURL *) url withData: (NSData * ) data;
- (void) uploadFile: (NSDictionary * ) data ;
//- (void) uploadFile: (NSURL * ) filePath withData: (NSDictionary * ) data ;
//- (void) downloadFile: (NSString *) fileName withFileSize: (NSUInteger ) fileSize andDownloadSeq:(NSInteger) downloadSeq ;
- (void) downloadFile: (KMImageObject *) downloadFile;
- (void) authenticateUser: (NSString * ) username password: (NSString *) password;
    
- (BOOL) isInternetAvailable;

- (void)respondReceived:(NSData *)data;


- (void) testStartUpload;
- (void) restartSession;
- (void) renewSession;

- (NSURL * ) snapshooterCloudURL;

@end


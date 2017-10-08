//
//  HTTPSessionDelegate.m
//  HTTP_Test
//
//  Created by Khalid Mammadov on 11/10/2015.
//  Copyright © 2015 Mammadov. All rights reserved.
//

#import "HTTPSessionDelegate.h"
#import "KMAppDelegate.h"
#import <AppKit/AppKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "KMCommon.h"





@implementation HTTPSessionDelegate

//@synthesize defaultSession;
@synthesize connectionStatus;


-(id)init {

    if (self = [super init]) {
        
        [self createSession];

        //Start queue control
        [self startDownloadRequestQueueSchedule];
        [self startUploadRequestQueueSchedule];
        [self startUploadProgressQueueSchedule];
        
        connectionStatus = NotConnected;
        
        uploadProgressQueue = [[NSMutableDictionary alloc] init];
        
        taskList = [[NSMutableArray alloc] init];
    }

    return self;

}

-(void) createSession {
    
    //NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSessionConfiguration *backgroundConfigObject = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[[NSUUID UUID] UUIDString]];
    
    [backgroundConfigObject setURLCache:nil];
    [backgroundConfigObject setRequestCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    
    defaultSession = [NSURLSession sessionWithConfiguration: backgroundConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    
}


-(void) renewSession {
    
    [defaultSession invalidateAndCancel];
    
/*    for (NSMutableURLRequest *request in requestList) {
        
        [request setHTTPBody:nil];
        
    }*/
    
    [requestList removeAllObjects];
    [taskList removeAllObjects];
    [uploadProgressQueue removeAllObjects];
    
    defaultSession = nil;
    
    [self createSession];
    
}

- (void) restartSession {
    
    //NSLog(@"Restarting session");
    
    [self stopUploadProgressQueueSchedule];
    
    [self renewSession];
    
    
    [self reConnect];
    
    [self startUploadProgressQueueSchedule];
    
}



- (KMAppDelegate * ) getDelagate {
    
    return [[NSApplication sharedApplication] delegate] ;
    
}

- (NSURL * ) workingDirectory {
    
    return [self.getDelagate snapshotsPathUrl];
    
}

- (NSURL * ) snapshooterCloudURL {
    
    return [NSURL URLWithString:@"/SnapshooterCloud/" relativeToURL:[[self getDelagate] getHostname]];
}

- (void) addCompletionHandler: (CompletionHandlerType) handler forSession: (NSString *)identifier {
}
- (void) callCompletionHandlerForSession: (NSString *)identifier {
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    //NSLog(@"Completed task");
}


- (BOOL) isInternetAvailable
{
    SCNetworkReachabilityRef target;
    
    SCNetworkConnectionFlags flags = 0;
    
    Boolean result;
    
    target = SCNetworkReachabilityCreateWithName(NULL, [[[self getDelagate] getHostname].absoluteString UTF8String]);
    
    result = SCNetworkReachabilityGetFlags(target, &flags);
    
    CFRelease(target);
    
    return result;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    [self respondReceived:data];
    
}

- (void) addToUploadProgressQueue: (KMImageObject *) anImage {
    
    if (![uploadProgressQueue objectForKey:anImage.imageFileName]) {
    
        [uploadProgressQueue setValue:anImage forKey:anImage.imageFileName];
    
    }
    
}

-(void) removeFromUploadProgressQueue: (NSString *) fileName {

    //If exists then
    if ([uploadProgressQueue objectForKey:fileName]) {
        
        //NSLog(@"Deleting request: %@", fileName);
        [uploadProgressQueue removeObjectForKey:fileName];
    }
    
}

-(bool) addFileToDownloadListIfNotAdded: (KMImageObject * ) downloadFile {

//(NSString *) fileName  withFileSize: (NSUInteger ) fileSize andDownloadSeq:(NSInteger) downloadSeq {

    bool result = false; //Did not add
    
    if (!downloadRequestQueue) {
        
        downloadRequestQueue = [[NSMutableDictionary alloc] init];
    }
    
    
    
    //Check if already added
    if (![downloadRequestQueue objectForKey:downloadFile.imageFileName]) {
        //NSLog(@"Adding request for: %@", downloadFile.fileName);
        
        KMImageObject * afile = downloadFile;
        
        afile.imageStatus = @"requested";
        
        //It's new so add
        [downloadRequestQueue setValue:afile forKey:downloadFile.imageFileName];
        //[downloadRequestQueue setValue:@"requested" forKey:fileName];
        //[downloadRequestQueue setValue:fileSize forKey:[fileName stringByAppendingString:@"FileSize"]];
        
        
        
        result = true; //Added
    } else {
        
        //NSLog(@"There is already a request for: %@", downloadFile.fileName);
    }
    
    return result;
}


-(void) addFileToUploadListIfNotAddedFile: (KMImageObject *) aFile {

    if (![uploadRequestQueue objectForKey:aFile.imageFileName]) {
        
        KMImageObject * thefile = aFile;// [[KMImageObject alloc] init];
        //thefile = aFile;
        thefile.imageStatus = @"requested";
        
        
        thefile.taskRequestCounter = 0;
        //It's new so add
        [uploadRequestQueue setValue:thefile forKey:thefile.imageFileName];
        
        
    }
    
}

-(bool) addFileToUploadListIfNotAdded: (NSDictionary *) fileInfo {
    
    bool result = false; //Did not add
    
    if (!uploadRequestQueue) {
        
        uploadRequestQueue = [[NSMutableDictionary alloc] init];
    }
    
    NSString * fileName = [[NSURL URLWithString:[fileInfo valueForKey:@"file"]] lastPathComponent];
    
    //Check if already added
    if (![uploadRequestQueue objectForKey:fileName]) {
        //NSLog(@"Adding upload request for: %@", fileName);
        
        KMImageObject * afile = [[KMImageObject alloc] init];
        
        
        
        afile.imageFileName = fileName;
        afile.fileUploadInfoDict = fileInfo ;
        afile.imageStatus = @"requested";
        afile.taskRequestCounter = 0;
        
        //It's new so add
        [uploadRequestQueue setValue:afile forKey:fileName];
        
        
        result = true; //Added
    } else {
        
        //NSLog(@"There is already a request for: %@", fileName);
    }
    
    return result;
}


-(void) removeFileDownloadRequest: (NSString *) fileName {
    //NSLog(@"Trying to delete request: %@", fileName);
    //If exists then 
    if ([downloadRequestQueue objectForKey:fileName]) {
        
        //NSLog(@"Deleting request: %@", fileName);
        [downloadRequestQueue removeObjectForKey:fileName];
    }
    
}

-(void) removeFileUploadRequest: (NSString *) fileName {

    
    if ([uploadRequestQueue objectForKey:fileName]) {
        
        //NSLog(@"Deleting upload request: %@", fileName);
        [uploadRequestQueue removeObjectForKey:fileName];
    }

    
    //Delete from progress queue as well
    [self removeFromUploadProgressQueue:fileName];
    
    
}


- (void) correctFilePermission: (NSString *) fileName {
    
    NSURL * targetFile  = [NSURL URLWithString:fileName relativeToURL:[self workingDirectory]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:420] forKey:NSFilePosixPermissions]; /*511 is Decimal for the 777 octal*/
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm setAttributes:dict ofItemAtPath:[targetFile path] error:&error];
    
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    //NSLog(@"Tmp URL:%@", location);
    
    //Get downloaded file name
    NSString * fileName = [[[[downloadTask originalRequest]  URL] query] substringFromIndex:9];
    
    //Set destination filename
    NSURL * targetFile  = [NSURL URLWithString:fileName relativeToURL:[self workingDirectory]];
    
    //Get file manager for file operations
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError * error = nil;
    
    //Get downloaded file size
    unsigned long long fileSize = [[fileManager attributesOfItemAtPath:[location path] error:&error] fileSize];
    
    KMImageObject * fo = [downloadRequestQueue valueForKey:fileName];
    
    //NSLog(@"Checking file %@ size: received=%lld expected=%lu", fileName, fileSize, (unsigned long)[fo fileSize]);
    
    
    //Check file size
    if (fileSize != [fo imageFileSize] ) {
        
        fo.imageStatus = @"failed";
        [downloadRequestQueue setValue:fo forKey:fileName];
        
        NSLog(@"Download failed");
        
        //NSLog(@"Size does not match skeeping...");
        
        //Copy from tmp folder into working dir
        //[fileManager copyItemAtURL:location toURL:[targetFile URLByAppendingPathExtension:@".bad"] error:&error];
        
        
        return ;
    }
    
    //Check before copying
    if (![fileManager fileExistsAtPath:targetFile.path]) {
    
        //Copy from tmp folder into working dir
        [fileManager copyItemAtURL:location toURL:targetFile error:&error];
        
    }
    
    //Call the method on delegate
    [self fileDidDownload:fileName];
    
    if (error) {
        NSLog(@"Error: %@", [error description] );
        return;
    }
    
    
    
    //NSLog(@"Download completed:%@ to %@", location, targetFile);
}


- (void) requestURL: (NSURL *) url withData: (NSData * ) data {
 
    //Check if internet/server available before proceeding
    if (!self.isInternetAvailable) {
        
        return;
    }
    
    if (!defaultSession) {
        
        return;
    }
    
    //const char * bytes = data;
    
    NSURLSessionTask * task;
    
    if ((data.length) > 0) {
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];//[NSData dataWithBytes:bytes length:strlen(bytes)]];
    
        task = [defaultSession dataTaskWithRequest:request];
        
    } else {
        
        //Get method
        task = [defaultSession dataTaskWithURL:url];
        
        [taskList addObject:task];
        
    }
        
    if (task) {
        
        [task resume];
        
    }
    
    //NSLog(@"Requesting URL: %@", url);
    //NSLog(@"With params:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    //NSLog(@"Request started");
    
}

-(bool) checkIfAlreadyDownloaded: (NSString *) fileName {

    bool result = false;

    
    NSURL * targetFile  = [NSURL URLWithString:fileName relativeToURL:[self workingDirectory]];
    //Get file manager for copy operation
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:targetFile.path]) {
        
        result = true;
    }
    

    return result;
    
    
}

- (NSUInteger ) getDownloadRequestQueueCount {
    
    return [downloadRequestQueue count];
    
}

-(void) fileDidUpload: (NSString *) fileName {

    //Preserver file info
    KMImageObject * afile = [uploadRequestQueue objectForKey:fileName];
    
    //Remove request as we do not need it anymore
    [self removeFileUploadRequest:fileName];

    
    
    //Call the method on delegate
    [[self getDelagate] fileDidUpload:afile];
    
    //NSLog(@"Uploaded: %@", fileName);
    
}


-(void) fileDidDownload: (NSString *) fileName {
    
    [self correctFilePermission:fileName];
    
    //Preserver file info
    KMImageObject * afile = [downloadRequestQueue objectForKey:fileName];
    
    //Remove request as we do not need it anymore
    [self removeFileDownloadRequest:fileName];
    
    //Call the method on delegate
    [[self getDelagate] fileDidDownload:afile];
    
}

-(void) validationCompleted: (NSString *) status hash:(NSString *) hash userid: (NSString *) userId  {
    
    //Call the method on delegate
    [[self getDelagate] validationCompleted:status hash:hash userid:userId];    
    
}

-(void) snapDeletedOnServer: (NSArray *) localids {
    
    //Call the method on delegate
    [[self getDelagate] snapDeletedOnServer:localids];
    
}

-(void) maintainDownloadRequestQueue {
    
    //Start - requested
    //Restart - failed 
   
    //NSLog(@"Maintain download Request");
    
    if (!(connectionStatus == Authenticated)) {
        
        [self restartConnectionAfterDelay];
        
        return;
        
    }
    
    
    NSDictionary * requestCopy = [NSDictionary dictionaryWithDictionary:downloadRequestQueue];
    
    for (NSString * key in requestCopy) {
        
        KMImageObject * fo = [requestCopy valueForKey:key];
        fo.taskRequestCounter++;
        
        //Check if download needed
        if ([[fo imageStatus] isEqualToString:@"requested"]
            ||
            [[fo imageStatus] isEqualToString:@"failed"]
            ||
            ([fo taskRequestCounter] > 10 )) {
            
            [self addToUploadProgressQueue:fo];
            
            //Start download
            [self startDownloadForFile:key];
            
            fo.imageStatus = @"downloading";
            fo.taskRequestCounter = 1; //reset
            
            [downloadRequestQueue setValue:fo forKey:key];
            
        }
        
    }
    
}

-(NSUInteger) uploadingRequestsCount {
    
    return [uploadProgressQueue count];
}

-(void) testStartUpload {
    
    NSDictionary * requestCopy = [NSDictionary dictionaryWithDictionary:uploadRequestQueue];
    
    float i = 1 ;
    
    for (NSString * key in requestCopy) {
        
        KMImageObject * fo = [requestCopy valueForKey:key];
        
        //Increment request counter
        
        if ([fo taskRequestCounter] == 0) {
            
            //Start upload
            [self startFileUpload:[fo fileUploadInfoDict] withDelay:i];
            
            break;
            
            //NSLog(@"ONE Started");
        }
    }
    
}

-(void) maintainUploadProgressQueue {
    
    
    //Restart if needed
    if (runCounter > 600) {

        //NSLog(@"*****RESTARTING THE SESSION!!!******");
        
        [self restartSession];
        
        runCounter=0;
        
        return; //wait for the next loop
        
    }
    
    
    NSDictionary * requestCopy = [NSDictionary dictionaryWithDictionary:uploadProgressQueue];
    
    float i = 1 ;
    
    for (NSString * key in requestCopy) {

        KMImageObject * fo = [requestCopy valueForKey:key];
        
        //Increment request counter

        if ([fo taskRequestCounter] == 0) {
            
            //Start upload
            [self startFileUpload:[fo fileUploadInfoDict] withDelay:i];
            
            i = 1;
            
        }
        
        if ([fo taskRequestCounter] > 5) {
            
            //Remove it from queues
            [self removeFileUploadRequest:fo.imageFileName];
            
            //Add to the end of the queue
            [self addFileToUploadListIfNotAddedFile:fo];
            
        } else {
        
            fo.taskRequestCounter++;
            
            [uploadProgressQueue setValue:fo forKey:key];

        }
        
        //break;
    }
    
}


-(void) tasksStates {
    
    int iRunning = 0;
    int iSuspended = 0;
    int iCanceling = 0;
    int iCompleted = 0;
    
    for (NSURLSessionTask * aTask in taskList ) {
        
        /*
        NSURLSessionTaskStateRunning = 0,
        NSURLSessionTaskStateSuspended = 1,
        NSURLSessionTaskStateCanceling = 2,
        NSURLSessionTaskStateCompleted = 3,
         */

        switch (aTask.state) {
            case NSURLSessionTaskStateRunning:
                iRunning++;
                break;
            case NSURLSessionTaskStateSuspended:
                iSuspended++;
                break;
            case NSURLSessionTaskStateCanceling:
                iCanceling++;
                break;
            case NSURLSessionTaskStateCompleted:
                iCompleted++;
                
            default:
                break;
        }
        
        
    }
    
  //  NSLog(@"TASK STATES: Running=%d, Suspended=%d, Canceling=%d, Completed=%d",iRunning, iSuspended, iCanceling, iCompleted );
    
}

-(void) restartConnectionAfterDelay {
    
    [self suspendUploadProgressQueueSchedule];
    [self suspendingUploadRequestQueueSchedule];
    [self suspendingDownloadRequestQueueSchedule];
    [self reConnect];
}

-(void) maintainUploadRequestQueue {
    
    //Start - requested
    //Restart - failed
    
    //NSLog(@"Maintain upload Request");
    
    if (!(connectionStatus == Authenticated)) {
        

        [self restartConnectionAfterDelay];
        return;
        
    }
    
    
    //NSLog(@"Uploading request count:%ld", [self uploadingRequestsCount]);
    //NSLog(@"Upload TASK COUNT:%ld", [taskList count]);
    [self tasksStates];
    
    NSDictionary * requestCopy = [NSDictionary dictionaryWithDictionary:uploadRequestQueue];
    
    for (NSString * key in requestCopy) {        
        
        
        if ([self uploadingRequestsCount] > 200) {
            
            return;
            
        }
        
        KMImageObject * fo = [requestCopy valueForKey:key];

        //Check if upload needed
        
        if ([[fo imageStatus] isEqualToString:@"requested"]
            ||
            [[fo imageStatus] isEqualToString:@"failed"] ) {
            
            
            [self addToUploadProgressQueue:fo];
            
        }

        
    }
    
    
}

- (void) startDownloadRequestQueueSchedule {
    
    downloadRequestQueueSchedule =  [NSTimer scheduledTimerWithTimeInterval:3 //10 seconds
                                                            target:self
                                                          selector:@selector(maintainDownloadRequestQueue)
                                                          userInfo:nil
                                                           repeats:YES];
    
}

- (void) stopDownloadRequestQueueSchedule {
    
    [downloadRequestQueueSchedule invalidate];
    
}

- (void) startUploadRequestQueueSchedule {
    
    if (![uploadRequestQueueSchedule isValid]) {
    
        uploadRequestQueueSchedule =  [NSTimer scheduledTimerWithTimeInterval:3 //10 seconds
                                                                 target:self
                                                               selector:@selector(maintainUploadRequestQueue)
                                                               userInfo:nil
                                                                repeats:YES];
        //NSLog(@"***Upload request schedule started!");
    }
    
}


- (void) stopUploadRequestQueueSchedule {
    
    if ([uploadRequestQueueSchedule isValid]) {
    
        [uploadRequestQueueSchedule invalidate];
        
        //NSLog(@"***Upload request schedule stopped!");
    }
    
}


- (void) startUploadProgressQueueSchedule {

    if (![uploadProgressQueueSchedule isValid]) {
    
        uploadProgressQueueSchedule =  [NSTimer scheduledTimerWithTimeInterval:5 //10 seconds
                                                                        target:self
                                                                      selector:@selector(maintainUploadProgressQueue)
                                                                      userInfo:nil
                                                                       repeats:YES];
        //NSLog(@"***Upload progress started!");
        
    }
    
}

- (void) stopUploadProgressQueueSchedule {
    
    if ([uploadProgressQueueSchedule isValid]) {
    
        [uploadProgressQueueSchedule invalidate];
        //NSLog(@"***Upload progress stopped!");
        
    }
}


- (void) suspendUploadProgressQueueSchedule {
    
    //NSLog(@"***Suspending upload progresses");
    [self stopUploadProgressQueueSchedule];
    [self performSelector:@selector(startUploadProgressQueueSchedule) withObject:self afterDelay:60 ];
    
}

- (void) suspendingUploadRequestQueueSchedule {

    //NSLog(@"***Suspending upload requests");
    [self stopUploadRequestQueueSchedule];
    [self performSelector:@selector(startUploadRequestQueueSchedule) withObject:self afterDelay:60 ];
    
    
}

- (void) suspendingDownloadRequestQueueSchedule {
    
    //NSLog(@"***Suspending download requests");
    [self stopDownloadRequestQueueSchedule];
    [self performSelector:@selector(startDownloadRequestQueueSchedule) withObject:self afterDelay:60 ];
    
    
}

-(void) startDownloadForFile: (NSString *) fileName {
    
    //Check if internet/server available before proceeding
    if (!self.isInternetAvailable) {
        
        return;
    }
    
    if (!defaultSession) {
        
        return;
    }
    
    NSURL * url = [NSURL URLWithString:@"downloadSnapshot" relativeToURL:self.snapshooterCloudURL];
    
    NSURL * fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"?filename=%@", fileName] relativeToURL:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileUrl];
    
    [request setHTTPMethod:@"GET"];

    
    NSURLSessionDownloadTask * task = [defaultSession downloadTaskWithRequest:request];
    
    [taskList addObject:task];
    
    if (task) {
        
        [task resume];
        
        NSLog(@"Download started");
        
    } else {
        
        //NSLog(@"Something did go wrong");
    }
    
}

-(void) downloadFile: (KMImageObject *) downloadFile {

    if ([self checkIfAlreadyDownloaded:downloadFile.imageFileName]) {
        
        [self fileDidDownload:downloadFile.imageFileName];
        
        return;
    }

    
    //Check if request to download already made.
    //If not add to the list then add and then you can go and make real request
    //If already added then return
    if (![self addFileToDownloadListIfNotAdded:downloadFile]) {
      
        return;
    }
    
    
}


- (void) startFileUpload: (NSDictionary * ) dataDict withDelay: (int) delay {

    
    //Check if internet/server available before proceeding
    if (!self.isInternetAvailable) {
        
        return;
    }
    
    if (!defaultSession) {
        
        return;
    }
    
    NSURL * url = [NSURL URLWithString:@"uploadfile" relativeToURL:self.snapshooterCloudURL];
    
    
    NSURL * filePath = [NSURL URLWithString:[dataDict valueForKey:@"file"]];
    NSString * fileName = [filePath.path lastPathComponent];
    
    NSURLSessionTask * task;
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:6]; //6 Sec
    NSMutableData *body = [NSMutableData data];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSData alloc] initWithContentsOfURL:filePath]];
    
    if ([dataDict count] > 0 ) {
        
        NSEnumerator *enumerator = [dataDict keyEnumerator];
        
        NSString * key;
        
        while ((key = [enumerator nextObject])) {
            
            if (![key isEqualToString:@"file"]) {
                
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, [dataDict valueForKey:key ]] dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            
        }
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
    }
    
    
    task = [defaultSession dataTaskWithRequest:request];

    [taskList addObject:task];
    [requestList addObject:request];
    
    if (task) {
        
        runCounter++;
        
        //[task resume];
        [task performSelector:@selector(resume) withObject:nil afterDelay:delay ];
        
    } else {
        
        NSLog(@"Something did go wrong during file upload");
    }
    
    
}

- (void) uploadFile: (NSDictionary * ) dataDict {
    
    //Check if request to upload already made.
    //If not add to the list then add and then you can go and make real request
    //If already added then return
    if (![self addFileToUploadListIfNotAdded:dataDict]) {
        
        return;
    }
    
    
}

- (NSDictionary * ) getMessageFromJSON: (NSData *) jsonMessage {
    

    
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:jsonMessage
                 options:0
                 error:&error];
    
    //NSLog(@"DATA: %@ Class: %@", [[NSString alloc] initWithData:jsonMessage encoding:NSUTF8StringEncoding], NSStringFromClass([object class]));
    //NSString * result = nil;
    NSDictionary *dataDict = nil;
    
    //NSLog(@"Class: %@", NSStringFromClass([object class]));
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        
        dataDict = object;
        
        
        /*
        NSEnumerator *enumerator = [dataDict keyEnumerator];
        
        NSString * key;
        
        while ((key = [enumerator nextObject])) {
            
            //Will loop for all, but in reality there should be only one ERR or MSG
            result = [dataDict valueForKey:key ];
            
        } */
        
        
    }
    
    return dataDict;
}


- (void) handleMessages: (NSDictionary * ) message {
    
    //NOTE: Download is not handled here
    
    NSString * insideMessage = nil;
    
    if (message == NULL) {
        
        return;
        
    }
    
    if ([[message valueForKey:@"AUTHENTICATED"] isEqualToString:@"YES"]) {
        
        NSLog(@"***Authenticated");
        [self authenticated];
        
        
    }
    
    if ([message valueForKey:@"SUCCESSFULLY_UPLOADED"] != nil) {
        
        NSLog(@"***File successfully uploaded");
        //Call the method on delegate
        [self fileDidUpload:[message valueForKey:@"SUCCESSFULLY_UPLOADED"]];
        
        
    }
    
    if ([message valueForKey:@"ERR"] != nil) {
     
        NSLog(@"ERROR from Server:%@", [message valueForKey:@"ERR"]);
        insideMessage = [message valueForKey:@"ERR"];
        
        if (([insideMessage isEqualToString:@"NOT_AUTHENTICATED"]) ||
                 ([insideMessage isEqualToString:@"DISCONNECTED"]) ||
                 ([insideMessage isEqualToString:@"NOT_CONNECTED"])) {
            
            [self setConnectionStatus:NotConnected];
            
            NSLog(@"CAN NOT CONNECT!");
            
            
            //Suspend all processes for 1 min and restart session
            [self restartConnectionAfterDelay];
        }
        
        //When user clicks connect and it fails
        if ([insideMessage isEqualToString:@"USER_VALIDATION_FAILED"]) {

            [self validationCompleted:@"FAILED" hash:nil userid:nil];
            NSLog(@"USER VALIDATION FAILED!");

        }
        
        //This one for system handling i.e. no user messages (direct)
        if ([insideMessage isEqualToString:@"VALIDATION_FAILED"]) {
            
            //Do something..
            //Set status message
            NSLog(@"Looks like having some trouble connecting");
            
            //Suspend all processes for 1 min and restart session
            [self restartConnectionAfterDelay];
        }
    }
    
    
    
    if ([message valueForKey:@"HASH"] != nil) {
        
        NSLog(@"***HASH received");
        NSString * hash = [message valueForKey:@"HASH"];
        NSString * userId = [message valueForKey:@"ID"];
        
        [self validationCompleted:@"SUCCESS" hash:hash userid:userId];
    }
    
    if ([message valueForKey:@"DELETED"] != nil) {
        
        NSLog(@"***File deleted");
        //NSLog(@"Class: %@", NSStringFromClass([[message valueForKey:@"DELETED"] class]));
        if ([[message valueForKey:@"DELETED"] isKindOfClass:[NSArray class]]) {

             //NSLog(@"Class: %@", NSStringFromClass([[message valueForKey:@"DELETED"] class]));
            [self snapDeletedOnServer:[message valueForKey:@"DELETED"] ];
        }
        
    }
    
    
    NSLog(@"Received message:%@", message);
    

}

- (void) authenticated {
    
    [self setConnectionStatus:Authenticated];
    
    NSLog(@"AUTHENTICATED");
    
    
    if ( [[self getDelagate] respondsToSelector:@selector(userDidAuthenticate)] ) {
        
        //Call the method on delegate
        [[self getDelagate]  userDidAuthenticate];
        
    } else {
        
        NSLog(@"no authentication responders!  hmmm...");
    }
    
}

- (void)respondReceived:(NSData *)data {
    
    //NSLog(@"DATA: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    //if ( [[self getDelagate] respondsToSelector:@selector(HTTPrespondReceived:)] ) {
        
        //Call the method on delegate
        [self handleMessages:[self getMessageFromJSON:data]];
        
    //} else {
        
    //    NSLog(@"no responders!  hmmm...");
    //}
        

    
}

- (void) reConnect {
    
    //const char *bytes = [[NSString stringWithFormat:@"username=%@&password=%@", savedUsername, savedPassword] UTF8String];
    
    NSData * data = [[NSString stringWithFormat:@"username=%@&password=%@", savedUsername, savedPassword] dataUsingEncoding:NSUTF8StringEncoding];
    
    //"username=khalid&password=123";
    
    NSURL *url = [NSURL URLWithString:@"authenticate" relativeToURL:self.snapshooterCloudURL];
    
    [self requestURL:url withData:data];
    
}

- (void) authenticateUser: (NSString * ) username password: (NSString *) password {
    
    //save credentials for reconnect
    
    savedUsername = username;
    savedPassword = password;
    
    [self reConnect];
    
}


@end

//
//  KMAppDelegate.m
//  The Snapshooter
//
//  Created by Khalid Mammadov on 22/07/2014.
//  Copyright (c) 2014 Mammadov. All rights reserved.
//

#import "KMAppDelegate.h"
#import <AppKit/AppKit.h>
#import <Quartz/Quartz.h>
#import "KMCommon.h"
#import <ApplicationServices/ApplicationServices.h>
#import "StartAtLoginController.h"


#define NDEBUG

@implementation KMAppDelegate



//Declare outlets and make them accessible

//  Sub : Core data
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

//  Sub : Body

//Custom setters

@synthesize deviceUUID          = _deviceUUID;
@synthesize userId              = _userId;

@synthesize snapshotQuality     = _snapshotQuality;
@synthesize snapshotTakingInterval = _snapshotTakingInterval;
@synthesize ifSignedUp;
@synthesize cloudUserName = _cloudUserName;
@synthesize cloudPassword = _cloudPassword;

@synthesize recordingStatus = _recordingStatus;

@synthesize dateFromMinGlobal   = _dateFromMinGlobal;
@synthesize dateToMaxGlobal     = _dateToMaxGlobal;
@synthesize dateFromSelection   = _dateFromSelection;
@synthesize dateToSelection     = _dateToSelection;

@synthesize doubleSliderLoValue = _doubleSliderLoValue;
@synthesize doubleSliderHiValue = _doubleSliderHiValue;

@synthesize mImportedImages     = _mImportedImages;
@synthesize selectedSnapshotCount = _selectedSnapshotCount;

@synthesize snapshotsPathUrl    = _snapshotsPathUrl;


@synthesize defaultScreen       = _defaultScreen;
@synthesize currentPeriodSelection    = _currentPeriodSelection;
@synthesize previousPeriodSelection;
@synthesize previousSelectionDay;

@synthesize storageAllowance    = _storageAllowance;
@synthesize leftClickCapture    = _leftClickCapture;
@synthesize rightClickCapture   = _rightClickCapture;
@synthesize wheelCapture        = _wheelCapture;
@synthesize keyCapture          = _keyCapture;

@synthesize nextSequenceId      = _nextSequenceId;
@synthesize downloadCounter     = _downloadCounter;
@synthesize mImageView;
@synthesize mNextViewNavigation;
@synthesize mBackViewNavigation;
@synthesize mPopupUserMenu;
@synthesize mMiddleView;
@synthesize mGalleryView;
@synthesize mTopBarView;
@synthesize mBottomPanelView;
@synthesize mMiddlePanel;
@synthesize mFilterPanelView;
@synthesize mRecordingView;
@synthesize mStatusView;
@synthesize mStatusBarView;
@synthesize window;
@synthesize mImageBrowser;
@synthesize mImageBrowser2;
@synthesize mImageBrowserClipView;
@synthesize toolZoomSnap;
@synthesize popcomboBox;
@synthesize snapTypesFilterComboBox;
@synthesize panelShowTime;
@synthesize panelSelectDateTime;
@synthesize panelCaptureStatus;
@synthesize panelDownloadCounter;

@synthesize currentLoadedImageURL;

//Progress indicator
@synthesize progressIndicator;
@synthesize progressWindow;
@synthesize progressView;
@synthesize progressBarIndicator;

//Slider
@synthesize doubleSlider;


//Image view and browser
@synthesize browserScrollView;
@synthesize browserScrollView2;
@synthesize leftMenuPanelScrollView;

//Buttons
@synthesize butToday;
@synthesize butYesterday;
@synthesize butBefore;
@synthesize butPickDates;
@synthesize butAllRange;
@synthesize butSwitchLoyout;
@synthesize butRecordingStartStop;

@synthesize leftClickFilterButton;
@synthesize rightClickFilterButton;
@synthesize scrollWheelFilterButton;
@synthesize timerFilterButton;
@synthesize manualFilterButton;

//Labels
@synthesize labelTotalSnapshots;
@synthesize labelFromDate;
@synthesize labelToDate;
@synthesize labelPanelDate;
@synthesize labelPanelTime;
@synthesize labelPrefDiskSpace;
@synthesize labelRecording;
@synthesize labelCurrentSelection;
@synthesize labelPanelCaptureStatus;
@synthesize labelDownloadCounter;
@synthesize labelPopOverMessage;

@synthesize textFieldSnapshotTakingInterval;

//Date Pickers
@synthesize datePickerFrom;
@synthesize datePickerTo;


//Settings window
@synthesize settingsTabView;
@synthesize windowSettings;
@synthesize popPanelScreenList;
@synthesize sliderForDiskAllowance;
@synthesize sliderForQuality;
@synthesize statusMenu;
@synthesize captureTabView;
@synthesize storageTabView;
@synthesize qualityTabView;
@synthesize cloudTabView;
@synthesize checkLeftClickCapture;
@synthesize checkRightClickCapture;
@synthesize checkWheelClickCapture;
@synthesize checkKeyCapture;
@synthesize checkAutoStart;
@synthesize stepperSnapshotTakingInterval;

@synthesize textFieldUsername;
@synthesize textFieldPassword;

@synthesize dateListTableView;
@synthesize screenListTableView;

//Popover
@synthesize popover;

//Usage indicator
@synthesize usageIndicator;


//Menu items
@synthesize toolStart;
@synthesize startSnapshootingMenu;
@synthesize stopSnapshootingMenu;

//--end declaration











- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
   
    //NSLog(@"Boundle path: %@", [[NSBundle mainBundle] bundlePath]);
    //NSLog(@"Recoring status: %ld", (long)self.recordingStatus);
 
    //Check if last recording status was active then restore recording
    if (self.recordingStatus == NSRecordingStarted) {
    
        [self startScreenCapture];
        
    }

        
    //We need this here to make sure horizontal scroller looks good!!!!
    //[self performSelector:@selector(standartLayout) withObject:self afterDelay:0.5 ];
    //[self setStandardLayoutTest];
   [self setAppLayout: NSStandardLayout];

}


- (void)applicationWillBecomeActive:(NSNotification *)aNotification {
 
}

- (void)applicationWillResignActive:(NSNotification *)aNotification {

}

- (void) applicationDidBecomeActive:(NSNotification *)notification {
    
    #ifdef DEBUG
    NSLog(@"Application become active");
    #endif
    
    //NSLog(@"max date %@ ", [self dateToMaxGlobal]);
    if (//(recordingStatus == NSRecordingStarted) //It was working and still working
        ([mImages count] < [self getTotalSnapshotCount]) //There are new stuff
        && (    ([self currentSelection] == NSPeriodSelectionAll)
            ||([self currentSelection] == NSPeriodSelectionToday) )  ) {
            
            //Reload data automatically
            [self reloadData];
            
        }
    
/*
    if (![window isKeyWindow]) {
        
        [window makeKeyAndOrderFront:self];
        
    } */
    
}




//****************************************************************
//------Core Data
//****************************************************************



// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "The-Snapshooter.The_Snapshooter" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    
    return [appSupportURL URLByAppendingPathComponent:@"Snapshooter"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Snapshooter" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Snapshooter.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }
    
    
    [self stopAllSchedules];
    

    return NSTerminateNow;
}

//********** END CORE DATA ********************************







//****************************************************************
//              Body
//****************************************************************


//------------------------
//  DB Data manipulation
//------------------------

-(BOOL) initDBparams {
    
    screens =   [NSEntityDescription
                        entityForName:@"Screens"   inManagedObjectContext:[self managedObjectContext]];
    
    settings  = [NSEntityDescription
                        entityForName:@"Settings"  inManagedObjectContext:[self managedObjectContext]];
    
    snapshots = [NSEntityDescription
                        entityForName:@"Snapshots" inManagedObjectContext:[self managedObjectContext]];
    
    return true;
}



- (void)addSnapshotsToDBfor : (NSString *) screenname
                   fileName : (NSString *) filename
                 fileNameXS : (NSString *) filenameXS
                     onDate : (NSDate *) createddate
                   fileSize : (NSUInteger ) fileSize
                 fileSizeXS : (NSUInteger ) fileSizeXS
                   recordId : (NSUInteger) recordId
                     typeId : (NSInteger) eventTypeId{
    
    
    if ( !(filename) || !(createddate) || !(screenname) || !(fileSize) ||
         !(filenameXS)  || !(fileSizeXS)) {
    
        NSLog(@"**** One of following values not provided:  filename ondate screenname filesize etc.");
        
        return;
        
    }

        
    NSManagedObject *addRecord = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Snapshots"
                                      inManagedObjectContext:[self managedObjectContext]];
    [addRecord setValue:screenname forKey:@"screenname"];
    [addRecord setValue:filename forKey:@"filename"];
    [addRecord setValue:filenameXS forKey:@"filenamexs"];
    [addRecord setValue:createddate forKey:@"createdate"];
    [addRecord setValue:[NSNumber numberWithUnsignedInteger:fileSize] forKey:@"filesize"];
    [addRecord setValue:[NSNumber numberWithUnsignedInteger:fileSizeXS] forKey:@"filesizexs"];
    [addRecord setValue:[NSNumber numberWithUnsignedInteger: recordId] forKey:@"id"];
    [addRecord setValue:[NSNumber numberWithUnsignedInteger:eventTypeId] forKey:@"eventtype"];
    [addRecord setValue:@"local" forKey:@"status"];

        
        
    NSError *error;
        
    [[self managedObjectContext] save:&error];
        
   // NSLog(@"Records userid: %@ filename: %@ ondate: %@ added!", userid, filename, createddate);


        
   
}

- (void)addScreenToDBfor : (NSString *) screenName  {
    
    
    if (!(screenName) ) {
        
        NSLog(@"**** DB Insert: Screen Name can't be empty");
        
        return;
        
    }
    
    
    NSManagedObject *addRecord = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Screens"
                                  inManagedObjectContext:[self managedObjectContext]];
    [addRecord setValue:screenName forKey:@"screenname"];
    [addRecord setValue:@FALSE forKey:@"defaultflag"];

    NSError *error;
    
    [[self managedObjectContext] save:&error];
    
    // NSLog(@"Records userid: %@ filename: %@ ondate: %@ added!", userid, filename, createddate);
    
}


-(NSArray * ) getScreenListFromDB {
    
    

    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];

    [fetchRequest setEntity:screens];
    
//    NSPredicate * cond = [NSPredicate predicateWithFormat:@"  key = 'KeyUserUniqueId'  "];
    
//    [fetchRequest setPredicate:cond];
    
    
    NSError *error;
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];

    
    
    return fetchedObjects;
}

-(NSString * ) getDefaultScreenFromDB {

    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:screens];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"  defaultflag == TRUE  "]];
    
    NSError *error;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    NSString * result;
    
    if ([fetchedObjects count] > 0) {
    
        result = [fetchedObjects[0] valueForKey:@"screenname"];

    }
    
    //Will return NULL if there is no default in DB
    return result;
}


-(void) snapDeletedOnServer: (NSArray *) localids  {
   
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:snapshots];
    
    
    
    //NSLog(@"The array: %@", localids);
    //NSLog(@"Class: %@", localids[0]);
    
    for (NSString * deletedId in localids) {

        //NSLog(@"Deleting ID: %@", deletedId);
        
        NSPredicate * condition =  [NSPredicate predicateWithFormat:@"  id = %@  and status = 'deleted' ", deletedId];

        [fetchRequest setPredicate:condition];
        
        
        NSError *error;
        NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        
        for (NSManagedObject * record in fetchedObjects) {

            [[self managedObjectContext] deleteObject:record];
            [[self managedObjectContext] save:&error];
            [[self managedObjectContext] refreshObject:record mergeChanges:NO];
        }
    }
}

- (void) deleteSnapFile: (NSString *) fileName createDay: (NSString *) createDay {
    
    //Delete actual file
    [self deleteFileWithPath:[NSString stringWithFormat:@"%@/%@/%@", [[self snapshotsPathUrl] path], createDay, fileName]];

}

- (BOOL) deleteSnapshots: (NSPredicate * ) withCondition permanently: (BOOL) permanently {
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:snapshots];
    
    BOOL deleteActualFile;
    
    //local_snaps = [[self managedObjectModel] fetchRequestTemplateForName:@"local_snaps"];
    
    if (withCondition) {
        [fetchRequest setPredicate:withCondition];
    }

    
    NSError *error;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    //Loop and delete all
    for (NSManagedObject * record in fetchedObjects) {
        
        deleteActualFile = FALSE;

        NSString * createday = [dateFormatter stringFromDate:[record valueForKey:@"createdate"]];
        
        NSString * fileName = [record valueForKey:@"filename"];
        NSString * fileNameXS = [record valueForKey:@"filenamexs"];

        //Unconditional delete - Delete all
        if ((!withCondition)
            || (permanently) //We do not need it anymore
            //- If Local usage then delete
            //- If Cloud usage then wait for the upload
             || ([[record valueForKey:@"status"] isEqualToString:@"local"]
                     && !ifSignedUp)) {
                
            //If status is "local" then it's safe to delete
            //[[self managedObjectContext] deleteObject:record];
            [self updateFileDBStatus:fileName status:@"deleted" downloadSeq:0];
            deleteActualFile = TRUE;
            
        }
        //If it's already uploaded then set status to just remote
        else if ( [[record valueForKey:@"status"] isEqualToString:@"local/remote"]
                 ||
                 [[record valueForKey:@"status"] isEqualToString:@"downloaded"]) {
            
            [self updateFileDBStatus:fileName status:@"remote" downloadSeq:0];
            
            deleteActualFile = TRUE;
        }
        
        if ( deleteActualFile ) {
        
            //DELETE actual files
            [self deleteSnapFile:fileName createDay:createday];
            [self deleteSnapFile:fileNameXS createDay:createday];
            
        }

        [[self managedObjectContext] save:&error];
        [[self managedObjectContext] refreshObject:record mergeChanges:NO];
    }
    

    
    //Save DB

    
    
    return true;
    
}

- (BOOL) deleteAllSnapshotsFromDB {
    
    return [self deleteSnapshots:nil permanently:YES];
    
}


- (BOOL) deleteSnapshotsFromDBLessId: (NSUInteger) lessId {
    
    NSString * condition = ([self ifSignedUp])?@"  id <= %ld  and status != 'local' ":@"  id <= %ld";
    
    NSPredicate * predicate =  [NSPredicate predicateWithFormat:condition, lessId];
    
    return [self deleteSnapshots:predicate permanently:NO];
    
}

- (BOOL) deleteExpiredDownloadedSnapshots:(NSUInteger) downloadId {
    
    NSPredicate * condition =  [NSPredicate predicateWithFormat:@"  status = 'downloaded' and downloadseq = %ld ", downloadId];
    
    //NSLog(@"Deleting downloaded files with ID: %lu", (unsigned long)downloadId);
    
    return [self deleteSnapshots:condition permanently:NO];
    
}

- (BOOL) deleteAllDownloadedSnapshots {
    
    NSPredicate * condition =  [NSPredicate predicateWithFormat:@"  status = 'downloaded'  "];
    
    return [self deleteSnapshots:condition permanently:NO];
    
}

-(NSUInteger) findExpiryPoint {

    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:snapshots];
    
    NSUInteger storageAllowanceBytes = [self storageAllowance] * pow(1024, 3);
    
    //NSLog(@"Storage allowance:%ld", storageAllowanceBytes);
    
    NSError *error;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    NSUInteger minValidId = 0;
    NSUInteger aggSize = 0;

    
    for (NSManagedObject * record in fetchedObjects ) {
        
        aggSize += [[record valueForKey:@"filesize"] unsignedIntegerValue]
                    + [[record valueForKey:@"filesizexs"] unsignedIntegerValue];
        
        if (aggSize > storageAllowanceBytes) {
            
            //Starting point
            minValidId = [[record valueForKey:@"id"] unsignedIntegerValue];
            break;
        }
        
        //Clean core data memory
        [[self managedObjectContext] refreshObject:record mergeChanges:NO];
        
    }
    //NSLog(@"Used Storage sum:%ld", aggSize);
       
    return minValidId;
}


-(void ) setDefaultScreenInDB : (NSString *) screenName  {
    
    
    if (!(screenName) ) {
        
        NSLog(@"**** DB Insert: Screen Name can't be empty");
        
        return;
        
    }
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];

    [fetchRequest setEntity:screens];
    
//    NSPredicate * cond = [NSPredicate predicateWithFormat:@"  defaultflag = 'YES'  "];
    
//    [fetchRequest setPredicate:cond];
    
    
    NSError *error;
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];

    
    for (NSManagedObject *row in fetchedObjects) {
        

        
        NSString * sname = [row valueForKey:@"screenname"];
        
        if ([sname isEqualToString:screenName]) {
        
            [row setValue:@YES forKey:@"defaultflag"];
                 //NSLog(@"Default screen now is : %@", sname);
            
        } else
            if ([[row valueForKey:@"defaultflag"]  isEqual: @YES]) {
                
                [row setValue:@FALSE forKey:@"defaultflag"];
                                 //NSLog(@"Screen %@ is NOT default anymore", sname);
                
            }
        
    }
    
    [[self managedObjectContext] save:&error];
    

}

/*
- (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}
*/

-(void) updateSettingFromDBFor: (NSString *) settingName value: (NSString * ) value {
    
    
    //Exit if any param is null
    if ((!settingName) || (!value)) {
        
        NSLog(@"Setting key or value can't be null!");
        
        return;
        
    }
    
    if ([[self getSettingFromDBFor:settingName] isEqualToString:value]) {
        //Do notthing. Values are equal
        return;
        
    }
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:settings];
    
    NSPredicate * cond = [NSPredicate predicateWithFormat:@"  key == %@  ", settingName];
    [fetchRequest setPredicate:cond];
    
    
    NSError *error;

    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] > 0 ) {
        
        NSManagedObject *setting = fetchedObjects[0];
        
        [setting setValue:value forKey:@"value"];
        
        //NSLog(@"Updating settingName: %@=%@",settingName, value);
        
        //Save DB
        [[self managedObjectContext] save:&error];
        
    }
}

-(void) updateFileDBStatus: (NSString * ) fileName status: (NSString * ) status downloadSeq: (NSInteger) downloadSeq {
    
    NSFetchRequest * fetchReq = [[NSFetchRequest alloc] init];
    [fetchReq setEntity:snapshots];
    
    NSPredicate * cond = [NSPredicate predicateWithFormat:@"  filename == %@  ", fileName];
    [fetchReq setPredicate:cond];
    
    
    NSError *error;
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchReq error:&error];
    
    if ([fetchedObjects count] > 0 ) {
        
        NSManagedObject *snapshot = fetchedObjects[0];
        
        [snapshot setValue:status forKey:@"status"];
        
        [snapshot setValue:[NSNumber numberWithInteger:downloadSeq] forKey:@"downloadseq"];
        
        //NSLog(@"Updating file status for file %@ to be: %@",fileName, status);
        
        //Save DB
        [[self managedObjectContext] save:&error];
        //******[[self managedObjectContext] reset];*******
    }
    
    
}

-(NSArray * ) getLocalSnapshots {
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:snapshots];
    
    NSPredicate * cond = [NSPredicate predicateWithFormat:@"  status == %@  ", @"local"];
    [fetchRequest setPredicate:cond];
    
    
    NSError *error;
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
    
    
}



-(void) addOrUpdateSettingToDBFor: (NSString * ) settingName value: (NSString * ) value {
  
    
    //Exit if any param is null
    if ((!settingName) || (!value)) {
        
        NSLog(@"Setting key or value can't be null!");
        
        return;
        
    }
    
    //Check if exist then update
    if ([self getSettingFromDBFor:settingName]) {
        
        [self updateSettingFromDBFor:settingName value:value];
        
        return;
        
    }
    
    
    //Add new record
    
    //Preare
    NSManagedObject *addRecord = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Settings"
                                  inManagedObjectContext:[self managedObjectContext]];
    [addRecord setValue:settingName forKey:@"key"];
    [addRecord setValue:value forKey:@"value"];
    
    
    //NSLog(@"Adding settingName: %@=%@",settingName, value);
    
    NSError *error;
    
    //Save DB
    [[self managedObjectContext] save:&error];
    

}

-(NSString * ) getSettingFromDBFor: (NSString *) settingName {
    
    
    //Exit if param is null
    if (!settingName) {
        
        NSLog(@"Setting key  can't be null!");
        
        return nil;
        
    }
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:settings];
    
    NSPredicate * cond = [NSPredicate predicateWithFormat:@"  key == %@  ", settingName];
    [fetchRequest setPredicate:cond];
    
    
    NSError *error;
    NSString * result;
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
   
    
    if ([fetchedObjects count] > 0 ) {
        
        NSManagedObject *setting = fetchedObjects[0];
    
        result = [setting valueForKey:@"value"];
        
    }
    
    return result;
}


/*
- (NSString *) generateAndSaveUserId {
    
    //Generate
    NSString * uid = [[NSUUID UUID] UUIDString];
    
    //Save
    [self addOrUpdateSettingToDBFor:@"KeyUserUniqueId" value:uid];


    return uid;
}*/


- (void) setSelectedSnapshotCount:(NSUInteger)selectedSnapshotCount {
    
    _selectedSnapshotCount = selectedSnapshotCount;
    
}


- (NSUInteger) selectedSnapshotCount {
    
    [self setSelectedSnapshotCount:[[self mImportedImages] count]];
    
    return _selectedSnapshotCount;
}


- (void) setUserId: (NSString *) userid {
    
    if (userid) {
        
        return;
    }
    
    _userId = userid;
    //Save in DB
    [self addOrUpdateSettingToDBFor:@"KeyUserUniqueId" value:userid];

}


- (NSString *) getUserId {
  
    if (!_userId) {
        
        _userId = [self getSettingFromDBFor:@"KeyUserUniqueId"];
    }
    
    return _userId;
}




//Getter method for cloudUserName
- ( NSString * ) cloudUserName {
    
    if (!_cloudUserName) {
        
        NSString * valFromDb = [self getSettingFromDBFor:@"KeyCloudUserName"] ;
        
        if (valFromDb) {
            
            [self setCloudUserName:valFromDb];
            
        } else _cloudUserName = @"";
        
    }
    
    return _cloudUserName;
}


//Setter method for cloudUserName
- (void) setCloudUserName:(NSString *)cloudUserName {
    
    if ( cloudUserName == nil) {
        
        return ;
    }
    
    [self addOrUpdateSettingToDBFor:@"KeyCloudUserName" value:cloudUserName];
    
    _cloudUserName = cloudUserName;
    
}



//Getter method for cloudPassword
- ( NSString * ) cloudPassword {
    
    if (!_cloudPassword) {
        
        NSString * valFromDb = [self getSettingFromDBFor:@"KeyCloudPassword"] ;
        
        if (valFromDb) {
            
            [self setCloudPassword:valFromDb];
            
        } else _cloudPassword = @"";
        
    }
    
    return _cloudPassword;
}


//Setter method for cloudPassword
- (void) setCloudPassword:(NSString *)cloudPassword {
    
    if ( cloudPassword == nil) {
        
        return ;
    }
    
    [self addOrUpdateSettingToDBFor:@"KeyCloudPassword" value:cloudPassword];
    
    _cloudPassword = cloudPassword;
    
}

//Setter method for recordingStatus
- (void) setRecordingStatus:(NSRecordingStatus)recordingStatus {
    
    [self addOrUpdateSettingToDBFor:@"KeyRecordingStatus" value:[NSString stringWithFormat:@"%ld", (long)recordingStatus]];
    
    _recordingStatus = recordingStatus;
    
}


//Getter method for recordingStatus
- ( NSRecordingStatus ) recordingStatus {
    
    return _recordingStatus;
}



//Getter method for storageAllowance
- ( NSInteger ) storageAllowance {
    
    return _storageAllowance;
    
}


//Setter method for storageAllowance
- (void) setStorageAllowance:(NSInteger) storageAllowance {
    
    if ( storageAllowance < 0 || storageAllowance > 10) {
        
        return ;
    }
    
    [self addOrUpdateSettingToDBFor:@"KeyStorageAllowance" value:[NSString stringWithFormat:@"%ld", (long)storageAllowance] ];
    
    _storageAllowance = storageAllowance;
    
}

- (void) setSnapshotTakingInterval:(NSInteger )snapshotTakingInterval{
    
    //Save in DB
    [self addOrUpdateSettingToDBFor:@"KeySnapshotTakingInterval" value:[NSString stringWithFormat:@"%ld", (long)snapshotTakingInterval]];
    
    _snapshotTakingInterval = snapshotTakingInterval;
    
}


- (NSInteger ) snapshotTakingInterval {
    
    return _snapshotTakingInterval;
}


- (void) setSnapshotQuality: (NSNumber *) snapshotQuality {
    

    if ( !snapshotQuality ) {
        
        return;
    }

    //Save in DB
    [self addOrUpdateSettingToDBFor:@"KeySnapshotQuality" value:[NSString stringWithFormat:@"%@", snapshotQuality]];

//    NSLog(@"%@", [NSString stringWithFormat:@"%@", snapshotQuality]);
    
    _snapshotQuality = snapshotQuality;    
    
}


- (NSNumber *) snapshotQuality {
    
    return _snapshotQuality;
}



- (NSString * ) getEventFilterPredicateFor: (NSButton * ) sender {
    
    NSString * res = @"";
    
    if ([sender state] == NSOffState) {
        
        res = [NSString stringWithFormat:@" or eventtype = %ld", [sender tag]];
    }
    
    return res;
}

- (NSString *) getEventFilterPredicates {
    
    NSString * res = [NSString stringWithFormat:@"%@%@%@%@%@",
                      [self getEventFilterPredicateFor:leftClickFilterButton],
                      [self getEventFilterPredicateFor:rightClickFilterButton],
                      [self getEventFilterPredicateFor:scrollWheelFilterButton],
                      [self getEventFilterPredicateFor:timerFilterButton],
                      [self getEventFilterPredicateFor:manualFilterButton]];
    
#ifdef DEBUG
    NSLog(@"RES:%@", res);
#endif
    return ([res length]>0)?[res substringFromIndex:4]:nil;
}

//Select ranged records from db

- (NSArray * ) getSnapshotFileList: (NSDate *) _dateFrom  to: (NSDate *) _dateTo screen: (NSString *) _screenName {
    
    if (!(_dateFrom) || !(_dateTo) || !_screenName) {
        return nil;
    }
        
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:snapshots];
    //fetchRequest = [[self managedObjectModel] fetchRequestTemplateForName:@"local_snaps"];
    
    NSString *  filterStr;
    
    if ( [_screenName isEqualToString:@"All screens"] ) {
        
        filterStr = @"createdate >= %@ and createdate <= %@ and status != \"deleted\" ";//and (status = \"local\" or status = \"local/remote\" )
        
    } else {
    
        filterStr = @"createdate >= %@ and createdate <= %@  and screenname = %@ and status != \"deleted\"";
    
    }
    
    //Get all event button tags as AND AND AND etc.
    NSString * buttonFilters = [self getEventFilterPredicates];
    if (buttonFilters) {
        filterStr = [NSString stringWithFormat:@"%@ and (%@)", filterStr, buttonFilters];
    }

#ifdef DEBUG
    NSLog(@"SQL:%@", filterStr);
#endif
    
    //Add filter condition
    NSPredicate * cond = [NSPredicate predicateWithFormat:filterStr, _dateFrom, _dateTo, _screenName];

    //Define sorting as well
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    //NSLog(@"dtfrom %@ dtto %@, screen=%@", _dateFrom, _dateTo, _screenName);

    [fetchRequest setPredicate:cond];
    
    
    NSError *error;
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
        
        
}



- (NSDate *) getMinMaxSnapshotDates : (NSString * ) minORmax {

    NSDate * returnDate;
    
    if (!([minORmax isEqualToString:@"max"]) && !([minORmax isEqualToString: @"min"])) {
    
        return nil;
        
    }
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];

    [fetchRequest setEntity:snapshots];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    
    NSExpression *date = [NSExpression expressionForKeyPath:@"createdate"];
    NSExpression *mDate = [NSExpression expressionForFunction:[minORmax stringByAppendingString:@":"]
                                                      arguments:[NSArray arrayWithObject:date]];
    NSExpressionDescription *d = [[NSExpressionDescription alloc] init] ;
    [d setName:@"mDate"];
    [d setExpression:mDate];
    [d setExpressionResultType:NSDateAttributeType];
    
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:d]];
    
    NSError *error = nil;
    NSArray *objects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
    
    
    if (objects == nil) {
        // Handle the error.
    } else {
        
        if (objects.count > 0) {
        
            returnDate = [[objects objectAtIndex:0] valueForKey:@"mDate"];
            
        }

    }
    
    
    return returnDate;
    
}




- (NSUInteger  ) getTotalSnapshotCount {
   
    NSNumber *  recordCount;
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:snapshots];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    
    //select COUNT(id) where status != 'deleted'
    NSExpression *id = [NSExpression expressionForKeyPath:@"id"];
    NSExpression *countExp = [NSExpression expressionForFunction:@"count:"
                                                    arguments:[NSArray arrayWithObject:id]];
    NSExpressionDescription *d = [[NSExpressionDescription alloc] init] ;
    [d setName:@"recordCount"];
    [d setExpression:countExp];
    [d setExpressionResultType:NSInteger64AttributeType];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:d]];

    //Add filter
    NSPredicate * condition =  [NSPredicate predicateWithFormat:@"status != 'deleted' "];
    [fetchRequest setPredicate:condition];
    
    NSError *error = nil;
    NSArray *objects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
    
    if (objects == nil) {
        
        return 0;
        
    } else {
        
        if (objects.count > 0) {
            
            recordCount =  [[objects objectAtIndex:0] valueForKey:@"recordCount"];
            
        }
        
    }
    
    
    return [recordCount unsignedIntegerValue];
    
}



- (NSUInteger  ) getTotalSnapshotSize {
    
    NSNumber *  totalSize;
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:snapshots];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    
    
    NSExpression *filesize = [NSExpression expressionForKeyPath:@"filesize"];
    NSExpression *countExp = [NSExpression expressionForFunction:@"sum:"
                                                       arguments:[NSArray arrayWithObject:filesize]];
    NSExpressionDescription *d = [[NSExpressionDescription alloc] init] ;
    [d setName:@"totalSize"];
    [d setExpression:countExp];
    [d setExpressionResultType:NSInteger64AttributeType];
    
    //[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:d]];
    
    NSExpression *filesizeXS = [NSExpression expressionForKeyPath:@"filesizexs"];
    NSExpression *countExpXS = [NSExpression expressionForFunction:@"sum:"
                                                       arguments:[NSArray arrayWithObject:filesizeXS]];
    NSExpressionDescription *dXS = [[NSExpressionDescription alloc] init] ;
    [dXS setName:@"totalSizeXS"];
    [dXS setExpression:countExpXS];
    [dXS setExpressionResultType:NSInteger64AttributeType];
    
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:d,dXS, nil]];
    
    NSError *error = nil;
    NSArray *objects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
    
    if (objects == nil) {
        
        return 0;
        
    } else {
        
        if (objects.count > 0) {
            
            totalSize = [NSNumber numberWithInteger: [[[objects objectAtIndex:0] valueForKey:@"totalSize"] integerValue]
                            + [[[objects objectAtIndex:0] valueForKey:@"totalSizeXS"] integerValue] ];
            
        }
        
    }
    
    
    
    
    return [totalSize unsignedIntegerValue];
    
}

- (NSUInteger) getMaxID {
    
    NSNumber * maxId;
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:snapshots];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    
    
    NSExpression *id = [NSExpression expressionForKeyPath:@"id"];
    NSExpression *countExp = [NSExpression expressionForFunction:@"max:"
                                                       arguments:[NSArray arrayWithObject:id]];
    NSExpressionDescription *d = [[NSExpressionDescription alloc] init] ;
    [d setName:@"maxid"];
    [d setExpression:countExp];
    [d setExpressionResultType:NSInteger64AttributeType];
    
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:d]];
    
    NSError *error = nil;
    NSArray *objects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
    
    
    if (objects == nil) {
        
        return 0;
        
    } else {
        
        if (objects.count > 0) {
            
            maxId =  [[objects objectAtIndex:0] valueForKey:@"maxid"];
            
        }
        
    }
    
    
    
    return [maxId unsignedIntegerValue];
    
}

- (NSUInteger) getFreeDiskSpaceInGb {
    
    NSFileManager * fm = [[NSFileManager alloc] init];
    
    NSError * error;
    
    NSDictionary * attributes = [fm attributesOfFileSystemForPath:@"/" error:&error];
    
    //NSNumber *totalSize = [attributes valueForKey:NSFileSystemSize];
    NSNumber *freeSpace = [attributes valueForKey:NSFileSystemFreeSize] ;
    
    return [freeSpace unsignedIntegerValue]/1024/1024/1024;
    
}


- (void) controlDiskSpaceUsage {
    
    
    if ([self getFreeDiskSpaceInGb] < 1 ) {
        
        NSLog(@"Disk is critically low!");
        NSLog(@"Snapshot taking suspended");
        
        [self showPopOverWithMessage:@"Free disk space is critically low! Snapshot taking SUSPENDED."];
        
        [self stopScreenCapture];
        
    }
    if ([self getFreeDiskSpaceInGb] < 1.3 ) {
        
        if (freeDiskSpaceMessageCounter < 4 ) {
        
            NSLog(@"Free disk space is getting low!");
            NSLog(@"Snapshot taking will be suspended when it's below 1Gb");
            NSLog(@"You can try clearing some data ");
            
            [self showPopOverWithMessage:@"Free disk space is running low! Snapshot taking will be suspended when it's below 1Gb. Concider clearing some data"];
            
            freeDiskSpaceMessageCounter++;
        
        }
    }
    
    
}


- (void) deleteFileWithPath : (NSString *) fileWithPath {
    
    NSError * error;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileWithPath]) {
    
        [[NSFileManager defaultManager] removeItemAtPath:fileWithPath error:&error];
    
    }
 /*   if (error.code != NSFileNoSuchFileError) {
        NSLog(@"%@", error);
    }*/
}


- (void) alertDidEnd:(NSAlert *)a returnCode:(NSInteger)rc contextInfo:(void *)ci {
    
    switch(rc) {
        case NSAlertSecondButtonReturn: {
            
            NSAlert *alert = [[NSAlert alloc] init] ;

            if ([self deleteAllSnapshotsFromDB]) {
                
                [alert setMessageText:@"All snapshots successfully deleted!"];
                
                //Reload image browser
                [self reloadData];
                [self setDefaultImage];
                
            } else {
                
                [alert setMessageText:@"Problem with deleting data"];
                
            }
            
            [alert runModal];

            break;
        }
            
        case NSAlertFirstButtonReturn:
            break;
        
    }
    
}

//Show message box to confirm deletion
- (void) checkIfSureToDeleteAll {
    
    NSAlert *alert = [[NSAlert alloc] init];
    /*+*/
    
    if (self.recordingStatus == NSRecordingStopped) {

        [windowSettings orderOut:self];//Auto hide
        
        
        [alert setMessageText:@"Are you sure to delete ALL snapshots?"];
        
        [alert addButtonWithTitle:@"Cancel"];
        [alert addButtonWithTitle:@"Delete All"];
        [alert beginSheetModalForWindow:window
                          modalDelegate:self
                         didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                            contextInfo:nil];
    } else {
        
        [alert setMessageText:@"Recording in progress. Stop it before doing this."];
        [alert runModal];
    }
}

//--------DB end--------------




//----These methods here to load an image into ImageView (big screen)
- (void)openImageURL: (NSURL*)url
{
    
    if (url) {
    
        

        


        
        // Do not use...
        //Lets use our own method for God sake :). Honestly, setImageWithURL method overrides background so lets use this one
        
        //[mImageView setImage:url];
        //[mImageView setNeedsDisplay:YES];
        
        //This does not cause warning generation but it load image not pretty
        //[[mImageView layer] setHidden:YES];
        /*
        CGImageRef          image = NULL;
        CGImageSourceRef    isr = CGImageSourceCreateWithURL( (__bridge CFURLRef)url, NULL);
        
        if (isr)
        {
            NSDictionary *options = [NSDictionary dictionaryWithObject: (id)kCFBooleanTrue  forKey: (id) kCGImageSourceShouldCache];
            image = CGImageSourceCreateImageAtIndex(isr, 0, (__bridge CFDictionaryRef)options);
            
            if (image)
            {
                _imageProperties = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(isr, 0, (__bridge CFDictionaryRef)_imageProperties));
                
                _imageUTType = (__bridge NSString*)CGImageSourceGetType(isr);
            }
            CFRelease(isr);
            
        }
        
        if (image)
        {
            [mImageView setImage: image
                 imageProperties: _imageProperties];
            
            CGImageRelease(image);
            
        }*/
        
        //[mImageView layer] setNeedsDisplay];
        //[mImageView setNeedsDisplay:YES];
        
        
        //Everything happens in layerDelegate
        [imageSubLayer setNeedsDisplay];
#ifdef DEBUG
        NSLog(@"Open image Called");
#endif
        
    }
 

}


- (void) reloadCurrentImage {
    
    [self loadImage:currentLoadedImageURL];
}

- (void)loadImage: (NSURL *)url
{
    
    if (url) {

        [self setCurrentLoadedImageURL:url];
        
        [self openImageURL: url];

    }

}


//----end----


//----Initialize the app

- ( void ) setDeviceUUID {
    
    _deviceUUID = [[NSUUID UUID] UUIDString];
    
    [self addOrUpdateSettingToDBFor:@"DeviceID" value:_deviceUUID];

}

- ( NSString * ) deviceUUID {
    
    if (!_deviceUUID ) {
        
        _deviceUUID = [self getSettingFromDBFor:@"DeviceID"];

        if (!_deviceUUID) {
            
            [self setDeviceUUID];
            
        }
    }
    
    return _deviceUUID;
}

- (NSURL * ) getHostname {
    
    
    //Web access
    //return [NSURL URLWithString:@"http://snaps.duckdns.org"];
    //return [NSURL URLWithString:@"http://snapshooter.dtdns.net"];

    //Home server
    //return [NSURL URLWithString:@"https://192.168.1.101:8443"];
    
    //OpenShift
    return [NSURL URLWithString:@"https://snaps-snapshooter.rhcloud.com"];
    
    //MacBook Air
    //return [NSURL URLWithString:@"http://localhost:8080"];
    
}

//Getter method for rightClickCapture
- (BOOL ) rightClickCapture {
    
    return _rightClickCapture;
    
}

//Setter method for rightClickCapture
- (void) setRightClickCapture:(BOOL)rightClickCapture {
    
    [self addOrUpdateSettingToDBFor:@"RightClickCapture" value:(rightClickCapture?@"YES":@"NO")];
    _rightClickCapture = rightClickCapture;
    
}

//Getter method for leftClickCapture
- (BOOL ) leftClickCapture {
    
    return _leftClickCapture;
    
}


//Setter method for leftClickCapture
- (void) setLeftClickCapture:(BOOL)leftClickCapture {
    
    [self addOrUpdateSettingToDBFor:@"LeftClickCapture" value:(leftClickCapture?@"YES":@"NO")];
    _leftClickCapture = leftClickCapture;
    
}

//Getter method for wheelCapture
- (BOOL ) wheelCapture {
    
    return _wheelCapture;
    
}


//Setter method for wheelCapture
- (void) setWheelCapture:(BOOL)wheelCapture {
    
    [self addOrUpdateSettingToDBFor:@"WheelCapture" value:(wheelCapture?@"YES":@"NO")];
    _wheelCapture = wheelCapture;
    
}


//Getter method for keyCapture
- (BOOL ) keyCapture {
    
    return _keyCapture;
    
}


//Setter method for keyCapture
- (void) setKeyCapture:(BOOL)keyCapture {
    
    [self addOrUpdateSettingToDBFor:@"KeyCapture" value:(keyCapture?@"YES":@"NO")];
    _keyCapture = keyCapture;
    
}


//Getter method for mImportedImages
- (NSArray * ) mImportedImages {
    
    return _mImportedImages;
    
}

- (NSInteger) getMaxImportedImageId {
    
    NSInteger result = [[[self mImportedImages] firstObject] imageId];
    
    for (KMImageObject *image in [self mImportedImages]) {
        
        result = (result<image.imageId?image.imageId:result);
        
    }
    
    return result;
    
}

- (NSInteger) getMinImportedImageId {
    
    NSInteger result = [[[self mImportedImages] firstObject] imageId];
    
    for (KMImageObject *image in [self mImportedImages]) {
     
        result = (result>image.imageId?image.imageId:result);
        
    }
    
    return result;
    
}

//Setter method for mImportedImages
- (void) setMImportedImages:(NSArray *)fileList {
    
    //Check if it's not null
    if ( !fileList ) {
        
        return ;
        
    }
    
    
    NSMutableArray * imageFileList = [NSMutableArray new];
    
    //Convert ManagedObject record to Im Populate array
    for (NSManagedObject *file in fileList) {
        
        KMImageObject * anImage = [self convertToImageFile:file];
        
        
        [imageFileList addObject:anImage];
        
        [[self managedObjectContext] refreshObject:file mergeChanges:NO];
    }
    
    
    _mImportedImages = imageFileList;
    
}

//Getter method for downloadCounter
- (int ) currentDownloadCounter {
    
    return _downloadCounter;
    
}

//Setter method for downloadCounter
- (int ) nextDownloadCounter {
    
    if (_downloadCounter == 3) {
        
        //Reset
        _downloadCounter = 0;
        
    } else {
        
        _downloadCounter++;
        
    }
    
    return _downloadCounter;
}

//Getter method for nextSequenceId
- (NSUInteger ) nextSequenceId {
    
    if (_nextSequenceId == 0) {
        
        //First time get it from DB
        _nextSequenceId = [self getMaxID];
        
    }
    
    return ++_nextSequenceId;
    
}

//Setter method for nextSequenceId
- (void) setNextSequenceId:(NSUInteger) nextSequenceId {
    
    _nextSequenceId = nextSequenceId;
    
}

//Getter method for currentPeriodSelection
- (NSPeriodSelection ) currentSelection {
    
    if (!_currentPeriodSelection) {
        
        //Set default selection to All
        [self setCurrentSelection:NSPeriodSelectionAll];
        
        [self setPreviousPeriodSelection:NSPeriodSelectionNothing];
        
    }
    
    
    return _currentPeriodSelection;
    
}

//Setter method for currentPeriodSelection
- (void) setCurrentSelection:(NSPeriodSelection ) currentSelection {
    
    if ( currentSelection  < 0 ) {
        
        return ;
    }
    
    [self setPreviousPeriodSelection:_currentPeriodSelection];
    
    _currentPeriodSelection = currentSelection ;
    
}

//Setter method for defaultScreen
- (void) setDefaultScreen:(NSString *) screen {
    
    if (!screen) {
        
        return ;
    }
    
    [self setDefaultScreenInDB:screen];
    
    _defaultScreen = screen;
    
}


//Getter method for defaultScreen
- (NSString * ) defaultScreen {
    
    NSString * screen;
    
    if (!_defaultScreen) {
        
        
        screen =  [self getDefaultScreenFromDB];        
        
        if (!screen) {
            
            screen = @"All screens";
 
        }

         [self setDefaultScreen:screen ];
        
    }
    
    
    return _defaultScreen;
    
}


//Setter method for dateFromMinGlobal
- (void) setDateFromMinGlobal:(NSDate *) date {
    
    _dateFromMinGlobal = date;
    
}

//Getter method for dateFromMinGlobal
- (NSDate*) dateFromMinGlobal {
    
    if (!_dateFromMinGlobal) {
        //Assign default date if there is no record in DB
        NSDate * minDate = [self getMinMaxSnapshotDates:@"min"];
        [self setDateFromMinGlobal: (!minDate?defaultDate:minDate) ];
    
    }
    

    return _dateFromMinGlobal;
    
}

//Setter method for dateToMaxGlobal
- (void) setDateToMaxGlobal:(NSDate *) dateToMaxGlobal {
    
    _dateToMaxGlobal = ((!dateToMaxGlobal) ? _dateFromMinGlobal : dateToMaxGlobal);
    
}

//Getter method for dateFromMinGlobal
- (NSDate*) dateToMaxGlobal {

    //Maximum value keeps changing. So, select max directly
    //if it's not set then use default date
    NSDate * maxDate = [self getMinMaxSnapshotDates:@"max"];
    [self setDateToMaxGlobal: (!maxDate?defaultDate:maxDate) ];
    
    return _dateToMaxGlobal;
    
}


//Setter method for dateFromGlobal
- (void) setDateFromSelection:(NSDate *) date {
    
    _dateFromSelection = date;
    
}

//Getter method for dateFromGlobal
- (NSDate*) dateFromSelection {
    
    if (!_dateFromSelection) {
        
        _dateFromSelection = [self dateFromMinGlobal];
        
    }
    
    
    return _dateFromSelection;
    
}

//Setter method for dateToGlobal
- (void) setDateToSelection:(NSDate *) dateToGlobal {
    
    //Date To can't be more than MAX date in DB
    if ([_dateFromSelection isGreaterThan:[self dateToMaxGlobal]]) {
        
        _dateToMaxGlobal = [self dateToMaxGlobal];
        
        return;
    }
    
    _dateToSelection = dateToGlobal;
    
}

//Getter method for dateFromGlobal
- (NSDate*) dateToSelection {
    
    if (!_dateToSelection) {
        
        _dateToSelection = [self dateToMaxGlobal];
        
    }
    
    
    return _dateToSelection;
    
}

- (void) redefineSelectionDates {
    
    [self setDateFromSelection:[self dateFromMinGlobal]];
    [self setDateToSelection:[self dateToMaxGlobal]];
    
}

//Setter method for doubleSliderLoValue
- (void) setDoubleSliderLoValue:(NSNumber *) doubleSliderLoValue {
    
    _doubleSliderLoValue = doubleSliderLoValue;
    
}

//Getter method for doubleSliderLoValue
- (NSNumber*) doubleSliderLoValue {
    
    //[self setDoubleSliderLoValue:[doubleSlider leftKnobValue]];
    
    return _doubleSliderLoValue;
    
}


//Setter method for doubleSliderHiValue
- (void) setDoubleSliderHiValue:(NSNumber *) doubleSliderHiValue {
    
    _doubleSliderHiValue = doubleSliderHiValue;
    
}

//Getter method for doubleSliderHiValue
- (NSNumber*) doubleSliderHiValue {
    
    //self setDoubleSliderHiValue:[doubleSlider rightKnobValue]];
    
    return _doubleSliderHiValue;
    
}

-(NSURL *) snapshotsPathUrl {
    
    //NSLog(@"%@", _snapshotsPathUrl);

    if (_snapshotsPathUrl) {
        return _snapshotsPathUrl;
    }
        
    NSString* snapshotsDirName = @"SnapshotFiles";
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    
    _snapshotsPathUrl = [applicationFilesDirectory URLByAppendingPathComponent:snapshotsDirName];
    
    //Check if folder does't exists create it. It will be in the home directory with AppName
    if (![[NSFileManager defaultManager] fileExistsAtPath:[_snapshotsPathUrl path]]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[_snapshotsPathUrl path] withIntermediateDirectories:YES attributes:nil error:nil];
        
    }

    return _snapshotsPathUrl;

    
}

/*

- (void) loadSavedSnapshots {
    
    NSURL *      url;
    NSString* snapshotsDirName = @"TheSnapshooter";
    NSString* usersHomeDir  = NSHomeDirectory();
    NSString* snapshotsPath = [NSString stringWithFormat:@"%@/%@", usersHomeDir, snapshotsDirName];
    //outFolderPath = snapshotsPath;
    
    //Check if output folder does't exists create it. It will be in the home directory with AppName
    if (![[NSFileManager defaultManager] fileExistsAtPath:snapshotsPath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:snapshotsPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    
    url = [NSURL fileURLWithPath: snapshotsPath];
    
    [self addImagesWithPath:url recursive:NO];
    
}
 
 */

-(void) setImageToolTips {
    
    for (int i=0; i<[mImages count]; i++) {
        
        NSRect rect = [selectedImageBrowser itemFrameAtIndex:i];
        KMImageObject *image = [mImages objectAtIndex:i];
        
        [selectedImageBrowser addToolTipRect:rect owner:[image imageSubtitle] userData:(__bridge void *)(image)];
        
    }
    
}

- (KMImageObject * ) convertToImageFile: (NSManagedObject *) file {
 
    KMImageObject * anImage = [[KMImageObject alloc] init];
    
    //Constract directory path
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSString * createday = [dateFormatter stringFromDate:[file valueForKey:@"createdate"]];
    
    NSURL * imagePath = [[self snapshotsPathUrl] URLByAppendingPathComponent:createday isDirectory:TRUE];
    imagePath = [imagePath URLByAppendingPathComponent:[file valueForKey:@"filenamexs"]];
    //end
    
    
    //Populate one image object
    anImage.imagePath = [imagePath path];
    anImage.imageCreateDate = [file valueForKey:@"createdate"];
    anImage.imageCreateDay = createday;
    anImage.imageFileName = [file valueForKey:@"filename"];
    anImage.imageFileNameXS = [file valueForKey:@"filenamexs"];
    anImage.imageFileSize = [[file valueForKey:@"filesize"] integerValue];
    anImage.imageFileSizeXS = [[file valueForKey:@"filesizexs"] integerValue];
    anImage.imageScreenName = [file valueForKey:@"screenname"];
    anImage.imageSubtitle = [KMCommon  getReadibleDateStrFromDate:anImage.imageCreateDate];
    //@"blah balh";// [file valueForKey:@"filename"];
    anImage.imageId = [[file valueForKey:@"id"] integerValue];
    anImage.imageStatus = [file valueForKey:@"status"];
    
    return anImage;
}

- (KMImageObject * ) getImageFile: (NSString *) fileName {
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:snapshots];
    
    NSString *  filterStr;
    KMImageObject * afile;
    
    filterStr = @"filename = %@";
    
    //Add filter condition
    NSPredicate * cond = [NSPredicate predicateWithFormat:filterStr, fileName];
    
    [fetchRequest setPredicate:cond];
    
    
    NSError *error;
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
    if ([fetchedObjects count] > 0) {

        NSManagedObject *file = [fetchedObjects firstObject];
        
        afile = [self convertToImageFile:file];
        
    }
        
    
    
    
    return afile;
}


- (void) downloadImageIfneeded: (NSString *) fileName {
 

    KMImageObject * anImage = [self getImageFile:fileName];
    
    
    if ([[anImage imageStatus] isEqualToString: @"remote"]) {
        
        [self startProcessIndicator];
        
        [sessionDelegate downloadFile:anImage];
        
    }
    
}

- (void) downloadIfneeded: (NSArray *) fileList {

    //Check if internet/server available before proceeding
    if (!sessionDelegate.isInternetAvailable) {
        
        return;
    }
    
    //Stop data deletetion first! to avoid data access at the same time
    [self stopExpiryCleanSchedule];
    
    //Delete least previous download to free up the space
///    [self deleteExpiredDownloadedSnapshots: abs([self currentDownloadCounter]-2) ];
    //[self deleteExpiredDownloadedSnapshots: [self currentDownloadCounter] ];
    
    
    NSNumber * nextDownloadSequenceNullable;
    
    for (NSManagedObject *file in fileList) {
        
        if ([[file valueForKey:@"status"] isEqualToString:@"remote"]) {
            
            if (!nextDownloadSequenceNullable) {
                
                //We just need to increment value by 1 and set it for current download
                nextDownloadSequenceNullable = [NSNumber numberWithInt:[self nextDownloadCounter]];
                
            }
            
            KMImageObject * afile = [[KMImageObject alloc] init];
            
            afile.imageFileName = [file valueForKey:@"filename"];
            afile.imageFileSize = [[file valueForKey:@"filesize"] unsignedIntegerValue];
            //afile.downloadSeq = [self currentDownloadCounter];
            
            [sessionDelegate downloadFile:afile];
            
        }
        
    }
    
    //We can now Start data deletetion
    [self startExpiryCleanSchedule];
    
    
}


- (bool) checkIfAllDownloaded: (NSArray *) fileList {
    
    bool result = true;
    
    
    for (NSManagedObject *file in fileList) {
        
        if ([[file valueForKey:@"status"] isEqualToString:@"remote"]) {
            
            result = false;
            break;
            
            //NSLog(@"We need to download!");
        }
        
    }
    
    return result;
    
}



- (NSArray * ) loadSnapshotsFromDbForDatesFrom : (NSDate * ) fromDate toDate: (NSDate *) toDate screenName: (NSString *) screenName {
 
    
    if ( !(fromDate) || !(toDate) ) {
        
        return 0;
        
    }
    
    //Get list of files between given dates from DB
    NSArray * fileList = [self  getSnapshotFileList:fromDate to:toDate screen:screenName];
    
    //NSLog(@"fileList count: %lu", fileList.count);
    
    return fileList;
    
}

- (NSDate * ) getSelectedTableDate {
    
    NSDate * date;
    
    if ([self currentSelection] == NSPeriodSelectionDay
        &&
        [dateListTableDataSource numberOfRowsInTableView:dateListTableView] > 0
        &&
        [dateListTableView selectedRow] > -1 ) {
        
            NSString * dateStr = [[dateListTableDataSource getRow:[dateListTableView selectedRow] ] valueForKey:@"Date"] ;

            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            date = [dateFormat dateFromString:dateStr];
        
    }
    
    //NSLog(@"Selected date: %@", date);
    
    return date;
}

-(void) reloadData {
    
    #ifdef DEBUG
    NSLog(@"Reload Data!");
    NSLog(@"Current selection %ld", [self currentSelection]);
    #endif
    //Check that we are not trying to reload the same day
    //UNLESS it's today (recent data)
    if ([self currentSelection] == [self previousPeriodSelection]
        &&
        //If requested day is the same then forget about it :)
        [[self previousSelectionDay] isEqualToDate:[self getSelectedTableDate]]
         //[datePickerFrom dateValue]]
        &&
        //It's not the latest data reload
        [self currentSelection] != NSPeriodSelectionToday) {
        
        return;
        
    }

    
    switch ([self currentSelection]) {
            
        case NSPeriodSelectionAll:
            //All snapshots will be loaded
            
            //Use MIN/MAX to capture all
            [self reloadImageBrowserForDates:[self dateFromMinGlobal] dateTo:[self dateToMaxGlobal]];
            
            break;
            
        case NSPeriodSelectionToday:
            //Todays snapshots will be loaded
            [self reloadImageBrowserFor : @"Today" forDate:nil];
            break;
            
        case NSPeriodSelectionYesterday:
            //Yesterdays snapshots will be loaded
            [self reloadImageBrowserFor : @"Yesterday" forDate:nil];
            break;

        case NSPeriodSelectionDay:
            
            //Selected day snapshots will be loaded
            [self reloadImageBrowserFor : @"Day" forDate:[self getSelectedTableDate]];
             //[datePickerFrom dateValue]];
            
            [self setPreviousSelectionDay:[datePickerFrom dateValue]];

            break;
            
        case NSPeriodSelectionBefore:
            //Yesterdays snapshots will be loaded
            [self reloadImageBrowserFor : @"Before" forDate:nil];
            break;
            
/*        case NSPeriodSelectionRange:
            
            //All snapshots will be loaded
   
            [self reloadImageBrowserForDates:[datePickerFrom dateValue] dateTo:[datePickerTo dateValue]];
            
            break; */
            
        default:
            
            break;
            
            
    }
    
    
}

- (void) _startProgressBarIndicator {
    
     [progressBarIndicator startAnimation:self];
     [progressBarIndicator setHidden:NO];
    
}

- (void) showRecordingStatus {
    
    [mStatusView setHidden:NO];
    
}

- (void) hideRecordingStatus {
    
    [mStatusView setHidden:YES];
    
}

- (void) startProgressWindow {
    
    [progressIndicator startAnimation:progressWindow];
    [progressWindow orderFront:self];
    //[progressBarIndicator startAnimation:self];
    //[progressBarIndicator setHidden:NO];
    
}


- (void) stopProgressWindow {
    
    [progressWindow orderOut:self];
    //[progressIndicator stopAnimation:progressWindow];
    
}

- (void) startCounterWindow {
    //NSLog(@"panelDownloadCounter called");
    [panelDownloadCounter orderFront:self];
    
}

- (void) stopCounterWindow {
    
    [panelDownloadCounter orderOut:self];
    
}

//PROCCCCESSSSSSSS not PROGGGRESSSS
- (void) startProcessIndicator {
    
    [progressIndicator startAnimation:progressWindow];
    [progressWindow orderFront:self];
    //[progressBarIndicator startAnimation:self];
    //[progressBarIndicator setHidden:NO];
    
}

- (void) stopProcessIndicator {
    
    [progressWindow orderOut:self];
    [progressIndicator stopAnimation:progressWindow];
    
}

- (void) startProgressIndicator {

    [self hideRecordingStatus];
    [self _startProgressBarIndicator];
    
    //[progressIndicator startAnimation:progressWindow];
    //[progressWindow orderFront:self];
    //[progressBarIndicator startAnimation:self];
    //[progressBarIndicator setHidden:NO];

    
   // [self performSelector:@selector(hideRecordingStatus) withObject:self afterDelay:0 ];
   // [self performSelector:@selector(_startProgressIndicator) withObject:self afterDelay:0 ];

    
}


- (void) _stopProgressIndicator {
    
    //[progressWindow orderOut:self];
    //[progressIndicator stopAnimation:progressWindow];
    [progressBarIndicator stopAnimation:self];
    [progressBarIndicator setHidden:YES];
    
}

- (void) stopProgressIndicator {

    [self performSelector:@selector(_stopProgressIndicator) withObject:self afterDelay:0 ];
    
    if (self.recordingStatus == NSRecordingStarted) {
    
        [self performSelector:@selector(showRecordingStatus) withObject:self afterDelay:0 ];

        
    }
    

}

-(void) reloadImageBrowserForDates: (NSDate *) dateFrom dateTo: (NSDate *) dateTo {
    
    #ifdef DEBUG
    NSLog(@"Debug: Reload imageBrowser for dates %@ %@", dateFrom, dateTo);
    #endif
    
    if ((dateFrom) && (dateTo)) {
        
        [self setDateFromSelection:dateFrom];
        [self setDateToSelection:dateTo];
        
        [self setupDoubleSlider];
        [self reloadImageBrowser];

        [self performSelector:@selector(loadDoubleSlider) withObject:self afterDelay:1 ];
        // [self loadDoubleSlider];

    }
    
    
}

//*******Rewrite and make it like addMinutes and use that func for seperate calls
- (void) calculateDatesFromLoHi: (NSNumber * ) loValue hivalue: (NSNumber *) hiValue
                       fromdate: (NSDate **) fromDate  todate: (NSDate **) toDate {
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    [comps setMinute:(long)[loValue integerValue]];
    *fromDate = [gregorian dateByAddingComponents:comps toDate:[self dateFromSelection] options:0 ];
    
    [comps setMinute:(long)[hiValue integerValue]];
    *toDate = [gregorian dateByAddingComponents:comps toDate:[self dateFromSelection] options:0 ];
    
    
}


- (void) reloadImageBrowserFor: (NSString * ) day forDate: (NSDate *) date {
    
    NSDate * selectedDay;
    NSCalendar * gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    //Exit if not correct value supplied

    if (!([day isEqualToString:@"Today"])
        && !([day isEqualToString:@"Yesterday"] )
        && !([day isEqualToString:@"Before"] )
        && !([day isEqualToString:@"Day"] )) {
        
        return ;
        
    }
           
    if (date) {
        
        selectedDay = date;
        
    } else {
        
        selectedDay = [[NSDate alloc] init];
    
    }

    NSDateComponents *truncateDateComp = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit
                                                     fromDate:selectedDay];

    NSDateComponents * oneDay = [[NSDateComponents alloc] init];

    NSDate *dtfrom;
    NSDate *dtto;
    


    if ([day isEqualToString:@"Today"]
            || [day isEqualToString:@"Day"]) {
        
        dtfrom = [gregorian dateFromComponents:truncateDateComp ];
        
        [oneDay setDay:1];
        
        dtto = [gregorian dateByAddingComponents:oneDay toDate:dtfrom options:0];
        
    } else if ([day isEqualToString:@"Yesterday"]) {
        
       dtto = [gregorian dateFromComponents:truncateDateComp ];
       
       [oneDay setDay:-1];
       dtfrom = [gregorian dateByAddingComponents:oneDay toDate:dtto options:0];
       
    } else {

        dtto = [gregorian dateFromComponents:truncateDateComp ];
        
        [oneDay setDay:-2];
        dtfrom = [gregorian dateByAddingComponents:oneDay toDate:dtto options:0];
        
        

        
        [oneDay setDay:-1];
        
        dtto = [gregorian dateByAddingComponents:oneDay toDate:dtto options:0];
        

    }
    
    #ifdef DEBUG
    NSLog(@"Reload image browser for:%@", day);
    #endif
    
    [self reloadImageBrowserForDates:dtfrom dateTo:dtto];
    
}



-(void) addRightView {

    mNextViewNavigation = nextHolderView;
    
    if (![mNextViewNavigation isDescendantOf:mMiddleView]) {

        [mNextViewNavigation removeFromSuperview];
        
    }
    
    [mMiddleView addSubview:mNextViewNavigation positioned:NSWindowAbove relativeTo:nil];
    [mNextViewNavigation setHidden:NO];
    
}

-(void) addLeftView {

    mBackViewNavigation = backHolderView;
    
    
    if (![mBackViewNavigation isDescendantOf:mMiddleView]) {

        [mBackViewNavigation removeFromSuperview];
        
    }
    
    
    [mMiddleView addSubview:mBackViewNavigation positioned:NSWindowAbove relativeTo:nil];
    
    [mBackViewNavigation setHidden:NO];
    
}

-(void) addPopupUserMenuView {
    
#ifdef DEBUG
    NSLog(@"Show Filter panel");
#endif
    //if ([mFilterPanelView isDescendantOf:mMiddlePanel]) {

        [mFilterPanelView removeFromSuperview];
        
    //}
    
    //[mMiddleView addSubview:mPopupUserMenu positioned:NSWindowAbove relativeTo:nil];
    [mMiddlePanel addSubview:mFilterPanelView positioned:NSWindowAbove relativeTo:nil];

    //[mFilterPanelView setHidden:NO];
    //[[mFilterPanelView animator] setAlphaValue:1.0f];
    //NOTE: Animation property is set in the Core Animatio panel of the Inspector panel (look for fade option)
    [NSAnimationContext beginGrouping];
    // Animate enclosed operations with a duration of 1 second
    [[NSAnimationContext currentContext] setDuration:1.0];
    [[mFilterPanelView  animator] setHidden:NO];
    
    [NSAnimationContext endGrouping];


    
}

-(void) removeFilterUserMenuView {
    
    //[[mFilterPanelView animator] setAlphaValue:0.0f];
    
    [NSAnimationContext beginGrouping];
    // Animate enclosed operations with a duration of 1 second
    [[NSAnimationContext currentContext] setDuration:1.0];
    [[mFilterPanelView  animator] setHidden:YES];
    
    [NSAnimationContext endGrouping];
    
}

-(void) removeRightView {
    
    if ([mNextViewNavigation isDescendantOf:mMiddleView]) {
        
        [mNextViewNavigation setHidden:YES];
        
    }
    
}


-(void) removeLeftView {
    
    if ([mBackViewNavigation isDescendantOf:mMiddleView]) {
        
        [mBackViewNavigation setHidden:YES];
        
    }
    
}



- (void) retainNavigationViewsState {
    
    nextHolderView = mNextViewNavigation;
    backHolderView = mBackViewNavigation;
    popupUserMenuView = mPopupUserMenu;
    
}

- (void) setDefaultImage {
    
    [self loadImage:[[[KMCommon alloc] init] getInternalImageURL:@"snap_front.png"]];

}

- (void) setupDoubleSlider {
    
    NSTimeInterval secondsDiffirence = [[self dateToSelection] timeIntervalSinceDate:[self dateFromSelection] ];
    NSUInteger  minutesDiffirence =  ceil(secondsDiffirence/60);
    
    
//    [doubleSlider setMaxValue:minutesDiffirence];
//    [doubleSlider setMinValue:0];
    
//    [doubleSlider setIntegerHiValue:minutesDiffirence];
//    [doubleSlider setIntegerLoValue:0];
    
    [self setDoubleSliderLoValue:[NSNumber numberWithDouble:0]];
    [self setDoubleSliderHiValue:[NSNumber numberWithDouble:minutesDiffirence]];
}
    
- (void) loadDoubleSlider {
    

    NSPoint tempPoint;
    NSMutableArray * pointsArr = [NSMutableArray array] ;
    NSTimeInterval secondsDiffirence;
    NSUInteger minutesFromDt;
    NSInteger prevMinutesFromDt = -1;

    //minutesFromDt =  secondsDiffirence/60;

    //NSLog(@"Total minutesFromDt:%lu", minutesFromDt);
    //NSLog(@"FileRecCount:%lu", [self mImportedImages].count);

    NSInteger idx = -1;
    
    //pointsArr = [pointsArr initWithCapacity:minutesFromDt+1];
    
    
    for (KMImageObject *file in [self mImportedImages]) {
            
        //NSDate * createDate = [fileRec valueForKey:@"createdate"];
        
     //   NSLog(@"From - to date:%@, %@", createDate, [self dateFromSelection]);

        secondsDiffirence = [file.imageCreateDate timeIntervalSinceDate:[self dateFromSelection] ];

        minutesFromDt =  secondsDiffirence/60;
        //NSLog(@"minutesFromDt:%lu", minutesFromDt);
        //NSLog(@"PointArrCount %lu", pointsArr.count);
        
        if (prevMinutesFromDt != minutesFromDt) {
        //if (pointsArr[minutesFromDt] == [NSNull null]) {
            idx++;
            //NSLog(@"Inserting %lu at %lu", (unsigned long)minutesFromDt, idx);
            [pointsArr insertObject:[NSValue valueWithPoint:NSMakePoint(minutesFromDt, 1)] atIndex:idx];
            prevMinutesFromDt = minutesFromDt;

        } else {
            
            tempPoint = [(NSValue *)pointsArr[idx] pointValue];
            
            tempPoint.y = tempPoint.y+1;

            [pointsArr replaceObjectAtIndex:idx withObject:[NSValue valueWithPoint:tempPoint] ];
            //NSLog(@"Replacing %lu at %lu", (unsigned long)minutesFromDt, idx);
            
  
        }

        //break;
    }
    
    
    [doubleSlider setGraphArray:pointsArr];
    //NSLog(@"pointsArr count %lu", pointsArr.count);
}


- (void) setupSettingWindow {
    
    NSRect settingWinRect = [windowSettings frame];
    
    settingWinRect.size.width = 480;
    settingWinRect.size.height = 400;
    settingWinRect.origin.y = window.frame.size.height/2;
    
    [windowSettings setFrame:settingWinRect display:YES];
    
    [textFieldUsername setStringValue:[self cloudUserName]];
    [textFieldPassword setStringValue:[self cloudPassword]];
    
    [stepperSnapshotTakingInterval setIntegerValue:[self snapshotTakingInterval]];
    [self stepperSnapshotIntervalClicked:stepperSnapshotTakingInterval];
    
    [labelPrefDiskSpace     setStringValue: [NSString stringWithFormat:@"%ldGb", [self storageAllowance]]];
    [sliderForDiskAllowance setIntegerValue:[self storageAllowance]];
    [sliderForQuality setFloatValue:[[self snapshotQuality] floatValue]];
    
    [checkLeftClickCapture  setState:[self leftClickCapture]];
    [checkRightClickCapture setState:[self rightClickCapture]];
    [checkWheelClickCapture setState:[self wheelCapture]];
    [checkKeyCapture        setState:[self keyCapture]];
    
    NSTabViewItem * captureTab = [[NSTabViewItem alloc] init];
    NSTabViewItem * storageTab = [[NSTabViewItem alloc] init];
    NSTabViewItem * qualityTab = [[NSTabViewItem alloc] init];
    NSTabViewItem * cloudTab   = [[NSTabViewItem alloc] init];
    
    [captureTab setView:captureTabView];
    [captureTab setLabel:@"Capture"];
    [storageTab setView:storageTabView];
    [storageTab setLabel:@"Storage"];
    [qualityTab setView:qualityTabView];
    [qualityTab setLabel:@"Quality"];
    [cloudTab setView:cloudTabView];
    [cloudTab setLabel:@"Cloud"];
    
    [settingsTabView addTabViewItem:captureTab];
    [settingsTabView addTabViewItem:storageTab];
    [settingsTabView addTabViewItem:qualityTab];
    //[settingsTabView addTabViewItem:cloudTab];
    
    //[windowSettings setBackgroundColor:backgrounColor];
    
    StartAtLoginController *loginController = [[StartAtLoginController alloc] initWithIdentifier:autoLauncherIdentifier];
    
    
    [checkAutoStart setState:[loginController startAtLogin]];
    
}

- (void) setupAppearence {
    
    NSColor * satan = [[[KMCommon alloc] init] getColorfromHex: @"2a1111"];
    backgrounColor = satan;
    
    [mImageView layer].backgroundColor = CGColorRetain(satan.CGColor);
    [[mImageView layer] setNeedsDisplay];
    [[mImageView layer] display];
    
    //ImageBrowsers
    [mImageBrowser setContentResizingMask:NSViewWidthSizable ];
    [mImageBrowser2 setContentResizingMask:NSViewHeightSizable ];

    
    //Setting Window
    [self setupSettingWindow];
    //--------------------
    
    //Progress indicator
    [progressWindow setOpaque:NO];
    [progressWindow setBackgroundColor:[NSColor clearColor]];
    [progressView setWantsLayer:YES];
    [progressView.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
    //--------------------
    
    
    //Double slider
    [doubleSlider setBackgroundColor:satan];
    [doubleSlider setLineColor:[NSColor blackColor]];
    [doubleSlider setGraphColor:[NSColor cyanColor]];
    //---------------------
    
    //Apple bar menu
    [self setUpAppleBarMenu];
    //---------------------
    
    //Reocrding image
    [mRecordingView setImageWithURL: [[[KMCommon alloc] init] getInternalImageURL:@"recording.png"]];
    //Hide these objects
    [self hideRecordingStatus];
    //---------------------
    
    //Setup filter panel
    //[[mFilterPanelView layer] setCornerRadius:5.0f];
    [[mFilterPanelView layer] setBackgroundColor:[satan colorWithAlphaComponent:0.7].CGColor];
    //CGColorRetain([NSColor colorWithCalibratedRed:42 green:17 blue:17 alpha:0.5].CGColor)];
    [[mFilterPanelView layer] setBorderWidth:0.3f];
    [[mFilterPanelView layer] setBorderColor:[[NSColor whiteColor] CGColor]];
    [[mFilterPanelView layer] setMasksToBounds:YES];
    
    
    //Gallery switch button
    [butSwitchLoyout setImage:[NSImage imageNamed:@"single.png"] forSegment:0];
    [butSwitchLoyout setImage:[NSImage imageNamed:@"grid.png"] forSegment:1];
    [butSwitchLoyout setImageScaling:NSImageScaleProportionallyUpOrDown forSegment:0];
    [butSwitchLoyout setImageScaling:NSImageScaleProportionallyUpOrDown forSegment:1];
    
    //Setting front image
    [self setDefaultImage];
    
    //Initialize image DataSource
    mImages = [[NSMutableArray alloc] init];
    
    //During development we see Gallery panel. So hide it during load
    [self hideLeftScrollView];
    [self adjustMiddlePanel];
    [mBottomPanelView setHidden:YES];
    
    //Set up navigation views
    [self retainNavigationViewsState];
    
    [self removeLeftView];
    [self removeRightView];
    //[self removePopupUserMenuView];
    
    [browserScrollView setScrollerStyle:NSScrollerStyleOverlay];
    [browserScrollView setHasHorizontalScroller:NO];
    [selectedImageBrowser setAnimates:YES];
    //[mImageBrowser setValue:satan forKeyPath:IKImageBrowserBackgroundColorKey];
    [mImageBrowser setValue:[satan colorWithAlphaComponent:0.7] forKeyPath:IKImageBrowserBackgroundColorKey];
    [mImageBrowser2 setValue:[satan colorWithAlphaComponent:0.7] forKeyPath:IKImageBrowserBackgroundColorKey];
    //[satan colorWithAlphaComponent:0.8].CGColor
    
    [screenListTableView setBackgroundColor:[[NSColor cyanColor] colorWithAlphaComponent:0.3]];
}


//-----Appreance end----------

-(void) updateLabels: (NSLabelVisibiliy) visibility {
    
    [labelTotalSnapshots setStringValue:[NSString stringWithFormat:@"Selected/Total: %ld/%@", [self selectedSnapshotCount], [NSString stringWithFormat: @"%ld", (long)[self getTotalSnapshotCount]] ]];
    
    //[self updateDateLabels:visibility];
    //[labelCurrentSelection setHidden:([mImages count] <= 0)];
}



- (void) updateDateLabels :(NSLabelVisibiliy) visibility {
    
    //Hide if necessary
    [labelFromDate setHidden:visibility];
    [labelToDate setHidden:visibility];

    
    if (visibility) {
        // No need to do anything
        return;
    }
    
    
    if (![self dateToSelection]) {
        
        [labelFromDate setStringValue:@" "];
        [labelToDate setStringValue:@" "];
        
        return;
        
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *compsFrom = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit
                                                fromDate:[self dateFromSelection]];
    NSDateComponents *compsTo =  [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit
                                              fromDate:[self dateToSelection]];
    
    NSString * formatStr;
    
    if ([compsFrom year] == [compsTo year]) {
    

        if (([compsFrom month] == [compsTo month]) && ([compsFrom day] == [compsTo day])) {
            
            formatStr = @"H:mm:ss";
            
            
        } else {
            
            formatStr = @"dd MMM";
            
        }
        
    } else {
        
            formatStr = @"dd MMM yyyy";
        
    }
    
    
    
    [dateFormatter setDateFormat:formatStr];
    
    //Show values
    
    
    [labelFromDate setStringValue:[dateFormatter stringFromDate:[self dateFromSelection]]];
    [labelToDate setStringValue:[dateFormatter stringFromDate:[self dateToSelection ]]];


}



-(BOOL) saveScreensInDBIfNeeded : (NSArray * ) screenlist {
    
    if (!screenlist) {
        
        return false;
        
    }
    
    NSArray * screensFromDb = [self getScreenListFromDB];
    
    
    
    //Check if not exist then add
    
    int i, n;
    NSString * str ;
    
    for(i = 0; i < [screenlist count]; i++)
    {
        
        if (screensFromDb.count > 0) {
            
            //Check if not already loaded then load
            
            for(n = 0; n < [screensFromDb count]; n++)
            {
                str = screenlist[i];
                if ( [str isEqualToString:[screensFromDb[n] valueForKey:@"screenname"]] ) {
                    
                    break;
                }
                
                if ( i == [screensFromDb count] ) {
                    
                    [self addScreenToDBfor:screenlist[i] ];
                    
                    //NSLog(@"This screen will be added: %@", screenlist[i]);
                    
                    
                }
                
            }
            
        } else {
            
            //First time call. Load all
            [self addScreenToDBfor:screenlist[i] ];
            
            //NSLog(@"This screen must be added: %@", screenlist[i]);
            
        }
        
    }
    
    
    
    return  true;
}

-(void) loadScreensToCombo: (NSArray * ) _screenList {
    

    [self loadScreensToComboFor:popPanelScreenList with:_screenList];
    [self loadScreensToComboFor:popcomboBox with:_screenList];
    
    
}

-(void) loadScreensToComboFor : (NSPopUpButton * ) sender  with: (NSArray * )screenlist{
    
    if (!screenlist || screenlist.count == 0) {
        
        return;
    }
    
    [sender removeAllItems];
    
    int i;
    /* Now we iterate through them. */
    for(i = 0; i < [screenlist count]; i++)
    {
        [sender insertItemWithTitle:[(NSManagedObject *)screenlist[i] valueForKey:@"screenname"] atIndex:i];
        
    }
    
    
    //Add default "All" to the list
    [sender insertItemWithTitle:@"All screens" atIndex:[screenlist count]-1];
    
    
    
    [sender selectItemWithTitle:[self defaultScreen]];
    
    
}

-(void)darkModeChanged:(NSNotification *)notif
{
    [self setUpAppleBarMenu];
}

-(void) setUpAppleBarMenu {
    
    NSString *osxMode = [[NSUserDefaults standardUserDefaults] stringForKey:@"AppleInterfaceStyle"];
    NSString *imgName = @"virticon_dark";
    
    if (!statusItem) {
        statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] ;
        [statusItem setMenu:statusMenu];
        //[statusItem setTitle:@"Status"];
    }
    
    if ((osxMode) && ([osxMode isEqualToString:@"Dark"])) {
    
        imgName = @"virticon_light";
    }
    
    //NSString *   path = [[NSBundle mainBundle] pathForResource:imgName
    //                                                    ofType: @"png"];
    
    //NSURL *      url = [NSURL fileURLWithPath: path];
    
    NSImage *iconimg = [NSImage imageNamed:[imgName stringByAppendingString:@".png"]];
    
    
    
    [iconimg setSize:NSMakeSize(18.0, 18.0)];
    
    [statusItem setImage:iconimg];
    
    [statusItem setHighlightMode:NO];
    
}


//########### SCHEDULES ######################

- (void) startRemovalDeletedRecords {
    
    removeDeletedRecords =  [NSTimer scheduledTimerWithTimeInterval:3 //*60 //10 minutes
                                                             target:self
                                                           selector:@selector(removeDeletedRecords)
                                                           userInfo:nil
                                                            repeats:YES];
    //NSLog(@"Checking deleted records..");
}

- (void) stopRemovalDeletedRecords {
    
    [removeDeletedRecords invalidate];
    
}

- (void) startFreeDiskSpaceControl {
    
    freeDiskSpaceControl =  [NSTimer scheduledTimerWithTimeInterval:10*60 //10 minutes
                                                            target:self
                                                          selector:@selector(controlDiskSpaceUsage)
                                                          userInfo:nil
                                                           repeats:YES];
    //NSLog(@"Checking free disk space..");
}

- (void) stopFreeDiskSpaceControl {
    
    if (freeDiskSpaceControl) {
        
        [freeDiskSpaceControl invalidate];
        
    }
    
}

- (void) takePeriodicSnapshot {
    
    NSEvent * customeEvent = [NSEvent otherEventWithType:NSApplicationDefined
                                                location:NSMakePoint(0, 0)
                                           modifierFlags:NSDeviceIndependentModifierFlagsMask
                                               timestamp:NSTimeIntervalSince1970
                                            windowNumber:0
                                                 context:nil
                                                 subtype:NSApplicationDefined
                                                   data1:NSSnapTimer
                                                   data2:0];
    
    [self takeSnapshotForEvent:customeEvent];
    
}

- (void) startSnapTakingIntervalSchedule {
    
    if ([self snapshotTakingInterval] > 0) {
    

        
        snapTakingIntervalSchedule =  [NSTimer scheduledTimerWithTimeInterval:[self snapshotTakingInterval]
                                                                target:self
                                                              selector:@selector(takePeriodicSnapshot)
                                                              userInfo:nil
                                                               repeats:YES];
    
    }
    
}

- (void) stopSnapTakingIntervalSchedule {
    
    if (snapTakingIntervalSchedule) {
    
        [snapTakingIntervalSchedule invalidate];
        
    }
    
}

- (void) startExpiryCleanSchedule {
    
    expiryCleanSchedule =  [NSTimer scheduledTimerWithTimeInterval:10*60 //10 minutes
                                 target:self
                                 selector:@selector(deleteExpiredSnapshots)
                                 userInfo:nil
                                 repeats:YES];
    
}

- (void) stopExpiryCleanSchedule {
    
    if (expiryCleanSchedule) {
        
        [expiryCleanSchedule invalidate];
        
    }
}

- (void) startUploadSchedule {
    
    if (![self ifSignedUp]) {
        
        return;
        
    }
    
    uploadSchedule =  [NSTimer scheduledTimerWithTimeInterval:20 //sec
                                                            target:self
                                                          selector:@selector(uploadNewSnapshots)
                                                          userInfo:nil
                                                           repeats:YES];
    
}

- (void) stopUploadSchedule {

    if (uploadSchedule) {
        
        [uploadSchedule invalidate];
        
    }
    
}


- (void) stopAllSchedules {
    
    [self stopExpiryCleanSchedule];
    
    [self stopFreeDiskSpaceControl];
    
    [self stopSnapTakingIntervalSchedule];
    
    [self stopUploadSchedule];
    
}

//########### END SCHEDULES ######################


-(void) defineScreenList {
    
    //Set up screen list
    screenList = [self getScreenListFromOS];
    [self saveScreensInDBIfNeeded:screenList];
    screenList = [self getScreenListFromDB];
    
    [self loadScreensToCombo:screenList];
    

    //We need to add ALL SCREENS and make it first in order
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"All screens" forKey:@"screenname"];

    NSArray * arr = [[NSArray arrayWithObject:dictionary] arrayByAddingObjectsFromArray:screenList];
    [screenListTableDataSource setScreenList:arr];
    [screenListTableView reloadData];
    [screenListTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}


void SnapsDisplayReconfigurationCallBack (
                                          CGDirectDisplayID display,
                                          CGDisplayChangeSummaryFlags flags,
                                          void *userInfo)
{
    KMAppDelegate * app = (__bridge KMAppDelegate *)userInfo;
    
    if (flags & kCGDisplayAddFlag) {
        // display has been added
        //NSLog(@"Display attached!");
        
          [app defineScreenList ];
    }
    else if (flags & kCGDisplayRemoveFlag) {
        // display has been removed
        //NSLog(@"Display detached!");
        
          [app defineScreenList ];
    }
    
}

- (void) initDBVariables {
    
    //Reusables
    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
    
    //LEFT CLICK
    BOOL defaultVal = YES;
    //If it's defined then set value from DB.
    if ([self getSettingFromDBFor:@"LeftClickCapture"]) {
        defaultVal = ([[self getSettingFromDBFor:@"LeftClickCapture"] isEqualToString:@"YES"]?YES:NO);
    }
    _leftClickCapture = defaultVal;
    
    //RIGHT CLICK
    _rightClickCapture = ([[self getSettingFromDBFor:@"RightClickCapture"] isEqualToString:@"YES"]?YES:NO);
    
    //WHEEL SCROLL
    _wheelCapture = ([[self getSettingFromDBFor:@"WheelCapture"] isEqualToString:@"YES"]?YES:NO);
    
    //KEY CAPTURE
    _keyCapture = ([[self getSettingFromDBFor:@"KeyCapture"] isEqualToString:@"YES"]?YES:NO);

    //STORAGE ALLOWANCE (DEFAULT 1GB)
    NSInteger defaultIntVal = [[self getSettingFromDBFor:@"KeyStorageAllowance"] intValue];
    _storageAllowance = (defaultIntVal)?defaultIntVal:1;
    
    //SNAPSHOT QUALITY
    NSNumber * defaultNumVal = [nf numberFromString:[self getSettingFromDBFor:@"KeySnapshotQuality"]];
    _snapshotQuality = (defaultNumVal)?defaultNumVal:[NSNumber numberWithFloat:0.35f];
    
    
    //SNAPSHOT TAKING INTERVAL
    _snapshotTakingInterval = [[nf numberFromString:[self getSettingFromDBFor:@"KeySnapshotTakingInterval"]] integerValue];
    
    //LAST RECORDING STATUS
    NSString * defaultStrVal = [self getSettingFromDBFor:@"KeyRecordingStatus"] ;
    _recordingStatus = (defaultStrVal)?[defaultStrVal integerValue]:NSRecordingStopped;


}

- (void) awakeFromNib {


    if (![self initDBparams]) {
        
        return;
        
    }
    
    //Load DB variables
    [self initDBVariables];

    //Set delegate for double slider
    [doubleSlider setDelegate:self];
    [mImageView setDelegate:self];
    
    //Subscribe for Dark mode changes
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(darkModeChanged:) name:@"AppleInterfaceThemeChangedNotification" object:nil];
    
    //Set defaults;
    bottomPanelHeight = browserScrollView.frame.size.height;
    
    //Create image delegate for the Layer (That will be responsible for image draw
    imageLayerDelegate = [KMImageLayerDelegate new];
    imageSubLayer = [CALayer layer];
    [imageSubLayer setDelegate:imageLayerDelegate];
    [imageSubLayer setBounds:[[mImageView layer] bounds]];
    [[mImageView layer] addSublayer:imageSubLayer];
    
    
    //Date selection table settings
    dateListTableDataSource = [KMDateListTableViewDataSource new];
    [dateListTableView setDataSource:dateListTableDataSource];
    [dateListTableView setDelegate:dateListTableDataSource];
    
    
    screenListTableDataSource = [KMScreenListTableViewDataSource new];
    [screenListTableView setDataSource:screenListTableDataSource];
    [screenListTableView setDelegate:screenListTableDataSource];
    
    //[self setIfSignedUp:([self cloudUserName] != nil)];
    [self setIfSignedUp:NO];
    
    //Create session delegate for HTTP tasks
    /*if (!sessionDelegate && [self ifSignedUp]) {
        
        sessionDelegate = [HTTPSessionDelegate new];
        
    }*/
    
    //*****TEMPORARY
    
    //[self setUserId:[self getSettingFromDBFor:@"userId"]];
    //cloudUserName = @"khalid4";
    //cloudPassword = @"$S$D6moS4Gn1JEW2mB4a163zzuixvuCez6/xNaBcspwfZMmDVPPKuLi";
    //[self setUserId:@"7"];
    //*****
    
    //Connect cloud user if signed up
    [self authenticateCloudUser];
    
    
    //Start schedules
    [self startExpiryCleanSchedule];
    [self startUploadSchedule];
    //[self startFreeDiskSpaceControl]; //It will be started at START button
    [self startRemovalDeletedRecords];
    
    //Set Launcher Identifier for auto app louches
    autoLauncherIdentifier = @"com.isnapshooter.mammadov.SnapshooterLauncher";
    

    //Listen to Monitor attach/detach events
    KMAppDelegate * __weak weakSelf = self;
    void * userInfo = (__bridge void *)(weakSelf);
    CGDisplayRegisterReconfigurationCallback (SnapsDisplayReconfigurationCallBack, userInfo);
    
    //Load screen list from OS/DB to variable and combobox
    [self defineScreenList];
    
    //Set current selection
    [self setCurrentSelection:NSPeriodSelectionToday];
    
    //Setup User Interface
    [self setupAppearence];
    
    
  // This is to enable Key capture in OS, we will desable key capture for now
  //  NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
  //  BOOL accessibilityEnabled = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
  // See: http://stackoverflow.com/questions/17693408/enable-access-for-assistive-devices-programmatically-on-10-9
    
}






//****************************************************************
// Image browser starts here
//****************************************************************

-(void) updateDownloadCounter {

    [labelDownloadCounter setStringValue:[NSString stringWithFormat:@"%lu",
                                          [sessionDelegate getDownloadRequestQueueCount]]];
     //),                               selectedSnapshotCount]];
}

-(void) __reloadImageBrowser {

    [self performSelector:@selector(updateDownloadCounter) withObject:self afterDelay:0 ];
    
    if ([sessionDelegate getDownloadRequestQueueCount] < 5) {
    
        //Update data sources, reload and scroll to the last element
        [self updateDatasource];
        
        //Add hints to the images to get info immediately
        [self setImageToolTips];
        
        //Set default image if no files loaded
        if ([self selectedSnapshotCount] == 0) {
            
            //Setting front image
            [self setDefaultImage];
            
            
            //If nothing is selected then Add hint for a user
            if ([self selectedSnapshotCount] == 0) {
                [labelCurrentSelection setStringValue:[NSString stringWithFormat:@"No snaps for screen \"%@\" on selected day.", [popcomboBox titleOfSelectedItem ]]];
            }
            
            if ([self appLayout] == NSStandardLayout) {
                
                //[self hideBottomScrollView ];
                [mBottomPanelView setHidden:YES];
                //Remove this to avoid overlapping issue when no snaps (special case)
                //[self removePopupUserMenuView];
            }

        } else {
        
            //Make sure bottom view comes back after there is some data
            if ([self appLayout] == NSStandardLayout) {
                
                [self showBottomScrollView ];
            }
            
            [self selectLastelementAndScroll];
            
        }
        
        [self stopProgressIndicator];
        
        if (reloadSchedule) {
        
            [reloadSchedule invalidate];
            
            [self stopCounterWindow];
            
        }
        
    }
    
    #ifdef DEBUG
    NSLog(@"__reload complete");
    #endif
    
}

- (void) waitForAllDownloads: (NSArray *) fileList {
    
    //Check if all downloaded
    
    if ([sessionDelegate getDownloadRequestQueueCount] > 3 ) {
    
        [self updateDownloadCounter];
        [self startCounterWindow];
        
        
        //Wait in a loop and check
        reloadSchedule =  [NSTimer scheduledTimerWithTimeInterval:2 //1 second
                                                           target:self
                                                         selector:@selector(__reloadImageBrowser)
                                                         userInfo:nil
                                                          repeats:YES];
        
    } else {
        
        //Run immediately
        [self __reloadImageBrowser];
        
    }
    

    
}

-(void) _reloadImageBrowser {
    
    
    NSDate *fromDate;
    NSDate *toDate;
    
    
    if ([self dateToSelection]) {
        
        
        [self calculateDatesFromLoHi: [self doubleSliderLoValue] hivalue:[self doubleSliderHiValue] fromdate:&fromDate todate:&toDate];
        
        #ifdef DEBUG
        NSLog(@"Debug: Dates for selection %@ %@", fromDate, toDate);
        NSLog(@"Debug: Selected screen: %@",[(NSManagedObject *)screenListTableDataSource.screenList[screenListTableView.selectedRow] valueForKey:@"screenname"]);
        #endif
        
        NSArray * fileList = [self loadSnapshotsFromDbForDatesFrom:fromDate toDate:toDate screenName: [(NSManagedObject *)screenListTableDataSource.screenList[screenListTableView.selectedRow] valueForKey:@"screenname"] ];

        #ifdef DEBUG
        NSLog(@"Fetched record count: %ld", [fileList count]);
        #endif
        
        //Retain list for later use
        [self setMImportedImages:fileList];
      
        #ifdef DEBUG
        NSLog(@"Imported record count: %ld", [[self mImportedImages] count]);
        #endif
        
        #ifdef DEBUG
        NSLog(@"Min-max imported %ld to %ld", (long)[self getMinImportedImageId ], (long)[self getMaxImportedImageId]);
        #endif
        
/*        if (![self checkIfAllDownloaded:fileList]) {
            NSLog(@"Not all files downloaded: downloading and waiting.");
            
            [self downloadIfneeded:fileList];
            
            
        } */
        
        
        [selectedImageBrowser removeAllToolTips];
        
        //Start loop here
        //[self waitForAllDownloads:fileList];
        
        [self __reloadImageBrowser];
        
        //NSLog(@"Min/Max:%@/%@, Curr from/to:%@/%@", [self dateFromMinGlobal], [self dateToMaxGlobal], fromDate, toDate);

    }
    
    
    BOOL showOrHideLabels =  ((([self currentSelection] == NSPeriodSelectionAll) || ([self currentSelection] == NSPeriodSelectionRange)) && (![fromDate isEqualToDate:toDate ])) ? NSLabelUnhide : NSLabelHide;
    
    [self updateLabels:showOrHideLabels]; //call after data reload to ensure labels are correct
    
    #ifdef DEBUG
        NSLog(@"_reloadImageBrowser complete");
    #endif
    
}


-(void) reloadImageBrowser {

    if ([self dateToSelection]) {
        
        [self startProgressIndicator];
        [self _reloadImageBrowser];

    }
    
}

- (void) selectIndexElementAndScroll : (NSInteger) index {
    
    if (mImages.count == 0 || mImages.count < index  ) {
        
        return;
    }
    
    NSInteger imageCount = [mImages count]-1;
    NSIndexSet *selectionIndexes = [[NSIndexSet alloc] initWithIndex:index ];
    
    [selectedImageBrowser setSelectionIndexes:selectionIndexes byExtendingSelection:NO];

#ifdef DEBUG
    NSLog(@"SelectedScrollView identifier:%@", [selectedScrollView identifier] );
    NSLog(@"Image count vs index:%ld %ld",  (long)imageCount, (long)index);
    NSLog(@"Document view height: %f", ((NSView*)selectedScrollView.documentView).frame.size.height);
    NSLog(@"ContentSize height: %f", selectedScrollView.contentSize.height);
#endif
    
    if ([[selectedScrollView identifier] isEqualToString:@"Standard"]) {
        
        float val = ((((NSView*)selectedScrollView.documentView).frame.size.width
                      - selectedScrollView.contentSize.width)/imageCount)*index;
#ifdef DEBUG
        NSLog(@"Val:%f", val);
#endif
        //Check is not NaN
        val = (!isnan(val))?val:0;
        [selectedScrollView.contentView scrollToPoint:NSMakePoint(val, 0)];
        
    } else {
        
        float contentHeight = (((NSView*)selectedScrollView.documentView).frame.size.height - selectedScrollView.contentSize.height);
        float val = contentHeight - ((contentHeight)/(imageCount/4))*(index/4);
        
#ifdef DEBUG
        NSLog(@"contentHeight size height: %f", contentHeight);
        NSLog(@"Val:%f", val);
#endif
        //Check is not NaN
        val = (!isnan(val))?val:0;
        
        [selectedScrollView.contentView scrollToPoint:NSMakePoint(0,  val)];
    }
    
}


- (void) selectLastelementAndScroll {

    [self selectIndexElementAndScroll:mImages.count-1];

}


- (void) scrollImageViewForward {
    
    //Check if not end then scroll image browser
    if (browserScrollView.contentView.bounds.origin.x+selectedImageBrowser.cellSize.width+selectedImageBrowser.intercellSpacing.width <=
        ((NSView*)browserScrollView.documentView).frame.size.width- browserScrollView.contentSize.width) {
        
        [browserScrollView.contentView scrollToPoint:NSMakePoint(browserScrollView.contentView.bounds.origin.x+selectedImageBrowser.cellSize.width+selectedImageBrowser.intercellSpacing.width, 0)];
        
        [browserScrollView reflectScrolledClipView:[browserScrollView contentView]];
    }
    
    
}

- (void) scrollImageViewBackwards {
    
    //Check if not beginning then scroll image browser
    if (browserScrollView.contentView.bounds.origin.x-selectedImageBrowser.cellSize.width-selectedImageBrowser.intercellSpacing.width >= 0) {
        
        [browserScrollView.contentView scrollToPoint:NSMakePoint(browserScrollView.contentView.bounds.origin.x-selectedImageBrowser.cellSize.width-selectedImageBrowser.intercellSpacing.width, 0)];
        
        [browserScrollView reflectScrolledClipView:[browserScrollView contentView]];
        
    }
}

-(void) selectNextElement {
    
    if (selectedImageBrowser.selectionIndexes.count == 0 ) {
        return;
    }
    
    
    NSIndexSet *currentSelectionIdx = [selectedImageBrowser selectionIndexes];
    
    NSUInteger nextSelectionIdx = [currentSelectionIdx firstIndex]+1;
    
    //Check if we reached end of the list
    if (nextSelectionIdx <= [mImages count]-1) {
    
        [selectedImageBrowser setSelectionIndexes:[[NSIndexSet alloc] initWithIndex:nextSelectionIdx ] byExtendingSelection:NO];
    
        //[self scrollImageViewForward];
    }
}

-(void) selectBackElement {

    if (selectedImageBrowser.selectionIndexes.count == 0 ) {
        return;
    }
    
    NSIndexSet *currentSelectionIdx = [selectedImageBrowser selectionIndexes];
    
    NSUInteger backSelectionIdx = [currentSelectionIdx firstIndex]-1;
    
    
    //Check if we have come to the beginning
    if ((NSInteger)([currentSelectionIdx firstIndex]-1) >= 0) {
        
        [selectedImageBrowser setSelectionIndexes:[[NSIndexSet alloc] initWithIndex:backSelectionIdx ] byExtendingSelection:NO];
        
        
        //Scroll backward
        //[self scrollImageViewBackwards];

    }
}

- (void) updateDatasource
{
    #ifdef DEBUG
    NSLog(@"Updating data source.");
    #endif
    
    [mImages removeAllObjects];
    [mImages addObjectsFromArray:[self mImportedImages]];
    [selectedImageBrowser reloadData];
    
    #ifdef DEBUG
    NSLog(@"Update complete.");
    #endif
}

- (NSUInteger) numberOfItemsInImageBrowser:(IKImageBrowserView *) view
{
    return [mImages count];
}

- (id) imageBrowser:(IKImageBrowserView *) view itemAtIndex:(NSUInteger) index
{
    return [mImages objectAtIndex:index];
}

- (void) showImage: (KMImageObject *) anImage {
    
    NSURL * url = [[[self snapshotsPathUrl] URLByAppendingPathComponent:[anImage imageCreateDay] isDirectory:TRUE] URLByAppendingPathComponent :[anImage imageFileName]] ;
    
    [self performSelector:@selector(loadImage:) withObject:url afterDelay:0 ];
    
    [self resetZoomSnap];
    
    //Get file name then date (ddmmyyyy.) and convert it to dd MMM YYYY...
    [labelCurrentSelection setStringValue: [anImage imageSubtitle]];
    
    
}

-(void) downloadAndShow: (KMImageObject *) anImage {
    
    //Reload from Db to get up-to-date status
    KMImageObject * theImage = [self getImageFile:anImage.imageFileName];
    
    //NSLog(@"The status: %@", [theImage imageStatus]);
    if ([[theImage imageStatus] isEqualToString: @"remote"]) {
        
        [self startProcessIndicator];
        
        //Start download then
        [sessionDelegate downloadFile:anImage];
        
    } else {
        
        //No download needed. Open it now!
        [self showImage:theImage];
        
    }
    
   
}

- (void) imageBrowserSelectionDidChange:(IKImageBrowserView *) aBrowser
{
    
    NSIndexSet *selectionIndexes = [aBrowser selectionIndexes];

	if ([selectionIndexes count] > 0)
	{
        
         [self downloadAndShow:[mImages objectAtIndex:[selectionIndexes firstIndex]]];
        
	}
    
}

//********** END IMAGE BROWSER ********************************


//****************************************************************
// Actual snapshot part
//****************************************************************

//----------------------
//Screen info part
//----------------------

#pragma mark Display routines


static io_service_t IOServicePortFromCGDisplayID(CGDirectDisplayID displayID)
{
    io_iterator_t iter;
    io_service_t serv, servicePort = 0;
    
    CFMutableDictionaryRef matching = IOServiceMatching("IODisplayConnect");
    
    // releases matching for us
    kern_return_t err = IOServiceGetMatchingServices(kIOMasterPortDefault,
                                                     matching,
                                                     &iter);
    if (err)
    {
        return 0;
    }
    
    while ((serv = IOIteratorNext(iter)) != 0)
    {
        CFDictionaryRef info;
        CFIndex vendorID, productID;
        CFNumberRef vendorIDRef, productIDRef;
        Boolean success;
        
        info = IODisplayCreateInfoDictionary(serv,
                                             kIODisplayOnlyPreferredName);
        
        vendorIDRef = CFDictionaryGetValue(info,
                                           CFSTR(kDisplayVendorID));
        productIDRef = CFDictionaryGetValue(info,
                                            CFSTR(kDisplayProductID));
        
        success = CFNumberGetValue(vendorIDRef, kCFNumberCFIndexType,
                                   &vendorID);
        success &= CFNumberGetValue(productIDRef, kCFNumberCFIndexType,
                                    &productID);
        
        if (!success)
        {
            CFRelease(info);
            continue;
        }
        
        if (CGDisplayVendorNumber(displayID) != vendorID ||
            CGDisplayModelNumber(displayID) != productID)
        {
            CFRelease(info);
            continue;
        }
        
        // we're a match
        servicePort = serv;
        CFRelease(info);
        break;
    }
    
    IOObjectRelease(iter);
    return servicePort;
}

/* Get the localized name of a display, given the display ID. */
-(NSString *)displayNameFromDisplayID:(CGDirectDisplayID)displayID
{
    
    NSString *displayProductName = nil;
    
    // Get a CFDictionary with a key for the preferred name of the display.
    //NSDictionary *displayInfo = (__bridge NSDictionary *)IODisplayCreateInfoDictionary(CGDisplayIOServicePort(displayID), kIODisplayOnlyPreferredName);
    NSDictionary *displayInfo = (__bridge NSDictionary *)IODisplayCreateInfoDictionary(IOServicePortFromCGDisplayID(displayID), kIODisplayOnlyPreferredName);
    // Retrieve the display product name.
    NSDictionary *localizedNames = [displayInfo objectForKey:[NSString stringWithUTF8String:kDisplayProductName]];
    
    // Use the first name.
    if ([localizedNames count] > 0)
    {
        displayProductName = [localizedNames objectForKey:[[localizedNames allKeys] objectAtIndex:0]] ;
    }
    
    // [displayInfo release];
    return displayProductName ;
    
}

-(NSArray *) getScreenListFromOS {
    
    
    CGError				err = CGDisplayNoErr;
	CGDisplayCount		dspCount = 0;
    
    NSMutableArray *    marr = [[NSMutableArray alloc] init];
    
    /* How many active displays do we have? */
    err = CGGetActiveDisplayList(0, NULL, &dspCount);
    
	/* If we are getting an error here then their won't be much to display. */
    if(err != CGDisplayNoErr)
    {
        NSLog(@"Display error");
        return nil;
    }
	
	/* Maybe this isn't the first time though this function. */
	if(displays != nil)
    {
        #ifdef DEBUG
        NSLog(@"Display defined");
        #endif
        free(displays);

    }
    
	/* Allocate enough memory to hold all the display IDs we have. */
    displays = calloc((size_t)dspCount, sizeof(CGDirectDisplayID));
    
	// Get the list of active displays
    err = CGGetActiveDisplayList(dspCount,
                                 displays,
                                 &dspCount);
	
	/* More error-checking here. */
    if(err != CGDisplayNoErr)
    {
        NSLog(@"Could not get active display list (%d)\n", err);
        return nil;
    }
    
    /* Now we iterate through them. */
    for(int i = 0; i < dspCount; i++)
    {
        /* Get display name for the selected display. */
        NSString* name = [self displayNameFromDisplayID:displays[i]];
        
        [marr insertObject:name atIndex:i];
        
    }
    
    return marr;
}



//----------------------
//Snapshot taking part
//----------------------

void CGImageWriteToFile(CGImageRef image, NSString *path) {
    
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypeJPEG, 1, NULL);
    CGImageDestinationAddImage(destination, image, nil);
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", path);
    }
    
    CFRelease(destination);
    
}


- (NSEventMask) capturedEvents {
    
    NSEventMask tempMask;
    
    //These captures keyboard combinations ALT+TAB as well...
    tempMask = NSEventMaskGesture | NSFlagsChangedMask;
    
    
    if (checkLeftClickCapture.state) {
    
        tempMask = tempMask | NSLeftMouseDownMask;
    
    }
    if (checkRightClickCapture.state) {
        
        tempMask = tempMask | NSRightMouseDownMask;
        
    }
    if (checkWheelClickCapture.state) {
        
        tempMask = tempMask | NSScrollWheelMask;
        
    }
    /*if (checkKeyCapture.state) {
        
        tempMask = tempMask | NSKeyDownMask ;
        
    }*/
    
    return tempMask;
    
}

- (void) stopEventListener {
    
    if (systemEventListener) {
    
        [NSEvent removeMonitor:systemEventListener];
        systemEventListener = nil;
            
    }
    
}

- (void)registerEventListener {
/*
  systemEventListener = [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask
                                           handler:^(NSEvent *event){
                                               
                                               //[self takeSnapshot];
                                              
                                           }];*/
    if ([self leftClickCapture]
        || [self rightClickCapture]
        || [self wheelCapture]) {
    
            if (!systemEventListener) {
            
                 systemEventListener = [NSEvent addGlobalMonitorForEventsMatchingMask:[self capturedEvents]
                                                                        handler:^(NSEvent *event){

                                                                            [self takeSnapshotForEvent:event];
          
                                                                       }];
            }
    }
}

- (void) restartEventListener {

    //Interval schedule
    [self stopSnapTakingIntervalSchedule];
    [self startSnapTakingIntervalSchedule];
    

    //Mouse events
    [self stopEventListener];
    [self registerEventListener];

}


-(int) getDisplayNoFromName : (NSString * ) name {
    
    int i;
    
    
    for (i=0; i<screenList.count; i++ ) {
        
        if ( [[(NSManagedObject*)screenList[i] valueForKey:@"screenname"] isEqualToString:name]) {
            
            return i;
        }
        
    }
    
    return -1; //Not found
    
}


- (void)takeSnapshotForEvent: (NSEvent *) event {
    
    int  displayNo, i;
    
    NSString * snapshotsForScreen  = [self defaultScreen];
    
    if ([snapshotsForScreen isEqualToString:@"All screens"]) {
        
        for (i=0; i<screenList.count; i++) {
        
            if (![[(NSManagedObject*)screenList[i] valueForKey:@"screenname"] isEqualToString:@"All screens"]) {

                [self takeSnapshotForScreen: i andEvent:event] ;
                
            }
        }
        
        
    }  else {
        
        displayNo = [self getDisplayNoFromName:snapshotsForScreen];
        
        [self takeSnapshotForScreen: displayNo andEvent:event] ;
        
    }

}

- (NSUInteger) getFileSize : (NSString * ) filePathwithName {
    
    if (!filePathwithName) {
        
        NSLog(@"File name is null!");
        
        return -1;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attrs = [fileManager attributesOfItemAtPath: filePathwithName error: NULL];
    NSUInteger result = [attrs fileSize];
    
    return result;
    
}


- (NSImage *)scaleImage:(NSImage *)image toSize:(NSSize)targetSize
{
    NSImage * newImage;
    
    if ([image isValid])
    {
        NSSize imageSize = [image size];
        float width  = imageSize.width;
        float height = imageSize.height;
        float targetWidth  = targetSize.width;
        float targetHeight = targetSize.height;
        float scaleFactor  = 0.0;
        float scaledWidth  = targetWidth;
        float scaledHeight = targetHeight;
        
        NSPoint thumbnailPoint = NSZeroPoint;
        
        if (!NSEqualSizes(imageSize, targetSize))
        {
            float widthFactor  = targetWidth / width;
            float heightFactor = targetHeight / height;
            
            if (widthFactor < heightFactor)
            {
                scaleFactor = widthFactor;
            }
            else
            {
                scaleFactor = heightFactor;
            }
            
            scaledWidth  = width  * scaleFactor;
            scaledHeight = height * scaleFactor;
            
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            }
            
            else if (widthFactor > heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
            
            newImage = [[NSImage alloc] initWithSize:targetSize];
            
            [newImage lockFocus];
            
            NSRect thumbnailRect;
            thumbnailRect.origin = thumbnailPoint;
            thumbnailRect.size.width = scaledWidth;
            thumbnailRect.size.height = scaledHeight;
            
            [image drawInRect:thumbnailRect
                     fromRect:NSZeroRect
                    operation:NSCompositeSourceOver
                     fraction:1.0];
            
            [newImage unlockFocus];
        }
        
        
    }
    
    return newImage;
}



- (void)takeSnapshotForScreen: (NSInteger ) displayNo andEvent:(NSEvent *) event {
    
    
    #ifdef DEBUG
    //NSLog(@"Display NO:%u", displays[displayNo]);
    NSLog(@"Display NO:%ld", displayNo);
    //NSLog(@"Is online:%u",CGDisplayIsOnline(displays[displayNo]));
    NSLog(@"Snap for Event type: %ld", [event type]);
    //NSLog(@"Snap for Event data1: %ld", [event data1]);
    #endif
    
    NSInteger eventType = ([event type] == NSLeftMouseDown
                           || [event type] == NSRightMouseDown
                           || [event type] == NSScrollWheel)?[event type]:([event type]==NSApplicationDefined)?[event data1]:0;
    
    #ifdef DEBUG
    //NSLog(@"Display NO:%u", displays[displayNo]);
    NSLog(@"Our Event type:%ld", eventType);
    #endif
    
    if ( CGDisplayIsOnline(displays[displayNo]) == false
        ||
        CGDisplayIsActive(displays[displayNo]) == false
        ||
        displays[displayNo] == 0) {
    
        #ifdef DEBUG
        NSLog(@"Display ?:%u", displays[displayNo]);
        #endif

            #ifdef DEBUG
            NSLog(@"Screen is not active for snapshots!");
            #endif
        
            return;
    }
    
    #ifdef DEBUG
    NSLog(@"Display ?:%u", displays[displayNo]);
    #endif
    
    // Take a snapshot image of the current display.
    CGImageRef image = CGDisplayCreateImage(displays[displayNo]);
    
    if (!image) {
        
        NSLog(@"ERROR:Snapshot taking failed! (Display No:%u)", displays[displayNo]);
        return;
    }
    
    NSImage * imageXS = [[NSImage alloc] initWithCGImage:image size:NSZeroSize];
    
    NSBitmapImageRep * bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:image];
    
    NSDictionary * lowQuality = [NSDictionary dictionaryWithObject: [NSNumber numberWithFloat:[[self snapshotQuality]floatValue ]] forKey:NSImageCompressionFactor];
    NSData * data5 = [bitmapRep representationUsingType:NSJPEGFileType properties:lowQuality];
    
    
    NSSize pointsSize = NSMakeSize(bitmapRep.pixelsWide/8,
                                   bitmapRep.pixelsHigh/8);
    imageXS = [self scaleImage:imageXS toSize:pointsSize];
    

    NSData * data5_xs = [imageXS TIFFRepresentation];
    
    bitmapRep = [[NSBitmapImageRep alloc] initWithData:data5_xs];
    data5_xs = [bitmapRep representationUsingType:NSJPEGFileType properties:lowQuality];
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //Format date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    

    
    NSDate *dt = [NSDate date];
    NSString * createday = [dateFormatter stringFromDate:dt];
    NSUInteger recordId = [self nextSequenceId];
    
    //NSString *fileUUID = [[NSUUID UUID] UUIDString];
    
    NSString *outFileName = [NSString stringWithFormat:@"%@.%lu.jpg", createday, (unsigned long)recordId ];
    NSString *outFileNameXS = [NSString stringWithFormat:@"%@.%lu_XS.jpg", createday, (unsigned long)recordId ];
    
    NSString * filesFolder = [NSString stringWithFormat:@"%@/%@", [[self snapshotsPathUrl] path], createday];
    
    NSError * error;
    
    if (![fileManager fileExistsAtPath:filesFolder]) {
     
        [fileManager createDirectoryAtPath:filesFolder withIntermediateDirectories:YES attributes:nil error:&error];
        
    }
    
    NSString * outFilePathFileName   = [NSString stringWithFormat:@"%@/%@", filesFolder, outFileName];
    NSString * outFilePathFileNameXS   = [NSString stringWithFormat:@"%@/%@", filesFolder, outFileNameXS];
    
    //Not used
    //CGImageWriteToFile(image, outFilePathFileName);
    
    [data5 writeToFile: outFilePathFileName atomically: NO];
    [data5_xs writeToFile: outFilePathFileNameXS atomically: NO];
    
    [self addSnapshotsToDBfor: [(NSManagedObject *) screenList[displayNo] valueForKey:@"screenname"]
                                fileName:outFileName
                                fileNameXS:outFileNameXS
                                onDate:dt
                                fileSize: [data5 length]
                                fileSizeXS: [data5_xs length]
                                recordId: recordId
                       typeId:eventType ];
    
    
    
    if (image)
    {
        CFRelease(image);
    }
    
    
}


//********** END SNAPSHOT ********************************


-(void) arrangeNavigationViews {
    
}


- (void)windowDidResize:(NSNotification *) sender
{
 
    //[imageSubLayer setNeedsDisplay];
    [imageSubLayer performSelector:@selector(display) withObject:nil afterDelay:0.1];
    
    [self retainNavigationViewsState];
    
    //Force update everything, including tracking areas!
    [self setAppLayout:_appLayout];
    
}


- (void) resetZoomSnap {
    
    [toolZoomSnap setFloatValue:0.641111];
    
}


- (IBAction)toolZoomSnapDidChange:(id)sender {

    [imageSubLayer setNeedsDisplay];
    
}



- (void) startScreenCapture {
    
    //We do not't need it as it's called after restart
    //if (self.recordingStatus == NSRecordingStopped) {
    
    //Start events and schedules
    [self restartEventListener];
    [self showRecordingStatus];
    [self startFreeDiskSpaceControl];
    
    //Show nice info
    [labelPanelCaptureStatus setStringValue:@"Started"];
    [panelCaptureStatus makeKeyAndOrderFront:self];

    [panelCaptureStatus performSelector:@selector(orderOut:) withObject:self afterDelay:1];
    //[panelCaptureStatus orderOut:self];
    
    [toolStart setImage:[NSImage imageNamed:@"stop.png"]];
    [butRecordingStartStop setImage:[NSImage imageNamed:@"stop.png"]];

    //Set status
    self.recordingStatus = NSRecordingStarted;


    [window performMiniaturize:self];

    //Hide/Unhide menu buttons
    [[self startSnapshootingMenu] setHidden:YES];
    [[self stopSnapshootingMenu] setHidden:NO];

    //Reset message counter
    freeDiskSpaceMessageCounter = 0;

    
}

- (void) stopScreenCapture {
    
    if (self.recordingStatus == NSRecordingStarted) {
        
        [toolStart setImage:[NSImage imageNamed:@"start.png"]];
        [butRecordingStartStop setImage:[NSImage imageNamed:@"start.png"]];

        [self hideRecordingStatus];
        
        //Stop "needed" schedules
        [self stopEventListener];
        [self stopSnapTakingIntervalSchedule];
        [self stopFreeDiskSpaceControl];


        
        //Show nice info
        [labelPanelCaptureStatus setStringValue:@"Stopped"];
        [panelCaptureStatus makeKeyAndOrderFront:self];
        //sleep(1);
        [panelCaptureStatus performSelector:@selector(orderOut:) withObject:self afterDelay:1];
        //[panelCaptureStatus orderOut:self];
        
        //Set status
        self.recordingStatus = NSRecordingStopped;
    
        //Hide/Unhide menu buttons
        [[self startSnapshootingMenu] setHidden:NO];
        [[self stopSnapshootingMenu] setHidden:YES];
        
    }
    
}

- (IBAction)toolStartClicked:(id)sender {
    
    if (self.recordingStatus == NSRecordingStarted) {
        
        [self stopScreenCapture];
        
    } else {
    
        [self startScreenCapture];


    }
    
}

- (IBAction)toolStopClicked:(id)sender {
    
    [self stopScreenCapture];
    
}

- (IBAction)popcomboBoxDidChange:(id)sender {
    
    #ifdef DEBUG
    NSLog(@"Selected screen: %@", [sender titleOfSelectedItem]);
    #endif
    
    [self reloadData];
    
}

- (IBAction)snapTypeFilterComboboxDidChange:(id)sender {
    
#ifdef DEBUG
    NSLog(@"Event type selected: %ld", [[snapTypesFilterComboBox selectedItem]tag]);
#endif
    
    [self reloadData];
    
}

- (IBAction)eventFilterButtonSelected:(id)sender {
  
#ifdef DEBUG
    NSLog(@"Event type selected: %ld", [[snapTypesFilterComboBox selectedItem]tag]);
#endif
    
    [self reloadData];
    
}

- (IBAction)popComboDatesDidChange:(id)sender {

    //NSLog(@"Selected tag:%ld", [[(NSPopUpButton *)sender selectedItem] tag]);

    NSMenuItem * menuSender = [(NSPopUpButton *)sender selectedItem];
    
    switch ([menuSender tag]) {
            
        case 1 :
        case 2 :
        case 3 : [self selectPeriod:menuSender];
                 break;
        case 4 : [self clickButPickDates:nil];
                break;
        default:
            NSLog(@"***TAG IS NOT DEFINED!!!!!!");
            
    }
    
}

- (IBAction)buttonSettingsClicked:(id)sender {

    
    //Update usage control
    [self setUsageIndicator];
    
    [windowSettings center];
    [windowSettings makeKeyAndOrderFront:self];


}


- (void)windowDidBecomeKey:(NSNotification *)notification {

    [self showAvailabLePanels];
//    [self performSelector:@selector(hideAvailablePanels) withObject:nil afterDelay:4];
    
}

-(void) disableButtonOneIfNotEqualToButtonTwo : (NSButton * ) buttonOne buttonTwo: (NSButton * ) buttonTwo {
    
    if ([buttonOne isNotEqualTo:buttonTwo] ) {

        if ([buttonOne state] == NSOnState) lastSelection = buttonOne;
        
        [buttonOne setState:NSOffState];
        
    }
    
}


- (NSMutableDictionary * ) getAllAvailableDates {
 
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:snapshots];
    
    //Filter out deleted ones
    NSPredicate * cond = [NSPredicate predicateWithFormat:@"status != \"deleted\" "];
    [fetchRequest setPredicate:cond];
    //Sort by ID
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    NSMutableDictionary * mDict = [NSMutableDictionary new];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    
    if (fetchedObjects != nil) {
        
        //Delete all
        for (NSManagedObject * record in fetchedObjects) {

            
            NSString * createday = [dateFormatter stringFromDate:[record valueForKey:@"createdate"]];
            
            
            NSNumber * recCount = ([mDict valueForKey:createday]);
            
            recCount =  (recCount == nil)
                        ?recCount = [NSNumber numberWithUnsignedInteger:1]
                        :[NSNumber numberWithUnsignedInteger:[recCount unsignedIntegerValue]+1];
            
            [mDict setValue:recCount forKey:createday];
            
            
        }
        
    }
    
    return mDict;
    
    
    /*
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:snapshots];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSAttributeDescription* dateField = [snapshots.attributesByName objectForKey:@"createdate"];

    
    NSExpression *loaclId = [NSExpression expressionForKeyPath:@"id"];
    NSExpression *countLoaclId = [NSExpression expressionForFunction:@"count:"
                                                    arguments:[NSArray arrayWithObject:loaclId]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"count_loaclid"];
    [expressionDescription setExpression:countLoaclId];
    [expressionDescription setExpressionResultType:NSDateAttributeType];
    
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    NSError *error = nil;
    NSArray *objects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
    
    
    if (objects == nil) {
        // Handle the error.
    } else {
        
        if (objects.count > 0) {
            
            returnDate = [[objects objectAtIndex:0] valueForKey:@"mDate"];
            
        }
        
    }
   */
    
}

- (void) populateDatesTableView  {
    
    /*
    NSMutableDictionary *mRow = [[NSMutableDictionary alloc] init];
    [mRow setObject: @"01/01/2001" forKey:@"Date"];
    [mRow setObject: @"100" forKey:@"Snaps"];
    
    NSLog(@"Arr: %@", mRow);
    
    [dateListTableDataSource addRow:mRow];
    
    */
    
    [dateListTableDataSource deleteAllRecords];
    
    NSDictionary * datesWithCounts = [self getAllAvailableDates ];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    
    NSArray * sortedKeys = [[datesWithCounts allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
        
        //NSLog(@"COmparing keys: %ld and %ld", (long)[obj1 integerValue], (long)[obj2 integerValue]);
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    
    
    for (NSString* key in sortedKeys) {
        
        NSNumber * recordCount = [datesWithCounts valueForKey:key];
        NSString * createday = [NSString stringWithFormat:@"%@/%@/%@",
                                [key substringWithRange:NSMakeRange(6, 2)],
                                [key substringWithRange:NSMakeRange(4, 2)],
                                [key substringWithRange:NSMakeRange(0, 4)]];
    
        NSMutableDictionary *mRow = [[NSMutableDictionary alloc] init];
        [mRow setObject: createday forKey:@"Date"];
        [mRow setObject: [recordCount stringValue] forKey:@"Snaps"];

        //NSLog(@"Adding key: %@", key);
        
        [dateListTableDataSource addRow:mRow];
        
        
    }
    
    [dateListTableView reloadData];
    
}

- (IBAction)clickButPickDates:(id)sender {

    //[self disableButtonsExceptSender: sender];
    
    
    [self populateDatesTableView];
    
    //These (Only MAX) must be initialized each time to ensure latest records are taken into account
//    [datePickerFrom setMinDate:[self dateFromMinGlobal]];
//    [datePickerFrom setMaxDate:[self dateToMaxGlobal]];
/*
    NSLog(@"Picker bounds: X=%f Y=%f Height=%f Width=%f", [datePickerFrom bounds].origin.x,
                                                        [datePickerFrom bounds].origin.y,
                                                        [datePickerFrom bounds].size.height,
                                                        [datePickerFrom bounds].size.width);
    
    // , , width , height
    [datePickerFrom setBounds:NSMakeRect(0, 0, 60, 80)];
    [datePickerFrom setFrame:NSMakeRect(29, 60, 400, 400)];
    
    NSLog(@"Picker bounds: X=%f Y=%f Height=%f Width=%f", [datePickerFrom bounds].origin.x,
          [datePickerFrom bounds].origin.y,
          [datePickerFrom bounds].size.height,
          [datePickerFrom bounds].size.width);
    

    [datePickerTo setDateValue:[self dateToSelection]];
*/
    
    
    
    
    
    [panelSelectDateTime makeKeyAndOrderFront:self];
    
}

- (IBAction)clickDoneDatePanel:(id)sender {
    
    //Use tag from the button (i.e. 0,1,2..) to match NSPeriodSelection
    [self setCurrentSelection:NSPeriodSelectionDay];
    
    [panelSelectDateTime orderOut:self];
    
    [self reloadData];
    
}

- (void)windowWillClose:(NSNotification *)notification {
    
    [lastSelection setState:NSOnState];
    
}


- (IBAction)clickButSwitchLayout:(id)sender {
  
    //Retain current selection if any
    NSIndexSet *currentSelectionIdx = [selectedImageBrowser selectionIndexes];
    
    
    switch ([(NSSegmentedControl * ) sender selectedSegment]) {
        
        case 1:
            [self setAppLayout:NSGalleryLayout];
            break;
            
        default:
            [self setAppLayout:NSStandardLayout];
            break;
            
    }
    #ifdef DEBUG
    NSLog(@"APP LAYOUT:Reloading...");
    #endif

    [self reloadImageBrowser];
    
    #ifdef DEBUG
    NSLog(@"APP LAYOUT:Reloading. Complete");
    #endif
    
    if ([currentSelectionIdx count] > 0) {
        
        [self selectIndexElementAndScroll:[currentSelectionIdx firstIndex]];
        
    }

    
    [self reloadCurrentImage];
    
    //[self addPopupUserMenuView ];
    
    #ifdef DEBUG
    NSLog(@"clickButSwitchLayout Complete");
    #endif
}




- (IBAction)selectPeriod:(id)sender {

    #ifdef DEBUG
    NSLog(@"Select period:%ld", (long)[sender tag]);
    #endif
    //NSLog(@"Current selection: %ld", [sender tag]);
    
    //[self disableButtonsExceptSender: sender];
    //Use tag from the button (i.e. 0,1,2..) to match NSPeriodSelection
    [self setCurrentSelection:[sender tag]];
        
    [self reloadData];
    
}

- (IBAction)clearAllData:(id)sender {
    
    //Ask before deleting
    [self checkIfSureToDeleteAll];
    
}



- (IBAction)doubleSliderDidChange:(id)sender {


}



- (IBAction)popPanelScreenListDidChange:(id)sender {
    
    //NSLog(@"Selected screen: %@", [sender titleOfSelectedItem]);
    [self setDefaultScreen:[sender titleOfSelectedItem]];
    
}

- (IBAction)sliderForDiskAllowanceDidChange:(id)sender {
    
    [labelPrefDiskSpace setStringValue:[NSString stringWithFormat:@"%dGb", [sliderForDiskAllowance intValue]]];
    
    [self setStorageAllowance:[sliderForDiskAllowance intValue]];
    
    [self setUsageIndicator];
    
}

- (IBAction)sliderForQualityDidChange:(id)sender {
    
    [self setSnapshotQuality:[NSNumber numberWithFloat:[sliderForQuality floatValue] ]];
    
}

- (IBAction)clickLeftClickCapture:(id)sender {
    
    [self setLeftClickCapture:[checkLeftClickCapture state]];
    
}

- (IBAction)clickRightClickCapture:(id)sender {
    
    [self setRightClickCapture:[checkRightClickCapture state]];
    
}

- (IBAction)clickWheelCapture:(id)sender {
    
    [self setWheelCapture:[checkWheelClickCapture state]];
    
}

- (IBAction)clickKeyCapture:(id)sender {
    
    [self setKeyCapture:[checkKeyCapture state]];
    
}

- (IBAction)clickAutoStartCheck:(id)sender {
    
    StartAtLoginController *loginController = [[StartAtLoginController alloc] initWithIdentifier:autoLauncherIdentifier];

    
    if ([checkAutoStart state]) {
        if (![loginController startAtLogin]) {
             [loginController setStartAtLogin: YES];
        }
    } else {
        if ([loginController startAtLogin]) {
             [loginController setStartAtLogin:NO];
        }
    }
    
    //NSLog(@"AutoStart=%hhd", [loginController startAtLogin]);
    
}

- (IBAction)stepperSnapshotIntervalClicked:(id)sender {
    
    [textFieldSnapshotTakingInterval setIntegerValue:[stepperSnapshotTakingInterval integerValue]];
    
    //NSLog(@"Stepper value: %ld", [stepperSnapshotTakingInterval integerValue]);
}

- (void) authenticateCloudUser {
    
    if (![self ifSignedUp]) {
     
        return;
        
    }
    
    //NSLog(@"Authenticating cloud user");
    
    //NSLog(@"Username:%@", [self cloudUserName]);
    //NSLog(@"Password:%@", [self cloudPassword]);
    
    
    //Try to authenticate (result will caught in didAuthenticate...)
    [sessionDelegate authenticateUser:[self cloudUserName] password:[self cloudPassword]];
    
    
}


- (IBAction)cloudSaveLoginData:(id)sender {
    
    //NSLog(@"Username:%@", [textFieldUsername stringValue]);
    //NSLog(@"Password:%@", [textFieldPassword stringValue]);
    
    [self setCloudUserName:[textFieldUsername stringValue]];
    
    NSData * logindata = [ [NSString stringWithFormat:@"username=%@&password=%@&gethash=true", [textFieldUsername stringValue], [textFieldPassword stringValue]] dataUsingEncoding:NSUTF8StringEncoding];

    //Ready for upload
    [sessionDelegate requestURL:[NSURL URLWithString:@"validateuser" relativeToURL:[sessionDelegate snapshooterCloudURL]]
                       withData: logindata];

    [self startProgressWindow ];
    //Below Will be done when when response received from the server
    //[self authenticateCloudUser];

}

-(void) validationCompleted: (NSString *) status hash:(NSString *) hash userid: (NSString *) userId {
    
    //NSLog(@"Validation status: %@ %@ %@", status, hash, userId);
    
    NSAlert *alert = [[NSAlert alloc] init];
    
    if ([status isEqualToString:@"SUCCESS"]) {
    
        [self setCloudPassword:hash];
        [self setUserId:userId];
        [self authenticateCloudUser];
        
        [alert setMessageText:@"Successfully connected."];
        
    } else {
        
        [alert setMessageText:@"Authentication failed. Check your username/password and try again."];
        
        //[self incerementAuthRetryCounter];
    }
    
    [self stopProgressWindow ];


    //Alert user
    [alert runModal];
    
    /*
    //Show only first time
    if (authRetryCounter == 1) {


        
    }
     */
    
}

- (IBAction)test:(id)sender {

#ifdef DEBUG
    NSLog(@"Image view visible: %@", (![mImageBrowser2 isHidden])?@"VISIBLE":@"NOT VISIBLE!");
    NSLog(@"browserScrollView2  visible: %@", (![browserScrollView2 isHidden])?@"VISIBLE":@"NOT VISIBLE!");
    NSLog(@"mGalleryView  visible: %@", (![mGalleryView isHidden])?@"VISIBLE":@"NOT VISIBLE!");
#endif
    
    [labelPanelCaptureStatus setStringValue:@"Started"];
    [panelCaptureStatus makeKeyAndOrderFront:self];
    
}
- (IBAction)test2:(id)sender {
    
    [self setAppLayout: NSGalleryLayout];
    
}

- (IBAction)clickDoneSettingsWindow:(id)sender {
    
    //What user see is important, so set set stepper
    [self textFieldSnapshotTakingIntervalChanged:nil];
    //Save the value
    [self setSnapshotTakingInterval: [stepperSnapshotTakingInterval integerValue]];

    if (self.recordingStatus == NSRecordingStarted) {
        
        [self restartEventListener];
        
    }
    
    [windowSettings orderOut:self];
    
}

- (IBAction)clickButPeriodSelection:(id)sender {
    
    NSSegmentedCell * segment = (NSSegmentedCell *)[(NSSegmentedControl * ) sender selectedCell];
    
    #ifdef DEBUG
    NSLog(@"clickButPeriodSelection - Current selection: %ld",
    
          [ segment tagForSegment:[segment selectedSegment] ]     );

    ;
    #endif
    //Use tag from the button (i.e. 1,2,3..) to match NSPeriodSelection
    //[self setCurrentSelection:[(NSSegmentedControl * ) sender selectedSegment] +1 ];
    
    NSInteger senderTag = [ segment tagForSegment:[segment selectedSegment] ];
    
    switch (senderTag) {
            
        case 0 :
        case 1 :
        case 2 :
        case 3 :    [self setCurrentSelection:senderTag];
                    [self reloadData];
                    break;
        case 4 :
                    [self clickButPickDates:nil];
                    break;
        default:
                    NSLog(@"***TAG IS NOT DEFINED!!!!!!");
            
    }

    
}

- (void) deleteDownloadedSnapshotsAndReload {
    
//    [self deleteDownloadedSnapshots];
    NSLog(@"Delete downloaded snapshots and reload");
    [self setCurrentSelection:NSPeriodSelectionToday];
    
    [self reloadData];
}

- (void) deleteExpiredSnapshots {
    
    //NSLog(@"Checking for expiry records");
    
    if ( ([self storageAllowance] * pow(1024, 3)) < [self getTotalSnapshotSize] ) {
        
        NSUInteger pointId = [self findExpiryPoint];

        //NSLog(@"1Gb limit point: %ld", pointId);
        //NSLog(@"Min imported point: %ld", [self getMinImportedImageId]);
        
        //To avoid deletion reloaded files remove only starting from minimum current loaded image
        //pointId = (pointId > [self getMinImportedImageId]?pointId:([self getMinImportedImageId]-1));
        
        //NSLog(@"Deleting from point: %ld", pointId);
        
        [self deleteSnapshotsFromDBLessId:pointId];
        
    }
    
    
}

- (IBAction)snapshootItMenuClicked:(id)sender {
    
    NSEvent * customeEvent = [NSEvent otherEventWithType:NSApplicationDefined
                                                location:NSMakePoint(0, 0)
                                           modifierFlags:NSDeviceIndependentModifierFlagsMask
                                               timestamp:NSTimeIntervalSince1970
                                            windowNumber:0
                                                 context:nil
                                                 subtype:NSApplicationDefined
                                                   data1:NSSnapManual
                                                   data2:0];
    
    [self takeSnapshotForEvent:customeEvent];
}

- (IBAction)stopMenuClicked:(id)sender {
    
    [self stopScreenCapture];
    
}

- (IBAction)startMenuClicked:(id)sender {
    
    [self startScreenCapture];
    
}

- (IBAction)openMenuClicked:(id)sender {

    if ([window isMiniaturized]) {
    
        [window deminiaturize:self];
        
    }
    
    [window makeKeyAndOrderFront:self];
    
    //[window makeKeyAndOrderFront:self];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    
    
}

- (IBAction)hideMenuClicked:(id)sender {
    
    [window performMiniaturize:self];
    
}

- (IBAction)exitMenuClicked:(id)sender {
    
    //[self stopScreenCapture];
    
    [[NSApplication sharedApplication] terminate:self ];
    
}

- (IBAction)preferencesMenuClicked:(id)sender {

    [self buttonSettingsClicked:self];
}

- (IBAction)standardViewClicked:(id)sender {
    
    [butSwitchLoyout setSelectedSegment:0];
    [self clickButSwitchLayout:butSwitchLoyout];
    
}

- (IBAction)galleryViewClicked:(id)sender {
    
    [butSwitchLoyout setSelectedSegment:1];
    //[butSwitchLoyout setSelected:YES forSegment:1];
    [self clickButSwitchLayout:butSwitchLoyout];
}

- (IBAction)saveImageOnDisk:(id)sender {
    
    if (![self checkIfAnythingSelected]) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:@"Nothing is selected!"];
        [alert runModal];
        
        return;
    }
    
    
    //Get selected image object
    KMImageObject * anImage;
    NSUInteger currentIndex = [[selectedImageBrowser selectionIndexes] firstIndex];
    anImage = [mImages objectAtIndex:currentIndex];
    
    NSSavePanel* panel = [NSSavePanel savePanel];
    
    KMDateTimeFormatters *dateTimeFormatters = [[KMDateTimeFormatters alloc] init];
    [panel setNameFieldStringValue:[NSString stringWithFormat:@"Snapfile_%@.png", [[dateTimeFormatters dateTimeFormatter] stringFromDate: [anImage imageCreateDate]]]];
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton)
        {
            //NSURL*  theFile = [[panel URL] URLByAppendingPathExtension:@"png"];
            NSURL*  theFile = [panel URL];
            
            //NSLog(@"File to save as: %@", [theFile path]);
            
            
            [self saveCurrentImageAsFile:theFile];
            
            // Write the contents in the new format.
        }
        
        
    }];
    
}

- (IBAction)deleteSelectedImages:(id)sender {
    
    
    NSAlert *alert= [[NSAlert alloc] init];;
    
    if (![self checkIfAnythingSelected]) {
        
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:@"Nothing is selected!"];
        [alert runModal];
        
        return;
    }
    
    
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert setMessageText:@"Are you sure to delete selected snapshot(s)?"];
    
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"Cancel"];
    
    
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        
        
        //NSLog(@"Ok to delete");
        
        [self deleteSelectedImageFiles];
        //Rest of your code goes in here.
    };
    
    
}


-(void) setUsageIndicator {
    
    NSNumber * strogeAllowance = [NSNumber numberWithInteger: [self storageAllowance]];
    
    [usageIndicator setMaxValue:[strogeAllowance doubleValue]*10]; //We multiply to make it look nice
    [usageIndicator setWarningValue:([strogeAllowance doubleValue]*0.8*10)]; //80%
    [usageIndicator setCriticalValue:([strogeAllowance doubleValue]*0.9*10)]; //90%
    [usageIndicator setDoubleValue:(double)[self getTotalSnapshotSize]/1024/1024/1024*10];
    
    //NSLog(@"Val %f", [strogeAllowance doubleValue]*0.8*10 );
    
}


- (void)updateBoundControllerLoOrHi:(NSString*)loOrHi value: (double)val {
    
    
    NSDate *fromDate;
    NSDate *toDate;
    NSDate *setDate;
    NSNumber * hiValue = [NSNumber numberWithInteger:val];
    NSNumber * loValue = [NSNumber numberWithInteger:val];
    
    
    //KMDateTimeFormatters *dateTimeFormatters = [[KMDateTimeFormatters alloc] init];
    
    
    [self calculateDatesFromLoHi: loValue hivalue:hiValue fromdate:&fromDate todate:&toDate];
    
    //Set date depending of caller
    setDate = [loOrHi compare:@"Hi"] ? toDate : fromDate;
    
    //NSLog(@"Date: %@ %@", setDate, [[dateTimeFormatters getTimeFormatter] stringFromDate:setDate ]);
    
    //[labelPanelDate setStringValue:[[dateTimeFormatters dateFormatter] stringFromDate:setDate ] ];
    //[labelPanelTime setStringValue:[[dateTimeFormatters timeFormatter] stringFromDate:setDate ] ];
    
    [panelShowTime makeKeyAndOrderFront:self];
}

- (void) leftKnobMoved:(NSEvent *)theEvent {
    
    [panelShowTime orderOut:self];
    
    [self setDoubleSliderLoValue:[doubleSlider leftKnobValue]];
    
    //NSLog(@"leftKnobMoved. Value=%@", [doubleSlider leftKnobValue]);
    
    [self reloadImageBrowser];
}

- (void) rightKnobMoved:(NSEvent *)theEvent {
    
    [panelShowTime orderOut:self];
    
    [self setDoubleSliderHiValue:[doubleSlider rightKnobValue]];
    
    //NSLog(@"rightKnobMoved. Value=%@", [doubleSlider rightKnobValue]);
    
    [self reloadImageBrowser];
}


- (void) leftKnobDragged:(NSEvent *)theEvent {
    
   // NSLog(@"Dragging left knob. Value=%@", [doubleSlider leftKnobValue]);
    
    [self updateBoundControllerLoOrHi:@"Lo" value:[[doubleSlider leftKnobValue] doubleValue]];
    
}

- (void) rightKnobDragged:(NSEvent *)theEvent {
    
   // NSLog(@"Dragging right knob. Value=%@", [doubleSlider rightKnobValue]);
    
    [self updateBoundControllerLoOrHi:@"Hi" value:[[doubleSlider rightKnobValue] doubleValue]];
}


- (void) userDidAuthenticate {
    
    //Call sync after screen set up is completed
    
    //Do we NEED IT????
    [self syncDevices];
    
}



- (void) HTTPrespondReceived:(NSData *)data {
    
    //NSLog(@"HTTP Response: %@", data);
    
}

- (void) fileDidUpload: (KMImageObject *) uploadedFile {
    
    [self updateFileDBStatus:uploadedFile.imageFileName status:@"local/remote" downloadSeq:0];
                 //downloadSeq:uploadedFile.downloadSeq];
    
}

- (void) fileDidDownload: (KMImageObject *) downloadedFile {
    
    [self updateFileDBStatus:downloadedFile.imageFileName status:@"local/remote" downloadSeq:0];
                 //downloadSeq:downloadedFile.downloadSeq];
    
    [self showImage:downloadedFile];
    
    [self stopProcessIndicator];
    
    //NSLog(@"Download completed for: %@", downloadedFile.fileName);
}


- (void) uploadNewSnapshots {
    
    //Check if internet/server available before proceeding
    //Also check if subscribed user
    if (!self.ifSignedUp || !sessionDelegate.isInternetAvailable) {
      
        //NSLog(@"Internet not available to upload snaps!");
        
        return;
    }
    
//    NSLog(@"Starting upload proc");
    
    NSArray * localSnapshots = [self getLocalSnapshots];
    NSString * fileName, * createDate, * screenName, * deviceId, * localId;
    
    if (localSnapshots == nil) {
        // nothing needs to be done
    } else {
        
        //Loop and upload all
        for (NSManagedObject * record in localSnapshots) {
            
            fileName = [record valueForKey:@"filename"];
            
            createDate = [[[KMDateTimeFormatters alloc] initWithDateTimeFormat:@"yyyyMMdd" timeFormat:@"HHmmss"].numberDateTimeFormatter stringFromDate:[record valueForKey:@"createdate"]];
            screenName = [record valueForKey:@"screenname"];
            deviceId = [self deviceUUID];
            localId = [record valueForKey:@"id"];
            
            //Format date
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            
            NSString * createday = [dateFormatter stringFromDate:[record valueForKey:@"createdate"]];
            
            if (fileName && createDate && screenName && deviceId) {
                
                NSURL * file  = [NSURL URLWithString:fileName relativeToURL:[self.snapshotsPathUrl URLByAppendingPathComponent:createday isDirectory:TRUE]];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:[file path]]) {
                
                    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          screenName, @"screenname",
                                          createDate, @"createdate",
                                          deviceId, @"deviceid",
                                          [file absoluteString], @"file",
                                          localId, @"localid",
                                          nil];
                    
                    //Ready for upload
                    [sessionDelegate uploadFile:dict];

                    
                } else {
                    
                    NSLog(@"File does not exists! %@", file.path);
                }
                
            }
            
        }
        
    }
    
    
}

- (void) showPopOverWithMessage: (NSString *) message {
    
    [labelPopOverMessage setStringValue:message];
    
    [[self popover] showRelativeToRect:[[statusItem button] bounds] ofView:[statusItem button] preferredEdge:NSMinYEdge];
    
    autoHidePopOver = [NSTimer scheduledTimerWithTimeInterval:10 
                                     target:self
                                   selector:@selector(hidePopOver)
                                   userInfo:nil
                                    repeats:NO];
    
}


- (void) hidePopOver {
    
    [popover close];
    
    [autoHidePopOver invalidate];
    
}

- (IBAction)textFieldSnapshotTakingIntervalChanged:(id)sender {
    
    //NSLog(@"Text field value: %ld", [textFieldSnapshotTakingInterval integerValue]);
    
    [stepperSnapshotTakingInterval setIntegerValue:[textFieldSnapshotTakingInterval integerValue]];
    
}

- (void) syncDevices {
    
    //NSLog(@"SYNC called");
    

    NSMutableArray *allScreens = [[NSMutableArray alloc] init];

    int i;
    
    NSArray * screenlist = [self getScreenListFromDB];
    
    
    //Check just in case
    if ([screenlist count] == 0 ) {
        
        return;
    }
    
    for(i = 0; i < [screenlist count]; i++) {
        
        NSString * screenStr = [screenlist[i] valueForKey:@"screenname"];
        
        NSDictionary *screen =  [[NSDictionary alloc] initWithObjectsAndKeys:[self deviceUUID], @"id",
                                                                              @"PC", @"type",
                                                                              screenStr, @"screen",
                                                                              nil];
        [allScreens addObject:screen];
    }
    
    NSDictionary *devices = [[NSDictionary alloc] initWithObjectsAndKeys: allScreens, @"devices", nil];
    
    NSError *error = nil;

    NSLog(@"SYNC devices: %@", devices);
    
    NSData * devicelist = [NSJSONSerialization dataWithJSONObject:devices
                                                          options:0
                                                            error:&error];
    
    NSString * jsonStr = [[NSString alloc] initWithData:devicelist encoding:NSUTF8StringEncoding];
    
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    //NSDictionary *requestDict = [[NSDictionary alloc] initWithObjectsAndKeys: jsonStr, @"devicelist", nil];
    
    
    
    NSLog(@"JSON Str: %@", jsonStr);
    
    //Ready for upload
    [sessionDelegate requestURL:[NSURL URLWithString:@"syncdevices" relativeToURL:[sessionDelegate snapshooterCloudURL]]
                       withData: [ [NSString stringWithFormat:@"devicelist=%@", jsonStr] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
    
}


- (void) saveCurrentImageAsFile: (NSURL *) fileUrl {
    
    NSIndexSet *selectionIndexes = [selectedImageBrowser selectionIndexes];
    KMImageObject * anImage;
    NSAlert *alert = [[NSAlert alloc] init];
    
    
    if ([selectionIndexes count] > 0)
    {
    
        anImage = [mImages objectAtIndex:[selectionIndexes firstIndex]];
    
    } else {
        
            [alert setAlertStyle:NSWarningAlertStyle];
            [alert setMessageText:@"File not selected!"];
            [alert runModal];
        return;
    }
                               
    NSURL * currentFile = [[[self snapshotsPathUrl] URLByAppendingPathComponent:[anImage imageCreateDay] isDirectory:TRUE] URLByAppendingPathComponent :[anImage imageFileName]] ;
    
    NSError * error;
    
    NSFileManager * fm = [NSFileManager defaultManager];
    
    if ([ fm fileExistsAtPath:[fileUrl path]]) {
        
        [fm removeItemAtURL:fileUrl error:&error];

    }
    
    if (error) {
        
        [NSApp presentError:error];
        return;
    }
    
    [fm copyItemAtURL:currentFile toURL:fileUrl error:&error];

    
    
    if ((error == nil) || (error == NO)) {
    
        //OK
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:@"File successfully saved."];
        [alert runModal];
        
    } else {
        
        //NOT OK
        [NSApp presentError:error];
        
    }
    
    
}

- (void) deleteSelectedImageFiles {
    
    NSIndexSet *selectionIndexes = [selectedImageBrowser selectionIndexes];
    KMImageObject * anImage;
    NSAlert *alert = [[NSAlert alloc] init];
    
    bool deleteResult = true;
    
    if ([selectionIndexes count] == 0) {
        
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert setMessageText:@"File not selected!"];
        [alert runModal];
        return ;
    }
    
    // Forward
    NSUInteger currentIndex = [selectionIndexes firstIndex];
    while (currentIndex != NSNotFound) {

        anImage = [mImages objectAtIndex:currentIndex];
        
        NSPredicate * condition =  [NSPredicate predicateWithFormat:@" id = %ld", [anImage imageId]];
        
        deleteResult = deleteResult & [self deleteSnapshots:condition permanently:YES];
        
        currentIndex = [selectionIndexes indexGreaterThanIndex:currentIndex];
    }
   
    
    if (deleteResult) {
        
        //Reload data automatically
        [self reloadData];
        
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:@"File(s) successfully deleted!"];
        [alert runModal];
        
        [self selectIndexElementAndScroll:[selectionIndexes lastIndex]-[selectionIndexes count]+1];
        //deletedIndexID = lastDeletedIdTmp;
    } else {
        
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert setMessageText:@"One or more files can not be deleted!"];
        [alert runModal];
        
    }
    
}

- (void) makeDeleteRequestToServer: (NSArray *) filestoDelete {
    
    int limit = 0;
    NSMutableArray * ids = [[NSMutableArray alloc] init];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    
    //Loop and delete all
    for (NSManagedObject * record in filestoDelete) {
        
        NSDictionary *id =  [[NSDictionary alloc] initWithObjectsAndKeys:
                             [record valueForKey:@"id"], @"id",
                             [record valueForKey:@"screenname"], @"scr",
                             [dateFormatter stringFromDate:[record valueForKey:@"createdate"]], @"dt",
                             [record valueForKey:@"filename"], @"fn",
                             nil];
        
        [ids addObject:id];
        //insertValue:[record valueForKey:@"id"] inPropertyWithKey:@"id"];
        //[ids addObject:[record valueForKey:@"id"]];
        
        
        //Delete in portions..
        if (++limit > 40) {
            
            limit = 0;
            break;
        };
    }
    
    if ((ids == nil || [ids count] == 0)) {
        
        return;
    }
    
    NSDictionary *deleteList = [[NSDictionary alloc] initWithObjectsAndKeys:
                                ids, @"deletelist",
                                [self deviceUUID], @"deviceid",
                                nil];
    
    NSError *error;
    NSData * dList = [NSJSONSerialization dataWithJSONObject:deleteList
                                                     options:0
                                                       error:&error];
    
    NSString * jsonStr = [[NSString alloc] initWithData:dList encoding:NSUTF8StringEncoding];
    
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    //NSDictionary *requestDict = [[NSDictionary alloc] initWithObjectsAndKeys: jsonStr, @"ids", nil];
    
    
    
    NSLog(@"JSON Str: %@", jsonStr);
    
    //Ready for upload
    [sessionDelegate requestURL:[NSURL URLWithString:@"deletesnaps" relativeToURL:[sessionDelegate snapshooterCloudURL]]
                       withData: [ [NSString stringWithFormat:@"ids=%@", jsonStr] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
}

- (void) removeDeletedRecords {
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:snapshots];

    NSString *  filterStr =  @"status = \"deleted\" ";
    
    //Add filter condition
    NSPredicate * cond = [NSPredicate predicateWithFormat:filterStr];
    
    [fetchRequest setPredicate:cond];
    
    NSError *error;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
    if ([self ifSignedUp]) {
        
        [self makeDeleteRequestToServer:fetchedObjects];
        
    } else {
        
            //Delete all
            for (NSManagedObject * record in fetchedObjects) {
                [[self managedObjectContext] deleteObject:record];
                [[self managedObjectContext] save:&error];
                [[self managedObjectContext] refreshObject:record mergeChanges:NO];
            }
        
    }
    
    
}


- (bool) checkIfAnythingSelected {
    
    NSIndexSet *selectionIndexes = [selectedImageBrowser selectionIndexes];

    return [selectionIndexes count] > 0;
    
}



- (void) adjustMiddlePanel {
    
#ifdef DEBUG
    NSLog(@"Adjust middle panel");
#endif
    
    float adjustVal =  mTopBarView.frame.size.height + mStatusBarView.frame.size.height;
    
    NSRect rc = NSMakeRect(leftMenuPanelScrollView.frame.size.width+1, mStatusBarView.frame.size.height
                           , window.frame.size.width - leftMenuPanelScrollView.frame.size.width
                           , window.frame.size.height-adjustVal-63);
    
    //Adjust height of middle panel
    [mMiddlePanel setFrame:rc];

    rc.origin.x = 0;
    [mMiddleView setFrame:rc];
    //[mImageView setFrame:rc];
    
    //[mBottomPanelView setHidden:YES];
    //[[mBottomPanelView  animator] setAlphaValue:0.0f];

}

- (void) hideBottomScrollView {
    
#ifdef DEBUG
    NSLog(@"Hide bottom scroll view.");
#endif
  
    //[[mBottomPanelView  animator] setHidden:YES];
    

    // Perform the animations
    [NSAnimationContext beginGrouping];
    // Animate enclosed operations with a duration of 1 second
    [[NSAnimationContext currentContext] setDuration:1.0];
    
    [[mBottomPanelView  animator] setHidden:YES];

    [NSAnimationContext endGrouping];

}

- (void) showBottomScrollView {
    
#ifdef DEBUG
    NSLog(@"Show bottom scroll view.");
#endif
    
    if ([self appLayout] != NSStandardLayout
        ||
        ([self selectedSnapshotCount] == 0) ) {
     
        return; //No need
    }
    
    float adjustVal =  mTopBarView.frame.size.height + mStatusBarView.frame.size.height;
    
    NSRect rc = NSMakeRect(0, mStatusBarView.frame.size.height+bottomPanelHeight
                           , window.frame.size.width
                           , window.frame.size.height-adjustVal-bottomPanelHeight-65);
    
    rc.origin.y = 0;

    //**[browserScrollView setScrollerStyle:NSScrollerStyleOverlay];
    //**[browserScrollView setHasHorizontalScroller:YES];

    [mBottomPanelView removeFromSuperview];
    [mMiddlePanel addSubview:mBottomPanelView positioned:NSWindowAbove relativeTo:mImageView];

    //NOTE: Animation property is set in the Core Animatio panel of the Inspector panel (look for fade option)
    [NSAnimationContext beginGrouping];
        // Animate enclosed operations with a duration of 1 second
        [[NSAnimationContext currentContext] setDuration:1.0];
        [[mBottomPanelView  animator] setHidden:NO];
    
    [NSAnimationContext endGrouping];


    
}


- (void) hideLeftScrollView {
    
    #ifdef DEBUG
    NSLog(@"Hide left scroll view");
    #endif
    
    //[mGalleryView setHidden:YES];
    //[[mGalleryView  animator] setAlphaValue:0.0f];
    
    [NSAnimationContext beginGrouping];
    // Animate enclosed operations with a duration of 1 second
    [[NSAnimationContext currentContext] setDuration:1.0];
    [[mGalleryView  animator] setHidden:YES];
    
    [NSAnimationContext endGrouping];
    
}

- (void) showLeftScrollView {
    
    #ifdef DEBUG
    NSLog(@"Show left scroll view");
    #endif
    
    if ([self appLayout] != NSGalleryLayout
        ||
        ([self selectedSnapshotCount] == 0) ) {
        
        return; //No need
    }
    
     
    [browserScrollView2 setScrollerStyle:NSScrollerStyleOverlay];
    [browserScrollView2 setHasHorizontalScroller:NO];
    [browserScrollView2 setHasVerticalScroller:YES];

    [mGalleryView removeFromSuperview];
    [mMiddlePanel addSubview:mGalleryView positioned:NSWindowAbove relativeTo:mImageView];
    
    
    //**[self.imageView2.layer addAnimation:transition forKey:@"transition"];
    //**[self.imageView setHidden:YES];
    
    //Show Gallery view
    //[mGalleryView setHidden:NO];
    //[[mGalleryView  animator] setAlphaValue:1.0f];
    [NSAnimationContext beginGrouping];
    // Animate enclosed operations with a duration of 1 second
    [[NSAnimationContext currentContext] setDuration:1.0];
    [[mGalleryView  animator] setHidden:NO];
    
    [NSAnimationContext endGrouping];

    
    
    
    
}
/*
-(void) expandMiddlePanel {
    #ifdef DEBUG
    NSLog(@"Expand middle panel view++");
    #endif
    
    //Panel set up
    //float adjustVal =  mTopBarView.frame.size.height + mStatusBarView.frame.size.height;
    
    [mMiddlePanel setFrame:NSMakeRect(0,
                                      bottomPanelHeight + mStatusBarView.frame.size.height-1,
                                      mMiddlePanel.frame.size.width,
                                      mMiddlePanel.frame.size.height
                                      //window.frame.size.height - bottomPanelHeight - adjustVal-63
                                      )];
    
    
    
    //Internal view (in Panel)
    NSRect middleViewFrame = [mMiddleView frame];
    //NSLog(@"middleViewFrame.size.height:%f", middleViewFrame.size.height);
    
    middleViewFrame.origin.x = 10;
    middleViewFrame.origin.y = 10;
    middleViewFrame.size.width = window.frame.size.width-20;
    middleViewFrame.size.height = mMiddlePanel.frame.size.height-20;
    [mMiddleView setFrame:middleViewFrame];

    //Image view
    middleViewFrame.origin.x = 0;
    middleViewFrame.origin.y = 0;
//    middleViewFrame.size.width = middleViewFrame.size.width-20;
//    middleViewFrame.size.height = middleViewFrame.size.height-20;
    [mImageView setFrame:middleViewFrame];
    

          
}
*/




- (void) setAppLayout:(NSAppLayout)appLayout {


    NSSize imageCellSize;
    NSSize imageInterCellSpacing;

    
    switch(appLayout) {
        case NSStandardLayout: {
            
            #ifdef DEBUG
            NSLog(@"****Setting standard layout");
            #endif
            //Adjust image cell
            imageCellSize.height = 77;
            imageCellSize.width = 124;
            imageInterCellSpacing.height = 77;
            imageInterCellSpacing.width = 10;

            
            selectedImageBrowser = mImageBrowser;
            selectedScrollView = browserScrollView;
            

            [self hideLeftScrollView];
            //[self expandMiddlePanel];

            if ([self selectedSnapshotCount] == 0) {
                
                [self hideBottomScrollView];

            } else {

                [self showBottomScrollView];
                
            }
            
            break;
        }
            
        case NSGalleryLayout:
            
            #ifdef DEBUG
            NSLog(@"****Setting Gallery layout");
            #endif

            //Adjust image cell
            imageCellSize.height = 50;
            imageCellSize.width = 80;
            imageInterCellSpacing.height = 10;
            imageInterCellSpacing.width = 10;

            NSRect rc = [mGalleryView frame];
            /*rc.origin.x   = mMiddlePanel.frame.size.width/8;
            rc.size.width = mMiddlePanel.frame.size.width-rc.origin.x*2;
            rc.origin.y = (mMiddlePanel.frame.size.height/8);
            rc.size.height = rc.origin.y * 6;*/
            
            rc.origin.x   = mMiddlePanel.frame.size.width/8;
            rc.size.width = mMiddlePanel.frame.size.width-rc.origin.x*2;
            rc.origin.y = 0;
            rc.size.height = mMiddlePanel.frame.size.height/2;
            [mGalleryView setFrame:rc];
            //NSLog(@"Gallery tracking area rect SET: %@", NSStringFromRect(rc));
            
            
            //Switch image browser to Gallery one
            selectedImageBrowser = mImageBrowser2;
            selectedScrollView = browserScrollView2;


            [self hideBottomScrollView];
            
            [self showLeftScrollView];
            
            [mMiddlePanel updateTrackingAreas];

            break;
    }


    //Adjust the ImageBrowser
    [selectedImageBrowser setZoomValue:2.0f];
    [selectedImageBrowser setCellSize:imageCellSize];
    [selectedImageBrowser setIntercellSpacing:imageInterCellSpacing];
    //--------------------

    _appLayout = appLayout;
    
    [mMiddlePanel setNeedsLayout:YES];
    [mMiddleView setNeedsDisplay:YES];

    
}


- (void) imageViewMouseMovedFrom: (NSPoint) fromPoint to: (NSPoint) toPoint {
    
    //NSLog(@"Current position x=%fl y=%f", imageSubLayer.position.x, imageSubLayer.position.y);
    //NSLog(@"Move layer by x=%fl y=%f", toPoint.x-fromPoint.x, toPoint.y-fromPoint.y);
    
    //[imageLayerDelegate setMoveImage:NSMakePoint(toPoint.x-fromPoint.x, toPoint.y-fromPoint.y)];
    
    [imageSubLayer setPosition:NSMakePoint(imageSubLayer.position.x + toPoint.x-fromPoint.x, imageSubLayer.position.y + toPoint.y-fromPoint.y)];
    //NSLog(@"New position x=%fl y=%f", imageSubLayer.position.x, imageSubLayer.position.y);
    //[imageSubLayer setNeedsDisplay];
}

- (void) showAvailabLePanels {
    
#ifdef DEBUG
    NSLog(@"Show available panels");
#endif
    
    [self showBottomScrollView];
    [self showLeftScrollView];
    [self addPopupUserMenuView];
    
    //Auto hide
    [self hideAvailablePanels];
}

- (void) _hideAvailablePanels {

    //Check mouse locations
    NSWindow * wdw = [self window];

    NSPoint mousePosInView= [wdw.contentView convertPoint:wdw.mouseLocationOutsideOfEventStream
                                                   toView:mMiddlePanel];
    
    
#ifdef DEBUG
    //NSLog(@"Mouse position in view:%@", NSStringFromPoint([wdw mouseLocationOutsideOfEventStream]));
    //NSLog(@"mousePosInView:%@", NSStringFromPoint(mousePosInView));
    //NSLog(@"mMiddlePanel bounds:%@", NSStringFromRect(mMiddlePanel.bounds));
    //NSLog(@"mFilterPanelView frame:%@", NSStringFromRect(mFilterPanelView.frame));
#endif
    
    
    if ((mousePosInView.y <= mMiddlePanel.bounds.size.height
        && mousePosInView.y >= (mMiddlePanel.bounds.size.height - mFilterPanelView.frame.size.height))
        ||
        (//mousePosInView.y <= mBottomPanelView.bounds.size.height
          mousePosInView.y <= mBottomPanelView.frame.size.height)
        ||
        (mousePosInView.y <= mGalleryView.frame.origin.y + mGalleryView.frame.size.height
         && mousePosInView.y > mGalleryView.frame.origin.y
         && mousePosInView.x <= mGalleryView.frame.origin.x + mGalleryView.frame.size.width
         && mousePosInView.x > mGalleryView.frame.origin.x)){
        
#ifdef DEBUG
    NSLog(@"No need for hiding");
#endif
            
        return; //User hoovering over the menu
    }
    
    
    //[self hideLeftScrollView];
    [self hideBottomScrollView];
    [self hideLeftScrollView];
    [self removeFilterUserMenuView];
    
}

- (void) hideAvailablePanels {
    [self performSelector:@selector(_hideAvailablePanels) withObject:nil afterDelay:1.5];
}


- (void) imageViewMouseClickUp {
    
    [self _hideAvailablePanels];
    
}

- (IBAction)screenListFilterDidChange:(id)sender {
    
#ifdef DEBUG
    NSLog(@"Selected row: %ld", [(NSTableView *)sender selectedRow]);
#endif
    
    //[self setSc]
    
    [self reloadData];

}
@end






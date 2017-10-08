//
//  KMAppDelegate.h
//  The Snapshooter
//
//  Created by Khalid Mammadov on 22/07/2014.
//  Copyright (c) 2014 Mammadov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "KMImageView.h"
#import "KMGraphDoubleSlider.h"
#import "KMSimpleNavigationView.h"
#import "KMPopupUserMenu.h"
#import "KMMiddleView.h"
#import "KMDefaultView.h"
#import "HTTPSessionDelegate.h"
#import "KMDateListTableViewDataSource.h"
#import "KMScreenListTableViewDataSource.h"
#import "KMImageLayerDelegate.h"
#import "KMFilterPanelView.h"


@class IKImageView;

typedef BOOL NSLabelVisibiliy;
enum {
    NSLabelUnhide = false,
    NSLabelHide = true
};


typedef NSInteger NSPeriodSelection;
enum {
    NSPeriodSelectionAll        = 0,
    
    NSPeriodSelectionToday      = 1,
    NSPeriodSelectionYesterday  = 2,
    NSPeriodSelectionBefore     = 3,
    NSPeriodSelectionDay        = 4,
    
    NSPeriodSelectionRange      = 5,
    NSPeriodSelectionNothing    = 6
};

typedef NSInteger NSRecordingStatus;
enum {
    NSRecordingUndefined        = 0,
    NSRecordingStopped          = 1,
    NSRecordingStarted          = 2
};

typedef NSInteger NSAppLayout;
enum {
    NSNoLayout                  = 0,
    NSStandardLayout            = 1,
    NSGalleryLayout             = 2
};

typedef NSInteger NSSnapTypes;
enum {
    NSSnapLeftClick             = 1, //NSLeftMouseDown,
    NSSnapRightClick            = 3, //NSRightMouseDown,
    NSSnapScroll                = 22,//NSScrollWheel,
    NSSnapTimer                 = 998,
    NSSnapManual                = 999
};

@interface KMAppDelegate : NSObject <NSApplicationDelegate>
{
    
    
    NSDictionary            * mImageProperties;
    NSString                * mImageUTType;
    NSMutableArray          * mImages;
    //NSMutableArray        * mImportedImages;
    //NSString              * userId;
    
    NSDate                  * defaultDate;

    //DB
    //NSFetchRequest        *fetchRequest, *local_snaps ;
    NSEntityDescription     *screens, *settings, *snapshots;
    
    
    NSArray                 * screenList;
    
    NSInteger               snapshotListBeforeDeactivate;
    
    //NSInteger             authRetryCounter;

    
    NSPoint                 pt;
    
    NSTrackingArea          * trackingArea;
    
    //Event loop
    NSEvent                 * systemEventListener;
    NSTimer                 * snapTakingIntervalSchedule;
    NSTimer                 * expiryCleanSchedule;
    NSTimer                 * uploadSchedule;
    NSTimer                 * reloadSchedule;
    NSTimer                 * freeDiskSpaceControl;
    NSTimer                 * autoHidePopOver;
    NSTimer                 * removeDeletedRecords;
    
    NSButton                * lastSelection;
    
    //For snapshot
    CGDirectDisplayID       * displays;
    HTTPSessionDelegate     * sessionDelegate;
    
    NSStatusItem            * statusItem;
    
    NSColor                 * backgrounColor;
    
    KMSimpleNavigationView  * nextHolderView;
    KMSimpleNavigationView  * backHolderView;
    KMPopupUserMenu         * popupUserMenuView;
    
    NSDictionary*           _imageProperties;
    NSString*               _imageUTType;
    
    KMDateListTableViewDataSource * dateListTableDataSource;
    KMScreenListTableViewDataSource * screenListTableDataSource;

    IKImageBrowserView      * selectedImageBrowser;
    NSScrollView            * selectedScrollView;
    
    
    KMImageLayerDelegate    * imageLayerDelegate;
    CALayer                 * imageSubLayer;
    
    NSString                * autoLauncherIdentifier;
    
    //NSInteger             deletedIndexID;
    float                   bottomPanelHeight ;
    
    int                     freeDiskSpaceMessageCounter;
}

//-------------------------------------------------
//Custom setters
//-------------------------------------------------
@property (nonatomic) NSDate * dateFromSelection;
@property (nonatomic) NSDate * dateToSelection;

@property (nonatomic) NSDate * dateFromMinGlobal;
@property (nonatomic) NSDate * dateToMaxGlobal;

@property (nonatomic) NSNumber * doubleSliderLoValue;
@property (nonatomic) NSNumber * doubleSliderHiValue;

@property (nonatomic) NSString * defaultScreen;

@property (nonatomic) NSPeriodSelection currentPeriodSelection;
@property (nonatomic) NSPeriodSelection previousPeriodSelection;
@property (nonatomic) NSDate * previousSelectionDay;

@property (nonatomic) NSString * deviceUUID;
@property (nonatomic) NSString * userId;

@property (nonatomic) NSNumber * snapshotQuality;
@property (nonatomic) NSInteger snapshotTakingInterval;

@property (nonatomic) NSInteger storageAllowance;
@property (nonatomic) BOOL leftClickCapture;
@property (nonatomic) BOOL rightClickCapture;
@property (nonatomic) BOOL wheelCapture;
@property (nonatomic) BOOL keyCapture;

@property (nonatomic) BOOL ifSignedUp;
@property (nonatomic) NSString * cloudUserName;
@property (nonatomic) NSString * cloudPassword;


@property (nonatomic) NSUInteger nextSequenceId;
@property (nonatomic) int downloadCounter;

@property (nonatomic) NSArray * mImportedImages;
@property (nonatomic) NSUInteger  selectedSnapshotCount;

@property (nonatomic) NSURL *  currentLoadedImageURL;

@property (nonatomic) NSAppLayout  appLayout;

@property (nonatomic) NSRecordingStatus   recordingStatus;

//-------------------------------------------------

//-------------------------------------------------
//Public methods
//-------------------------------------------------
- (void) reloadImageBrowser;
- (NSArray * ) loadSnapshotsFromDbForDatesFrom : (NSDate * ) fromDate toDate: (NSDate *) toDate screenName: (NSString *) screenName;
- (NSUInteger  ) getTotalSnapshotCount;
- (void) calculateDatesFromLoHi: (NSNumber * ) loValue hivalue: (NSNumber *) hiValue
                       fromdate: (NSDate **) fromDate  todate: (NSDate **) toDate ;
- (void) addRightView;
- (void) addLeftView;
- (void) addPopupUserMenuView;
- (void) removeRightView;
- (void) removeLeftView;
//- (void) removePopupUserMenuView;
- (void) selectNextElement;
- (void) selectBackElement;
- (void) scrollImageViewForward ;
- (void) scrollImageViewBackwards;
- (void) HTTPrespondReceived:(NSData *)data;
- (void) userDidAuthenticate;
- (void) updateFileDBStatus: (NSString * ) fileName status: (NSString * ) status  downloadSeq: (NSInteger) downloadSeq ;
- (void) saveCurrentImageAsFile: (NSURL *) fileUrl;
- (void) snapDeletedOnServer: (NSArray *) localids;

- (void) validationCompleted: (NSString *) status hash:(NSString *) hash userid: (NSString *) userId;
- (void) fileDidUpload: (KMImageObject *) uploadedFile;
- (void) fileDidDownload: (KMImageObject *) downloadedFile;
- (NSURL * ) getHostname;
- (bool) checkIfAnythingSelected;
- (void) defineScreenList;
- (void) imageViewMouseMovedFrom: (NSPoint) fromPoint to: (NSPoint) toPoint;
- (void) leftKnobMoved:(NSEvent *)theEvent;
- (void) rightKnobMoved:(NSEvent *)theEvent;
- (void) leftKnobDragged:(NSEvent *)theEvent;
- (void) rightKnobDragged:(NSEvent *)theEvent;
- (void) imageViewMouseClickUp;
- (void) showLeftScrollView;
- (void) showBottomScrollView;
- (void) showAvailabLePanels;
- (void) hideAvailablePanels;
//-------------------------------------------------
    

//This methods also for taking snapshots
- (void)registerEventListener;
//- (void)takeSnapshot: (NSInteger) displayNo;
//----------------------------------

//-------------------------------------------------
//------Outlets------------------------------------
//-------------------------------------------------

@property (readonly, strong, nonatomic) NSURL * snapshotsPathUrl;

@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSPanel *panelShowTime;
@property (unsafe_unretained) IBOutlet NSPanel *panelSelectDateTime;
@property (unsafe_unretained) IBOutlet NSPanel *panelCaptureStatus;
@property (weak) IBOutlet NSPanel *panelDownloadCounter;

@property (weak) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet NSMenuItem *startSnapshootingMenu;
@property (weak) IBOutlet NSMenuItem *stopSnapshootingMenu;



@property (weak) IBOutlet NSToolbarItem             *toolStart;
@property (weak) IBOutlet NSSlider                  *toolZoomSnap;
@property (weak) IBOutlet NSPopUpButton             *popcomboBox;
@property (weak) IBOutlet NSPopUpButton             *snapTypesFilterComboBox;

@property (unsafe_unretained) IBOutlet NSWindow     *windowSettings;

//Views
@property (weak) IBOutlet NSScrollView              *browserScrollView;
@property (weak) IBOutlet NSScrollView *leftMenuPanelScrollView;

@property (weak) IBOutlet NSScrollView *browserScrollView2;

@property (weak) IBOutlet KMImageView               *mImageView;
@property (weak) IBOutlet NSView *mMiddlePanel;

@property (weak) IBOutlet IKImageBrowserView *mImageBrowser2;

@property (weak) IBOutlet IKImageBrowserView        *mImageBrowser;
@property (weak) IBOutlet NSClipView *mImageBrowserClipView;

@property (weak) IBOutlet IKImageView               *mRecordingView;
@property (weak) IBOutlet NSView                    *mMiddleView;
@property (weak) IBOutlet NSView *mGalleryView;
@property (weak) IBOutlet KMSimpleNavigationView    *mNextViewNavigation;
@property (weak) IBOutlet KMSimpleNavigationView    *mBackViewNavigation;
@property (weak) IBOutlet KMPopupUserMenu           *mPopupUserMenu;

@property (weak) IBOutlet KMDefaultView              *mTopBarView;
@property (weak) IBOutlet NSView                    *mStatusView;
@property (weak) IBOutlet KMDefaultView             *mBottomPanelView;

@property (weak) IBOutlet KMFilterPanelView *mFilterPanelView;
@property (weak) IBOutlet KMDefaultView *mStatusBarView;


//Buttons
@property (weak) IBOutlet NSButton *butToday;
@property (weak) IBOutlet NSButton *butYesterday;
@property (weak) IBOutlet NSButton *butBefore;
@property (weak) IBOutlet NSButton *butPickDates;
@property (weak) IBOutlet NSButton *butAllRange;
@property (weak) IBOutlet NSSegmentedControl *butSwitchLoyout;
@property (weak) IBOutlet NSSegmentedControl *butPeriodSelection;

@property (weak) IBOutlet NSButton *leftClickFilterButton;
@property (weak) IBOutlet NSButton *rightClickFilterButton;
@property (weak) IBOutlet NSButton *scrollWheelFilterButton;
@property (weak) IBOutlet NSButton *timerFilterButton;
@property (weak) IBOutlet NSButton *manualFilterButton;


//Misc
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@property (weak) IBOutlet NSButton *butRecordingStartStop;


//Labels
@property (weak) IBOutlet NSTextField *labelTotalSnapshots;
@property (weak) IBOutlet NSTextField *labelToDate;
@property (weak) IBOutlet NSTextField *labelFromDate;
@property (weak) IBOutlet NSTextField *labelPanelDate;
@property (weak) IBOutlet NSTextField *labelPanelTime;
@property (weak) IBOutlet NSTextField *labelRecording;
@property (weak) IBOutlet NSTextField *labelCurrentSelection;
@property (weak) IBOutlet NSTextField *labelPanelCaptureStatus;
@property (weak) IBOutlet NSTextField *labelDownloadCounter;

@property (weak) IBOutlet NSTextField *labelPrefDiskSpace;
@property (weak) IBOutlet NSTextField *labelPopOverMessage;

@property (weak) IBOutlet NSTextField *textFieldSnapshotTakingInterval;


@property (weak) IBOutlet NSLevelIndicator *usageIndicator;

@property (weak) IBOutlet KMGraphDoubleSlider *doubleSlider;

//Date pickers
@property (weak) IBOutlet NSDatePicker *datePickerFrom;
@property (weak) IBOutlet NSDatePicker *datePickerTo;

@property (weak) IBOutlet NSTableView *dateListTableView;
@property (weak) IBOutlet NSTableView *screenListTableView;


//Settings window
@property (weak) IBOutlet NSPopUpButton *popPanelScreenList;
@property (weak) IBOutlet NSSlider *sliderForDiskAllowance;
@property (weak) IBOutlet NSSlider *sliderForQuality;

@property (weak) IBOutlet NSTabView *settingsTabView;
@property (weak) IBOutlet NSView *captureTabView;
@property (weak) IBOutlet NSView *storageTabView;
@property (weak) IBOutlet NSView *qualityTabView;
@property (weak) IBOutlet NSView *cloudTabView;


@property (weak) IBOutlet NSStepper *stepperSnapshotTakingInterval;

@property (weak) IBOutlet NSButton *butDoneSettingWindow;
@property (weak) IBOutlet NSButton *checkLeftClickCapture;
@property (weak) IBOutlet NSButton *checkRightClickCapture;
@property (weak) IBOutlet NSButton *checkWheelClickCapture;
@property (weak) IBOutlet NSButton *checkKeyCapture;
@property (weak) IBOutlet NSButton *checkAutoStart;

@property (assign) IBOutlet NSPopover * popover;

@property (weak) IBOutlet NSTextField *textFieldUsername;
@property (weak) IBOutlet NSSecureTextField *textFieldPassword;

//------End----------------------------------------

//Progress indicator
@property (unsafe_unretained) IBOutlet NSPanel *progressWindow;
@property (weak) IBOutlet NSView *progressView;
@property (weak) IBOutlet NSProgressIndicator *progressBarIndicator;

//------End----------------------------------------


//-------------------------------------------------
//------Actions------------------------------------
//-------------------------------------------------

- (IBAction)snapshootItMenuClicked:(id)sender;
- (IBAction)stopMenuClicked :(id)sender;
- (IBAction)startMenuClicked:(id)sender;
- (IBAction)openMenuClicked :(id)sender;
- (IBAction)hideMenuClicked :(id)sender;
- (IBAction)exitMenuClicked :(id)sender;
- (IBAction)preferencesMenuClicked:(id)sender;
- (IBAction)standardViewClicked:(id)sender;
- (IBAction)galleryViewClicked:(id)sender;
- (IBAction)saveImageOnDisk:(id)sender;
- (IBAction)deleteSelectedImages:(id)sender;


- (IBAction)toolZoomSnapDidChange:(id)sender;
- (IBAction)toolStartClicked:(id)sender;
- (IBAction)toolStopClicked:(id)sender;
- (IBAction)popcomboBoxDidChange:(id)sender;
- (IBAction)snapTypeFilterComboboxDidChange:(id)sender;

- (IBAction)eventFilterButtonSelected:(id)sender;


//- (IBAction)popComboDatesDidChange:(id)sender;

- (IBAction)buttonSettingsClicked:(id)sender;

//- (void) drawRect:(NSRect)rect;
//- (IBAction)doubleSliderDidChange:(id)sender;



//Buttons

- (IBAction)clickButSwitchLayout:(id)sender;

//- (IBAction)selectPeriod:(id)sender;

- (IBAction)clearAllData:(id)sender;

- (IBAction)test:(id)sender;
- (IBAction)test2:(id)sender;
- (IBAction)clickDoneSettingsWindow:(id)sender;

- (IBAction)clickButPeriodSelection:(id)sender;


//Date panel
- (IBAction)clickDoneDatePanel:(id)sender;


//Settings window
- (IBAction)popPanelScreenListDidChange:(id)sender;
- (IBAction)sliderForDiskAllowanceDidChange:(id)sender;
- (IBAction)sliderForQualityDidChange:(id)sender;
- (IBAction)textFieldSnapshotTakingIntervalChanged:(id)sender;
- (IBAction)clickLeftClickCapture:(id)sender;
- (IBAction)clickRightClickCapture:(id)sender;
- (IBAction)clickWheelCapture:(id)sender;
- (IBAction)clickKeyCapture:(id)sender;
- (IBAction)clickAutoStartCheck:(id)sender;

- (IBAction)stepperSnapshotIntervalClicked:(id)sender;

- (IBAction)cloudSaveLoginData:(id)sender;

//Filter menu

- (IBAction)screenListFilterDidChange:(id)sender;

//------End----------------------------------------


//-------------------------------------------------
//------Core data----------------------------------
//-------------------------------------------------

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

//-------End---------------------------------------






@end

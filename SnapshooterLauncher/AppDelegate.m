//
//  AppDelegate.m
//  SnapshooterLauncher
//
//  Created by Khalid Mammadov on 12/02/2016.
//  Copyright © 2016 Mammadov. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    //NSLog(@"Boundle path: %@", [[NSBundle mainBundle] bundlePath]);
    
    NSString *appPath = [[[[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]  stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
    // get to the waaay top. Goes through LoginItems, Library, Contents, Applications
    
    
    //appPath = @"/Users/Khalid/Documents/Dev/Snapshooter/DerivedData/Snapshooter/Build/Products/Debug/Snapshooter.app";
    
    
    [[NSWorkspace sharedWorkspace] launchApplication:appPath];
    [NSApp terminate:nil];
}


@end

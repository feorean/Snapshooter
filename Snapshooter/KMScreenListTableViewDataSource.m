//
//  KMScreenListTableViewDataSource.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 08/03/2016.
//  Copyright © 2016 Mammadov. All rights reserved.
//

#import "KMScreenListTableViewDataSource.h"

@implementation KMScreenListTableViewDataSource

@synthesize screenList;


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    

    NSString *identifier = [tableColumn identifier];
    //NSLog(@"identifier: %@", identifier);
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    
    if ([identifier isEqualToString:@"screens"]) {
        cellView.textField.stringValue = [(NSManagedObject *)screenList[row] valueForKey:@"screenname"];
    }

    if ([identifier isEqualToString:@"img"]) {
        NSImageView *imView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 480, 360)];
        //NSImage *myImage = [[NSImage alloc] initByReferencingFile:@"image.png"];
        [imView setImage:[NSImage imageNamed:@"download_black.png"]];
        cellView.imageView = imView;
    }
    
    return cellView;
    
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(NSInteger)rowIndex {
    
    
    //NSLog(@"Set called");
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return screenList.count;
}

@end

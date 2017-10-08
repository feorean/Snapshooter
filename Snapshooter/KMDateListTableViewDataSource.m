//
//  KMDateListTableViewDataSource.m
//  Snapshooter
//
//  Created by Khalid Mammadov on 04/02/2016.
//  Copyright © 2016 Mammadov. All rights reserved.
//

#import "KMDateListTableViewDataSource.h"

@implementation KMDateListTableViewDataSource


- (id)init
{
    self = [super init];
    if (self)
    {
        snapsDatesList = [NSMutableArray new];
    }
    return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return snapsDatesList.count;
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    
    NSString *identifier = [tableColumn identifier];
    //NSLog(@"identifier: %@", identifier);
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    
    cellView.textField.stringValue = [snapsDatesList[row] valueForKey:identifier];
    
    return cellView;
    
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(NSInteger)rowIndex {
    
    
    //NSLog(@"Set called");
    
}

- (void) addRow:(NSDictionary *) row {
    
    #ifdef DEBUG
    NSLog(@"Row add called!");
    #endif
    
    if ([row count] > 0 ) {
        
        [snapsDatesList addObject:row];
        
        //NSLog(@"Row added!");
        
    }
    
}

- (void) deleteAllRecords {
    
    [snapsDatesList removeAllObjects];
}

- (NSDictionary * ) getRow: (NSInteger) rowIndex {
    
    if (rowIndex > -1 ) {
        
        return snapsDatesList[rowIndex];
    }
    
    return nil;
}


@end

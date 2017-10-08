//
//  KMDateListTableViewDataSource.h
//  Snapshooter
//
//  Created by Khalid Mammadov on 04/02/2016.
//  Copyright © 2016 Mammadov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMDateListTableViewDataSource : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
    
    NSMutableArray * snapsDatesList;
}





- (void) addRow:(NSDictionary *) row;
- (void) deleteAllRecords;
- (NSDictionary * ) getRow: (NSInteger) rowIndex;

@end

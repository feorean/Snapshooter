//
//  KMScreenListTableViewDataSource.h
//  Snapshooter
//
//  Created by Khalid Mammadov on 08/03/2016.
//  Copyright © 2016 Mammadov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMScreenListTableViewDataSource : NSObject <NSTableViewDataSource, NSTableViewDelegate>


@property (nonatomic) NSArray * screenList;

@end

//
//  KMMiddlePanelView.h
//  Snapshooter
//
//  Created by Khalid Mammadov on 19/02/2016.
//  Copyright © 2016 Mammadov. All rights reserved.
//

#import "KMDefaultView.h"

@interface KMMiddlePanelView : KMDefaultView {
    
    NSTrackingArea * popupUserMenu;
    NSTrackingArea * bottomListView;
    NSTrackingArea * galleryListView;
}

- (void) updateTrackingAreas;
@end

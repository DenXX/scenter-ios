//
//  MessageScreen.h
//  Geo
//
//  Created by David Fink on 11/22/13.
//  Copyright (c) 2013 David Fink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MessageScreen : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property CLLocationCoordinate2D location;
@property NSMutableArray *scentsNearby;
@property NSMutableDictionary *fencesWithin;

@end

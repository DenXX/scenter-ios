//
//  MessageInfoView.h
//  Geo
//
//  Created by David Fink on 11/23/13.
//  Copyright (c) 2013 David Fink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

@interface MessageInfoView : UIViewController

@property NSDictionary *scent;
@property NSDictionary *fence;
@property CLLocationCoordinate2D userLocation;

@end

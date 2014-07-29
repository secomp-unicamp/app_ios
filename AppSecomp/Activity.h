//
//  Activity.h
//  AppSecomp
//
//  Created by Guilherme Andrade on 7/29/14.
//  Copyright (c) 2014 Unicamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Activity : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

//
//  Event.h
//  AppSecomp
//
//  Created by Guilherme Andrade on 8/8/14.
//  Copyright (c) 2014 Unicamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *speakerName;
@property (strong, nonatomic) NSString *speakerProfession;
@property (strong, nonatomic) NSString *speakerBiograph;
@property (strong, nonatomic) NSDate *beginTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) UIImage *photo;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

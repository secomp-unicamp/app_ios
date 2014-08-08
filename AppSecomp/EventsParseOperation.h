//
//  EventsParseOperation.h
//  AppSecomp
//
//  Created by Guilherme Andrade on 8/8/14.
//  Copyright (c) 2014 Unicamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventsParseOperation : NSOperation

@property (strong, nonatomic) NSData *jsonData;

- (instancetype)initWithData:(NSData*)jsonData;

@end

//
//  ParseOperation.h
//  RSSFun
//
//  Created by Guilherme Andrade on 7/28/14.
//  Copyright (c) 2014 Unicamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseOperation : NSOperation

@property (strong, nonatomic) NSData *parseData;
- (instancetype)initWithData:(NSData*)parseData;

@end

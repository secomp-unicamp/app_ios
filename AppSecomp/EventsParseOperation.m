//
//  EventsParseOperation.m
//  AppSecomp
//
//  Created by Guilherme Andrade on 8/8/14.
//  Copyright (c) 2014 Unicamp. All rights reserved.
//

#import "EventsParseOperation.h"
#import "Event.h"

@implementation EventsParseOperation

- (instancetype)initWithData:(NSData*)jsonData{
	if( self = [super init] ){
		self.jsonData = jsonData;
	}
	return self;
}

- (void)main{
	NSError *error;
	NSArray *jsonEvents = [NSJSONSerialization JSONObjectWithData:self.jsonData options:NSJSONReadingMutableContainers error:&error];
	if(!error){
		for (NSDictionary *obj in jsonEvents) {
			Event *event = [[Event alloc] init];
			event.type = obj[@"type"];
			event.name = obj[@"name"];
			event.description = obj[@"description"];
			event.speakerName = obj[@"speaker_name"];
			event.speakerProfession = obj[@"speaker_profession"];
			event.speakerBiograph = obj[@"speaker_bio"];
			event.place = obj[@"place"];
			
			NSString *dateString = obj[@"date"];
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"d/M/y H:m"];
			event.beginTime = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", dateString, obj[@"begin_time"]]];
			event.endTime = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", dateString, obj[@"end_time"]]];
			event.photo = [UIImage imageNamed:[((NSNumber*)obj[@"photo"]) stringValue]];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"newEventObjectAvailable" object:event];
			
			event.coordinate = CLLocationCoordinate2DMake([obj[@"latitude"] doubleValue], [obj[@"longitude"] doubleValue]);
		}
	}
}

@end

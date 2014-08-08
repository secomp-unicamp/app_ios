//
//  ScheduleVC.m
//  AppSecomp
//
//  Created by Guilherme Andrade on 7/29/14.
//  Copyright (c) 2014 Unicamp. All rights reserved.
//

#import "ScheduleVC.h"
#import "EventsParseOperation.h"
#import "Event.h"
#import "EventCell.h"

@interface ScheduleVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSOperationQueue *jsonParseQueue;
@property (strong, nonatomic) NSArray *tableViewSectionsTitles;

@end

@implementation ScheduleVC


- (NSArray*)events{
	if(!_events){
		_events = @[[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array], [NSMutableArray array] ];
	}
	return _events;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.jsonParseQueue = [NSOperationQueue new];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewEvent:) name:@"newEventObjectAvailable" object:nil];
	
	static NSString *jsonURLString = @"https://dl.dropboxusercontent.com/u/88107118/secomp_events.json";
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSURLRequest *evensURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:jsonURLString]];
	[NSURLConnection sendAsynchronousRequest:evensURLRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		if(!connectionError){
			EventsParseOperation *parseOperation = [[EventsParseOperation alloc] initWithData:data];
			[self.jsonParseQueue addOperation:parseOperation];
		}
	}];
}

- (void)addNewEvent:(NSNotification*)notification{
	static NSInteger firstDayOfEvents = 11;
	Event *event = (Event*)notification.object;
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:event.beginTime];
	NSInteger dayIndex = components.day - firstDayOfEvents;
	[self.events[dayIndex] addObject:event];

	[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}


#pragma mark - UITableViewDataSourceProtocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [self.events[section] count];
}


- (NSString*)getNumberWithLeftZero:(NSInteger)number{
	if(number/10) return [NSString stringWithFormat:@"%d",number];
	else return [NSString stringWithFormat:@"0%d",number];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellIdentifier = @"Cell";
	EventCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!cell) cell = [[EventCell alloc] init];
	
	Event *event = self.events[indexPath.section][indexPath.row];
	cell.title.text = event.name;
	cell.place.text = event.place;
	
	NSDateComponents *beginTimeComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:event.beginTime];
	NSDateComponents *endTimeComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:event.endTime];
	
	cell.time.text = [NSString stringWithFormat:@"%@:%@ - %@:%@",[self getNumberWithLeftZero:beginTimeComponents.hour], [self getNumberWithLeftZero:beginTimeComponents.minute], [self getNumberWithLeftZero:endTimeComponents.hour], [self getNumberWithLeftZero:endTimeComponents.minute]];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return self.events.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	switch (section) {
		case 0:
			return @"Segunda - 11";
		case 1:
			return @"Terça - 12";
		case 2:
			return @"Quarta - 13";
		case 3:
			return @"Quinta - 14";
		case 4:
			return @"Sexta - 15";
		case 5:
			return @"Sábado - 16";
		default:
			return @"";
	}
}

@end

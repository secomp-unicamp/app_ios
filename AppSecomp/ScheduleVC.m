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
#import "EventDetailsVC.h"

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
	
	
	[self.events[dayIndex] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		
		NSDate *beginTime1 = ((Event*)obj1).beginTime;
		NSDate *beginTime2 = ((Event*)obj2).beginTime;

		NSComparisonResult res = [beginTime1 compare:beginTime2];
		if( res != NSOrderedSame )
			return res;
		else{
			NSDate *endTime1 = ((Event*)obj1).endTime;
			NSDate *endTime2 = ((Event*)obj2).endTime;
			return [endTime1 compare:endTime2];
		}
		
	}];

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
			return @"SEGUNDA - 11";
		case 1:
			return @"TERÇA - 12";
		case 2:
			return @"QUARTA - 13";
		case 3:
			return @"QUINTA - 14";
		case 4:
			return @"SEXTA - 15";
		case 5:
			return @"SÁBADO - 16";
		default:
			return @"";
	}
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
		
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.textColor = [UIColor orangeColor];
		tableViewHeaderFooterView.textLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:17.0];
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if([segue.identifier isEqualToString:@"goToEventDetails"]){
		NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
		EventDetailsVC *nextVC = segue.destinationViewController;
		nextVC.event = self.events[indexPath.section][indexPath.row];
	}
}

@end

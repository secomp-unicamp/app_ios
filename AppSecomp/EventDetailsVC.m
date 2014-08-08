//
//  EventDetailsVC.m
//  AppSecomp
//
//  Created by Guilherme Andrade on 8/8/14.
//  Copyright (c) 2014 Unicamp. All rights reserved.
//

#import "EventDetailsVC.h"
#import <MapKit/MapKit.h>
#import "Event.h"
#import "SpeakerDetailsVC.h"

@interface EventDetailsVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UIButton *speakerNameButton;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation EventDetailsVC




- (NSString*)getWeekdayString:(NSInteger)weekday{
	switch (weekday) {
		case 1:
			return @"Domingo";
		case 2:
			return @"Segunda";
		case 3:
			return @"Terça";
		case 4:
			return @"Quarta";
		case 5:
			return @"Quinta";
		case 6:
			return @"Sexta";
		case 7:
			return @"Sábado";
		default:
			return @"";
	}
}

- (NSString*)getNumberWithLeftZero:(NSInteger)number{
	if(number/10) return [NSString stringWithFormat:@"%d",number];
	else return [NSString stringWithFormat:@"0%d",number];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.titleLabel.text = [NSString stringWithFormat:@"%@: %@",self.event.type, self.event.name];
	self.descriptionTextView.text = self.event.description;
	self.placeLabel.text = self.event.place;
	[self.speakerNameButton setTitle:self.event.speakerName forState:UIControlStateNormal];
	
	
	NSDateComponents *beginTimeComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute | NSCalendarUnitWeekday fromDate:self.event.beginTime];
	NSDateComponents *endTimeComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self.event.endTime];
	
	self.dateLabel.text = [NSString stringWithFormat:@"%@ %@:%@ - %@:%@",[self getWeekdayString:beginTimeComponents.weekday], [self getNumberWithLeftZero:beginTimeComponents.hour], [self getNumberWithLeftZero:beginTimeComponents.minute], [self getNumberWithLeftZero:endTimeComponents.hour], [self getNumberWithLeftZero:endTimeComponents.minute] ];
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if([segue.identifier isEqualToString:@"goToSpeakerDetails"]){
		SpeakerDetailsVC *nextVC = (SpeakerDetailsVC*)segue.destinationViewController;
		nextVC.name = self.event.speakerName;
		nextVC.profession = self.event.speakerProfession;
		nextVC.biograph = self.event.speakerBiograph;
		nextVC.image = self.event.photo;
	}
}


- (IBAction)back:(UIButton *)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)remember:(id)sender {
	//	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
	//	localNotification.fireDate = _dateTime;
	//	localNotification.alertBody = [NSString stringWithFormat:@"Alert Fired at %@",_dateTime];
	//	localNotification.soundName = UILocalNotificationDefaultSoundName;
	//	localNotification.applicationIconBadgeNumber = 1;
	//	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


@end

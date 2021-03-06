//
//  EventDetailsVC.m
//  AppSecomp
//
//  Created by Guilherme Andrade on 8/8/14.
//  Copyright (c) 2014 Unicamp. All rights reserved.
//

#import "EventDetailsVC.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import "Event.h"
#import "SpeakerDetailsVC.h"

@interface EventDetailsVC () <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *titleLabel;
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
			return @"Dom";
		case 2:
			return @"Seg";
		case 3:
			return @"Ter";
		case 4:
			return @"Qua";
		case 5:
			return @"Qui";
		case 6:
			return @"Sex";
		case 7:
			return @"Sab";
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
	self.titleLabel.text = [[NSString stringWithFormat:@"%@: %@",self.event.type, self.event.name] uppercaseString];
	self.descriptionTextView.text = self.event.description;
	self.placeLabel.text = self.event.place;
	[self.speakerNameButton setTitle:self.event.speakerName forState:UIControlStateNormal];
	
	
	NSDateComponents *beginTimeComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute | NSCalendarUnitWeekday fromDate:self.event.beginTime];
	NSDateComponents *endTimeComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self.event.endTime];
	
	self.dateLabel.text = [NSString stringWithFormat:@"%@, %@:%@-%@:%@",[self getWeekdayString:beginTimeComponents.weekday], [self getNumberWithLeftZero:beginTimeComponents.hour], [self getNumberWithLeftZero:beginTimeComponents.minute], [self getNumberWithLeftZero:endTimeComponents.hour], [self getNumberWithLeftZero:endTimeComponents.minute] ];
	
	
	self.mapView.showsUserLocation = YES;

	MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
	[annotation setCoordinate:self.event.coordinate];
	[annotation setTitle:self.event.place];
	[self.mapView addAnnotation:annotation];
	[self.mapView setRegion:MKCoordinateRegionMake(self.event.coordinate, MKCoordinateSpanMake(0.012,0.012)) animated:NO];
	[self.mapView selectAnnotation:annotation animated:YES];
	
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
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmação" message:@"Deseja ser avisado 30 minutos antes do início do evento?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK", nil];
	[alert show];
}
- (IBAction)sendEmailWithFeedback:(UIButton *)sender {
	MFMailComposeViewController *mailComposer;
	mailComposer = [[MFMailComposeViewController alloc]init];
	mailComposer.mailComposeDelegate = self;
	[mailComposer setSubject:[NSString stringWithFormat:@"Feedback Secomp - %@ por %@",self.event.name, self.event.speakerName]];
	[mailComposer setToRecipients:@[@"secomp@unicamp.com.br"]];
	[self presentModalViewController:mailComposer animated:YES];
}

#pragma mark - MFMailComposeViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller
		 didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex){
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.fireDate = [self.event.beginTime dateByAddingTimeInterval:-30*60];
		
		localNotification.alertBody = [NSString stringWithFormat:@"%@ começa em 30 minutos em %@", self.event.name, self.event.place];
		localNotification.soundName = UILocalNotificationDefaultSoundName;
		localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
		[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
	}
}

@end

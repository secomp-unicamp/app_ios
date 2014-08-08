//
//  SpeakerDetailsVC.m
//  AppSecomp
//
//  Created by Guilherme Andrade on 8/8/14.
//  Copyright (c) 2014 Unicamp. All rights reserved.
//

#import "SpeakerDetailsVC.h"

@interface SpeakerDetailsVC ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *professionTextView;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation SpeakerDetailsVC



- (void)viewDidLoad{
    [super viewDidLoad];
	self.nameLabel.text = self.name;
	self.professionTextView.text = self.profession;
	self.bioTextView.text = self.biograph;
	self.imageView.image = self.image;
}

- (IBAction)back:(UIButton *)sender {
	[self dismissModalViewControllerAnimated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

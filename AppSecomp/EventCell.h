//
//  EventCell.h
//  AppSecomp
//
//  Created by Guilherme Andrade on 8/8/14.
//  Copyright (c) 2014 Unicamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *place;

@end

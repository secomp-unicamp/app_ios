//
//  HomeVC.m
//  AppSecomp
//
//  Created by Guilherme Andrade on 7/28/14.
//  Copyright (c) 2014 Unicamp. All rights reserved.
//

#import "HomeVC.h"
#import "ParseOperation.h"
#import "News.h"

@interface HomeVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *newsFeedsList;
@property (strong, nonatomic) NSOperationQueue *parseQueue;

@end

@implementation HomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.newsFeedsList = [NSMutableArray array];
	self.parseQueue = [NSOperationQueue new];
	[self setup];
}

- (void)setup{
	static NSString *feedURLString = @"http://secomp.com.br/feed/";
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSURLRequest *newsFeedURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:feedURLString]];
	[NSURLConnection sendAsynchronousRequest:newsFeedURLRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		if(!connectionError){
			ParseOperation *parseOperation = [[ParseOperation alloc] initWithData:data];
			[self.parseQueue addOperation:parseOperation];
		}
	}];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNews:) name:@"newParsedObjectAvailable" object:nil];
}

- (void)addNews:(NSNotification*)notification{
	
	
	[self.newsFeedsList addObject:notification.object];
	
	[self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
	
}

- (void)updateTableView{
	
	
	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSourceProtocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return [self.newsFeedsList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	
	
	static NSString *cellIdentifier = @"Cell";
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
	News *news = [self.newsFeedsList objectAtIndex:indexPath.row];
	cell.textLabel.text = news.title;
	cell.detailTextLabel.text = news.link;
	
	return cell;
}


@end

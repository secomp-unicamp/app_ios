//
//  AppDelegate.m
//  AppSecomp
//
//  Created by Guilherme Andrade on 7/28/14.
//  Copyright (c) 2014 Unicamp. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)initAparence{
	[[UITabBar appearance] setTintColor:[UIColor orangeColor]];
}

-(void)initializeStoryBoardBasedOnScreenSize {
	
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
		
		CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
		UIStoryboard *storyboard;
		
		if (iOSDeviceScreenSize.height == 480)
			storyboard = [UIStoryboard storyboardWithName:@"iPhone4-" bundle:nil];
		else if (iOSDeviceScreenSize.height == 568)
			storyboard = [UIStoryboard storyboardWithName:@"iPhone5+" bundle:nil];
		
		// Instantiate the initial view controller object from the storyboard
		UIViewController *initialViewController = [storyboard instantiateInitialViewController];
		
		// Instantiate a UIWindow object and initialize it with the screen size of the iOS device
		self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		
		// Set the initial view controller to be the root view controller of the window object
		self.window.rootViewController  = initialViewController;
		
		// Set the window object to be the key window and show it
		[self.window makeKeyAndVisible];
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self initializeStoryBoardBasedOnScreenSize];
	[self initAparence];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[UIApplication sharedApplication].applicationIconBadgeNumber= 0;
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber= 0;

}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lembrete" message:notification.alertBody delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

@end

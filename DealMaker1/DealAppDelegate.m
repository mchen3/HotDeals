//
//  DealAppDelegate.m
//  DealMaker1
//
//  Created by Mike Chen on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DealAppDelegate.h"
#import "DealsViewController.h"
#import "UserViewController.h"
#import "NewsViewController.h"
#import "ItemStore.h"
#import "Parse/Parse.h"
#import "LocationDataManager.h"
#import "WelcomeViewController.h"


@implementation DealAppDelegate

@synthesize window = _window;

#pragma mark - Application Delegation

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
		self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

		// Parse configuration
		[Parse setApplicationId:@"OVEj0O0vxy0Moy3COwIkFGCDUYNcBDhrY54NnzYD" clientKey:@"jxiwzGxKF9Sa47YxlcpksL4RdVVX50dkKpqhiS7h"];		
		
		
		
		
		/* Parse Access Control */
		//[PFUser enableAutomaticUser];
		
		// Optionally enable public read access by default.
    PFACL *defaultACL = [PFACL ACL];
		[defaultACL setPublicReadAccess:YES];
	  //[defaultACL setPublicWriteAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
		
		
		
		//[PFUser logOut];
		
		/* Check if there is a user logged in, if so go
		 to the main screen otherwise go to  WelcomeViewController
		 to log in or sign up user
		*/
		PFUser *currentUser = [PFUser currentUser];
		if (currentUser) {
				[self presentMainViewController];
		}
		else {
				[self presentWelcomeViewController];
		}
		
		
		
		
		// Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
		    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		
		/* DEL
		BOOL success = [[ItemStore sharedStore] saveChanges];
		if (success) {
				NSLog(@"CoreData successfully");
		}
		else {
				NSLog(@"Unsuccessful");
		}
		*/
		
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Viewcontrollers

- (void)presentMainViewController
{
		// Start the location data for this device
		[LocationDataManager sharedLocation];

    // Set up a navigational controller and initialize with DealViewController
    // Add DealViewController to a Navigational Controller
    DealsViewController *dealViewController = [[DealsViewController alloc] init];
    UINavigationController *dealNavController = [[UINavigationController alloc] initWithRootViewController:dealViewController];
    UITabBarItem *dealTabBar = [[UITabBarItem alloc] initWithTitle:@"Deal of the day" image:nil tag:nil];
    [dealNavController setTabBarItem:dealTabBar];
		
		UserViewController *userViewController = [[UserViewController alloc] initWithTab:@"UserTab"];
		UINavigationController *userNavController = [[UINavigationController alloc]
												initWithRootViewController:userViewController];
		UITabBarItem *userTabBar = [[UITabBarItem alloc] initWithTitle:@"User" image:nil tag:nil];
		[userNavController setTabBarItem:userTabBar];
		
    NewsViewController *newsViewController = [[NewsViewController alloc] init];
    UITabBarItem *newsTabBar = [[UITabBarItem alloc] initWithTitle:@"News" image:nil tag:nil];
    [newsViewController setTabBarItem:newsTabBar];
		
    UITabBarController *tarBarController = [[UITabBarController alloc] init];
    NSArray *viewControllers = [NSArray arrayWithObjects:dealNavController, userNavController, newsViewController, nil];
    [tarBarController setViewControllers:viewControllers];
    [[self window] setRootViewController:tarBarController];
    
}

- (void)presentWelcomeViewController
{
		WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc] init];
		welcomeViewController.title = @"Welcome to Hot Deals";
		
		UINavigationController *welcomeNavController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
		welcomeNavController.navigationBarHidden = YES;
		
		[[self window] setRootViewController:welcomeNavController];		
}

@end








































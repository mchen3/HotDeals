//
//  DealAppDelegate.m
//  DealMaker1
//
//  Created by Mike Chen on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DealAppDelegate.h"
#import "DealsViewController.h"
#import "NewsViewController.h"
#import "ItemStore.h"
#import "Parse/Parse.h"

@implementation DealAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
		self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

		// Parse configuration
		[Parse setApplicationId:@"OVEj0O0vxy0Moy3COwIkFGCDUYNcBDhrY54NnzYD" clientKey:@"jxiwzGxKF9Sa47YxlcpksL4RdVVX50dkKpqhiS7h"];		
		
		/* Parse Access Control */
		
		[PFUser enableAutomaticUser];
    PFACL *defaultACL = [PFACL ACL];
    // Optionally enable public read access by default.
    // [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
		
		
    // Set up a navigational controller and initialize with DealViewController
    // Add DealViewController to a Navigational Controller
    DealsViewController *dealViewController = [[DealsViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:dealViewController];
    
    // Set the tab name for the Deals View Controller
    UITabBarItem *dealTabBar = [[UITabBarItem alloc] initWithTitle:@"Deal of the day"
																														 image:nil tag:nil];
    [navController setTabBarItem:dealTabBar];

    // Create the NewsViewController
    NewsViewController *newsViewController = [[NewsViewController alloc] init];
    // Set the tab name for the News View Controller
    UITabBarItem *newsTabBar = [[UITabBarItem alloc] initWithTitle:@"News" image:nil tag:nil];
    [newsViewController setTabBarItem:newsTabBar];
		
		// Create the TabBarController and initialize with our controllers
    UITabBarController *tarBarController = [[UITabBarController alloc] init];
    NSArray *viewControllers = [NSArray arrayWithObjects:navController, newsViewController, nil];
    [tarBarController setViewControllers:viewControllers];
    
    [[self window] setRootViewController:tarBarController];
    
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
		
		BOOL success = [[ItemStore sharedStore] saveChanges];
		if (success) {
				NSLog(@"CoreData successfully");
		}
		else {
				NSLog(@"Unsuccessful");
		}
		
		
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

@end

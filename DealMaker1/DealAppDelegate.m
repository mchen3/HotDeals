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
#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "LocationDataManager.h"
#import "WelcomeViewController.h"
#import "FlagViewController.h"

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
    PFACL *defaultACL = [PFACL ACL];
		[defaultACL setPublicReadAccess:YES];
	  //[defaultACL setPublicWriteAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
		
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

#pragma mark - Viewcontroller methods

- (void)presentMainViewController
{
		// Start the location data for this device
		[LocationDataManager sharedLocation];

		// Prepare the three viewcontrollers Deal, User, and Profile for the opening tab controller
		DealsViewController *dealViewController = [[DealsViewController alloc] init];
    UINavigationController *dealNavController = [[UINavigationController alloc] initWithRootViewController:dealViewController];
		// Customize our tab image and text attributes
		UIImage *dealTabImage = [UIImage imageNamed:@"dealtabimage.png"];
		// We will set the deal tab as tag integer "1", user as "2", profile as "3"
    UITabBarItem *dealTabBar = [[UITabBarItem alloc] initWithTitle:@"Find Deals" image:dealTabImage tag:1];
		[dealTabBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,[UIFont fontWithName:@"Arial Rounded MT Bold" size:13.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    [dealNavController setTabBarItem:dealTabBar];
		
		// Set a flag value "UserTab" so the UserViewController can know it is the 
		// current user accessing its own profile, hence we allow them to edit
		UserViewController *userViewController = [[UserViewController alloc]
																							initWithTab:@"UserTab"];
		UINavigationController *userNavController = [[UINavigationController alloc]
												initWithRootViewController:userViewController];
		UIImage *userTabImage = [UIImage imageNamed:@"usertabimage.png"];
		UITabBarItem *userTabBar = [[UITabBarItem alloc] initWithTitle:@"User" image:userTabImage tag:2];
		[userTabBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,[UIFont fontWithName:@"Arial Rounded MT Bold" size:13.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
		[userNavController setTabBarItem:userTabBar];
		
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
		UINavigationController *profileNavController = [[UINavigationController alloc]
												initWithRootViewController:profileViewController];
		UIImage *profileTabImage = [UIImage imageNamed:@"profiletabimage.png"];
    UITabBarItem *profileTabBar = [[UITabBarItem alloc] initWithTitle:@"Profile"
																																image:profileTabImage tag:3];
		[profileTabBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,[UIFont fontWithName:@"Arial Rounded MT Bold" size:13.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    [profileNavController setTabBarItem:profileTabBar];
		[profileNavController setNavigationBarHidden:YES];
		
    UITabBarController *tarBarController = [[UITabBarController alloc] init];
    NSArray *viewControllers = [NSArray arrayWithObjects:dealNavController, userNavController, profileNavController, nil];
		
    [tarBarController setViewControllers:viewControllers];
   [[self window] setRootViewController:tarBarController];
		
		FlagViewController *test =[[FlagViewController alloc]init];
	//	[[self window] setRootViewController:test];
		
}

- (void)presentWelcomeViewController
{
		/*When the user loads the app for the first time, we will start the location manager
		 which will prompt the user for location permissions. Note that we start searching for
		 GPS locations and placemarks as soon as the singleton LocationDataManager is launched
		 so we will return an error for locations at the very first launch. We re-start the 
		 LocationDataManager to search for location and placemarks in NewUserViewController    
		 and LoginViewController to correct this.
		*/
		[LocationDataManager sharedLocation];
		
		WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc] init];
		welcomeViewController.title = @"Welcome to Hot Deals";
		UINavigationController *welcomeNavController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
		welcomeNavController.navigationBarHidden = YES;
		[[self window] setRootViewController:welcomeNavController];		
}

@end








































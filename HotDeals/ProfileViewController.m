//
//  NewsViewController.m
//  DealMaker1
//
//  Created by Mike Chen on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "WelcomeViewController.h"
#import <Parse/Parse.h>
#import "DealAppDelegate.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Get the tab bar item
        //UITabBarItem *tbi = [self tabBarItem];
       // [tbi setTitle:@"News"];

				
    }
    return self;
}

#pragma mark - View lifecycles

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
		
		[self.imageView setImage:[UIImage imageNamed:@"Time.png"]];
		
		PFUser *currentUser = [PFUser currentUser];
		[self.userNameLabel setText:currentUser.username];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Buttons

- (IBAction)logOutButton:(id)sender {
		[PFUser logOut];

		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log out of HotDeals?" message:nil delegate:self cancelButtonTitle:@"Log out" otherButtonTitles:@"Cancel", nil];
		[alertView show];
		
}

#pragma mark - UIAlertViewDelegate methods


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
		if (buttonIndex == 0) {
				
				// Log out the user out and present the WelcomeViewController as our root controller
				[PFUser logOut];
				
				WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc] init];
				welcomeViewController.title = @"Welcome to Hot Deals";
				UINavigationController *welcomeNavController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
				welcomeNavController.navigationBarHidden = YES;
				
				DealAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
				[[appDelegate window] setRootViewController:welcomeNavController];		
		} 
}


@end



























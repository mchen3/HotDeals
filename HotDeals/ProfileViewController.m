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
#import <QuartzCore/QuartzCore.h>

@interface ProfileViewController ()
@end

@implementation ProfileViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View lifecycles

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
		
		/* Customize the background color of our UIbuttons. Currently the only way
		 to set the background color of UIButton is to set an image. We use our
		 method imageFromColor to set the color. Must import QuartzCore */
		[self.logOutButton setBackgroundImage:[ProfileViewController imageFromColor:[UIColor lightGrayColor]]forState:UIControlStateNormal];
		self.logOutButton.layer.cornerRadius = 7.5;
		self.logOutButton.layer.masksToBounds = YES;
		self.logOutButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
		self.logOutButton.layer.borderWidth = 1;
		
		self.descriptionField.layer.cornerRadius = 7.5;
		self.descriptionField.layer.borderColor = [UIColor blueColor].CGColor;
		
		PFUser *currentUser = [PFUser currentUser];
		[self.userNameLabel setText:currentUser.username];
}

- (void)viewDidUnload
{
		[self setLogOutButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button actions

- (IBAction)logOutButtonSelected:(id)sender {
		[PFUser logOut];
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log out of HotDeals?" message:nil delegate:self cancelButtonTitle:@"Log out" otherButtonTitles:@"Cancel", nil];
		[alertView show];
}

#pragma mark - UIAlertViewDelegate method

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

#pragma mark - User Interface helper methods

// Class method we used to customize the color of our UIButton
+ (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end



























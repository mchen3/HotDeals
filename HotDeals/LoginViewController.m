//
//  LoginViewController.m
//  HotDeals
//
//  Created by Mike Chen on 11/16/12.
//
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "PAWActivityView.h"
#import "DealsViewController.h"
#import "UserViewController.h"
#import "ProfileViewController.h"
#import "LocationDataManager.h"

@interface LoginViewController ()

- (void)textFieldChanged:(NSNotification *)note;
- (BOOL)shouldEnableDoneButton;
- (void)validateEntries;

@end

@implementation LoginViewController
@synthesize usernameField, passwordField, doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
		
		

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View lifecycles
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:usernameField];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:passwordField];
		doneButton.enabled = NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:usernameField];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:passwordField];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
		[usernameField becomeFirstResponder];
		[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-  (void)dealloc {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:usernameField];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:passwordField];
}

#pragma mark - Button actions

- (IBAction)done:(id)sender {
		[usernameField resignFirstResponder];
		[passwordField resignFirstResponder];
		
		[self validateEntries];
}

- (IBAction)cancel:(id)sender {
		[self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - UITextField text field change notifications and helper methods

- (BOOL)shouldEnableDoneButton {
		BOOL enableDoneButton = NO;
		if (usernameField.text != nil &&
				usernameField.text.length > 0 &&
				passwordField.text != nil &&
				passwordField.text.length > 0) {
				enableDoneButton = YES;
		}
		return enableDoneButton;
}

- (void)textFieldChanged:(NSNotification *)note {
		doneButton.enabled = [self shouldEnableDoneButton];
}

#pragma mark - UITextFieldDelegate methods
// The Return key is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
		if (textField == usernameField) {
				[passwordField becomeFirstResponder];
		}
		if (textField == passwordField) {
				[passwordField resignFirstResponder];
				[self validateEntries];
		}
		return YES;
}

#pragma mark - Private methods:
#pragma mark Field validation

- (void)validateEntries {

		NSString *username = usernameField.text;
		NSString *password = passwordField.text;
		NSString *noUsernameText = @"username";
		NSString *noPasswordText = @"password";
		NSString *errorText = @"No ";
		NSString *errorTextJoin = @" or ";
		NSString *errorTextEnding = @" entered";
		BOOL textError = NO;
		
		// Messaging nil will return 0, so these checks implicitly check for nil text.
		if (username.length == 0 || password.length == 0) {
				textError = YES;
				
				// Set up the keyboard for the first field missing input:
				if (password.length == 0) {
						[passwordField becomeFirstResponder];
				}
				if (username.length == 0) {
						[usernameField becomeFirstResponder];
				}
		}
		
		if (username.length == 0) {
				textError = YES;
				errorText = [errorText stringByAppendingString:noUsernameText];
		}
		
		if (password.length == 0) {
				textError = YES;
				if (username.length == 0) {
						errorText = [errorText stringByAppendingString:errorTextJoin];
				}
				errorText = [errorText stringByAppendingString:noPasswordText];
		}
		
		if (textError) {
				errorText = [errorText stringByAppendingString:errorTextEnding];
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
				[alertView show];
				return;
		}
		
		// Everything looks good; try to log in.
		// Disable the done button for now.
		doneButton.enabled = NO;
		
		PAWActivityView *activityView = [[PAWActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
		UILabel *label = activityView.label;
		label.text = @"Logging in";
		label.font = [UIFont boldSystemFontOfSize:20.f];
		[activityView.activityIndicator startAnimating];
		[activityView layoutSubviews];
		
		[self.view addSubview:activityView];
		
		[PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
				// Tear down the activity view in all cases.
				[activityView.activityIndicator stopAnimating];
				[activityView removeFromSuperview];
				
				if (user) {
						// Start the main view
						[self presentMainViewController];

				} else {
						// Didn't get a user.
						NSLog(@"%s didn't get a user!", __PRETTY_FUNCTION__);
						
						// Re-enable the done button if we're tossing them back into the form.
						doneButton.enabled = [self shouldEnableDoneButton];
						UIAlertView *alertView = nil;
						
						if (error == nil) {
								// the username or password is probably wrong.
								alertView = [[UIAlertView alloc] initWithTitle:@"Couldn’t log in:\nThe username or password were wrong." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
						} else {
								// Something else went horribly wrong:
								alertView = [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
						}
						[alertView show];
						// Bring the keyboard back up, because they'll probably need to change something.
						[usernameField becomeFirstResponder];
				}
		}];
}

#pragma mark - Viewcontroller methods

- (void)presentMainViewController
{
		/* Start the initial methods for the singleton locationDataManager which will 
		 1) Search for location and placemark just in case it wasn't received
		 2) At the completion block of "currentLocationByReverseGeocoding", we will
		 notifiy DealsParseTableController to reload its table
		*/
		LocationDataManager *locationDataManager = [LocationDataManager sharedLocation];
		[locationDataManager startUpdatingCurrentLocation];
		
    // Set up a navigational controller and initialize with DealViewController
    // Add DealViewController to a Navigational Controller
    DealsViewController *dealViewController = [[DealsViewController alloc] init];
    UINavigationController *dealNavController = [[UINavigationController alloc] initWithRootViewController:dealViewController];
		
		// Customize our tab image and text attributes
		UIImage *dealTabImage = [UIImage imageNamed:@"dealtabimage.png"];
    UITabBarItem *dealTabBar = [[UITabBarItem alloc] initWithTitle:@"Find Deals" image:dealTabImage tag:1];
		[dealTabBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,[UIFont fontWithName:@"Arial Rounded MT Bold" size:13.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    [dealNavController setTabBarItem:dealTabBar];
		
		UserViewController *userViewController = [[UserViewController alloc] initWithTab:@"UserTab"];
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
    UITabBarItem *profileTabBar = [[UITabBarItem alloc] initWithTitle:@"Profile" image:profileTabImage tag:3];
		[profileTabBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,[UIFont fontWithName:@"Arial Rounded MT Bold" size:13.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    [profileNavController setTabBarItem:profileTabBar];
		[profileNavController setNavigationBarHidden:YES];
		
    UITabBarController *tarBarController = [[UITabBarController alloc] init];
    NSArray *viewControllers = [NSArray arrayWithObjects:dealNavController, userNavController, profileNavController, nil];
		
    [tarBarController setViewControllers:viewControllers];
		[(UINavigationController *)self.presentingViewController pushViewController:
		 tarBarController animated:NO];
		[self.presentingViewController dismissViewControllerAnimated:YES
																											completion:^{}];
}
@end












































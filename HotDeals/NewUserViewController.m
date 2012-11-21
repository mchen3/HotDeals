//
//  NewUserViewController.m
//  HotDeals
//
//  Created by Mike Chen on 11/16/12.
//
//

#import "NewUserViewController.h"

#import <Parse/Parse.h>
#import "PAWActivityView.h"
#import "DealsViewController.h"
#import "UserViewController.h"
#import "ProfileViewController.h"
#import "LocationDataManager.h"

@interface NewUserViewController ()

- (void)textFieldChanged:(NSNotification *)note;
- (BOOL)shouldEnableDoneButton;
- (void)processEntries;

@end

@implementation NewUserViewController
@synthesize doneButton, usernameField, passwordField, passwordAgainField;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:usernameField];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:passwordField];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:passwordAgainField];
		
		doneButton.enabled = NO;
}

- (void)viewDidUnload
{
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:usernameField];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:passwordField];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:passwordAgainField];
}

- (void)viewWillAppear:(BOOL)animated {
		[usernameField becomeFirstResponder];
		[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
		return (interfaceOrientation = UIInterfaceOrientationPortrait);
}

- (void)dealloc {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:usernameField];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:passwordField];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:passwordAgainField];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
		if (textField == usernameField) {
				[passwordField becomeFirstResponder];
		}
		if (textField == passwordField) {
				[passwordAgainField becomeFirstResponder];
		}
		if (textField == passwordAgainField) {
				[passwordAgainField resignFirstResponder];
				[self processEntries];
		}
		
		return YES;
}

#pragma mark - UITextField text field change notifications and helper methods

- (BOOL)shouldEnableDoneButton {
		BOOL enableDoneButton = NO;
		if (usernameField.text != nil &&
				usernameField.text.length > 0 &&
				passwordField.text != nil &&
				passwordField.text.length > 0 &&
				passwordAgainField.text != nil &&
				passwordAgainField.text.length > 0) {
				enableDoneButton = YES;
		}
		return enableDoneButton;
}

- (void)textFieldChanged:(NSNotification *)note {
		doneButton.enabled = [self shouldEnableDoneButton];
}

#pragma mark - Buttons
- (IBAction)done:(id)sender {
		[usernameField resignFirstResponder];
		[passwordField resignFirstResponder];
		[passwordAgainField resignFirstResponder];
		
		[self processEntries];
}

- (IBAction)cancel:(id)sender {
		[self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Private methods:

#pragma mark Field validation

- (void)processEntries {
		// Check that we have a non-zero username and passwords.
		// Compare password and passwordAgain for equality
		// Throw up a dialog that tells them what they did wrong if they did it wrong.
		
		NSString *username = usernameField.text;
		NSString *password = passwordField.text;
		NSString *passwordAgain = passwordAgainField.text;
		NSString *errorText = @"Please ";
		NSString *usernameBlankText = @"enter a username";
		NSString *passwordBlankText = @"enter a password";
		NSString *joinText = @", and ";
		NSString *passwordMismatchText = @"enter the same password twice";
		
		BOOL textError = NO;
		
		// Messaging nil will return 0, so these checks implicitly check for nil text.
		if (username.length == 0 || password.length == 0 || passwordAgain.length == 0) {
				textError = YES;
				
				// Set up the keyboard for the first field missing input:
				if (passwordAgain.length == 0) {
						[passwordAgainField becomeFirstResponder];
				}
				if (password.length == 0) {
						[passwordField becomeFirstResponder];
				}
				if (username.length == 0) {
						[usernameField becomeFirstResponder];
				}
				
				if (username.length == 0) {
						errorText = [errorText stringByAppendingString:usernameBlankText];
				}
				
				if (password.length == 0 || passwordAgain.length == 0) {
						if (username.length == 0) { // We need some joining text in the error:
								errorText = [errorText stringByAppendingString:joinText];
						}
						errorText = [errorText stringByAppendingString:passwordBlankText];
				}
				goto showDialog;
		}
		
		// We have non-zero strings.
		// Check for equal password strings.
		if ([password compare:passwordAgain] != NSOrderedSame) {
				textError = YES;
				errorText = [errorText stringByAppendingString:passwordMismatchText];
				[passwordField becomeFirstResponder];
				goto showDialog;
		}
		
showDialog:
		if (textError) {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
				[alertView show];
				return;
		}
		
		// Everything looks good; try to log in.
		// Disable the done button for now.
		doneButton.enabled = NO;
		PAWActivityView *activityView = [[PAWActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
		UILabel *label = activityView.label;
		label.text = @"Signing You Up";
		label.font = [UIFont boldSystemFontOfSize:20.f];
		[activityView.activityIndicator startAnimating];
		[activityView layoutSubviews];
		
		[self.view addSubview:activityView];
		
		// Call into an object somewhere that has code for setting up a user.
		// The app delegate cares about this, but so do a lot of other objects.
		// For now, do this inline.
		
		PFUser *user = [PFUser user];
		user.username = username;
		user.password = password;
		[user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
				if (error) {
						UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
						[alertView show];
						doneButton.enabled = [self shouldEnableDoneButton];
						[activityView.activityIndicator stopAnimating];
						[activityView removeFromSuperview];
						// Bring the keyboard back up, because they'll probably need to change something.
						[usernameField becomeFirstResponder];
						return;
				}
				
				// Success!
				[activityView.activityIndicator stopAnimating];
				[activityView removeFromSuperview];
				
				
				 // Show the main view
				[self presentMainViewController];
				
		}];
}


- (void)presentMainViewController
{
		
		/* Start the initial methods for the singleton locationDataManager which will
		 1) Search for location and placemark just in case it wasn't received
		 2) At the completion block of "currentLocationByReverseGeocoding", we will
		 notifiy DealsParseTableController to reload its table
		 */
		LocationDataManager *locationDataManager = [LocationDataManager sharedLocation];
		[locationDataManager startUpdatingCurrentLocation];
		[locationDataManager currentLocationByReverseGeocoding];
		
    // Set up a navigational controller and initialize with DealViewController
    // Add DealViewController to a Navigational Controller
    DealsViewController *dealViewController = [[DealsViewController alloc] init];
    UINavigationController *dealNavController = [[UINavigationController alloc] initWithRootViewController:dealViewController];
    // Set the tab name for the Deals View Controller
    UITabBarItem *dealTabBar = [[UITabBarItem alloc]
																initWithTitle:@"Deal of the day" image:nil tag:nil];
    [dealNavController setTabBarItem:dealTabBar];
		
		UserViewController *userViewController = [[UserViewController alloc] initWithTab:@"UserTab"];
		UINavigationController *userNavController = [[UINavigationController alloc]
																								 initWithRootViewController:userViewController];
		UITabBarItem *userTabBar = [[UITabBarItem alloc]
																initWithTitle:@"User" image:nil tag:nil];
		[userNavController setTabBarItem:userTabBar];
		
		
		ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
		UINavigationController *profileNavController = [[UINavigationController alloc]
																										initWithRootViewController:profileViewController];
    UITabBarItem *profileTabBar = [[UITabBarItem alloc] initWithTitle:@"Profile" image:nil tag:nil];
    [profileNavController setTabBarItem:profileTabBar];
		[profileNavController setNavigationBarHidden:YES];
		
		// Create the TabBarController and initialize with our controllers
    UITabBarController *tarBarController = [[UITabBarController alloc] init];
    NSArray *viewControllers = [NSArray arrayWithObjects:dealNavController, userNavController, profileNavController, nil];
    [tarBarController setViewControllers:viewControllers];
		
		
		[(UINavigationController *)self.presentingViewController pushViewController:
		 tarBarController animated:NO];
		
		
		[self.presentingViewController dismissViewControllerAnimated:YES
																											completion:^{}];
    
}



@end




















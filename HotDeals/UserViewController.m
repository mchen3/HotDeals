//
//  UserViewController.m
//  HotDeals
//
//  Created by Mike Chen on 10/11/12.

#import "UserViewController.h"
#import "DealsParseTableController.h"
#import "DealsItemViewController.h"
#import "UserPostViewController.h"
#import "ProfileViewController.h"
#import "UserParseTableController.h"
#import <QuartzCore/QuartzCore.h>
#import "CreateDealViewController.h"
#import "ImageStore.h"
#import "LocationDataManager.h"

@interface UserViewController ()
@property (nonatomic, strong) UserParseTableController *userParseTableController;
@end

@implementation UserViewController
@synthesize userParseTableController = _userParseTableController;
@synthesize UserViewBasedOn = _UserViewBasedOn;
@synthesize userNameOfDeal = _userNameOfDeal;

- (id)initWithTab:(NSString *)TabBasedOn
{
		self = [super initWithNibName:@"UserViewController" bundle:nil];
		self.UserViewBasedOn = TabBasedOn;
		
		if (self) {

				// If this UserViewController is inside the user tab then
				// this user is viewing his own profile. Allow editing and
				// posting new deals.
				if ([self.UserViewBasedOn isEqualToString:@"UserTab"]) {
						// Add a right bar button of type 'ADD' programmically
						// to add items to the table
						UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addNewDeal:)];
						[button setTintColor:[UIColor lightGrayColor]];
						[[self navigationItem] setRightBarButtonItem:button];
				}
		}
		return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
		
		[self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
		
		
		/* Our tab bars have tag integers that identify which tab you are in. If the
		tag is 1 that you are in the "Find Deals"/DealTab so you disable the two
		functions: Adding a new deal and editing a deal. If the tag integer is 2, then 
		it is the current user viewing their own profile in the "User"/UserTab. We 
		will then enable the two functions to add and edit a deal.
		 
		Right now we are using our own flag, a string called UserDealBasedOn, to decide
		which tab you are in. 
		*/
		NSInteger tabInteger = self.navigationController.tabBarItem.tag;
		// Deal tab
		if (tabInteger == 1) {
				[self.postADealLabel setText:@"Hot Deals"];
		}
    // User tab
		else if (tabInteger == 2) {
				[self.postADealLabel setText:@"Post a deal"];
		}
		
		/* Set the nav title depending on if the userView is in the
		 DealTab, he's a random user, or if he's in the UserTab
		 ie he's the current user	*/
		if ([self.UserViewBasedOn isEqualToString:@"DealTab"]) {
				// Set the UVC's random profile
				PFUser *randomUser = self.userNameOfDeal;
				[[self navigationItem] setTitle:randomUser.username];
		}
		else {
				PFUser *currentUser = [PFUser currentUser];
				[[self navigationItem] setTitle:currentUser.username];
		}
			
		// DealsParseTableController for the UserViewController
		// Load the lib for the table cell and register it to the tableView
		UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];		
		// Add the wall posts tableView as a subview with view containment (new in iOS 5.0);
		self.userParseTableController = [[UserParseTableController alloc] initWithStyle:UITableViewStylePlain];
		// Pass the flag UserViewBasedOn which tells the UserParseTableController
		// what tab (Deal or User) you are in
		[self.userParseTableController setUserViewBasedOn:self.UserViewBasedOn];
		// Pass the parse Object so the parse table can query based on
		// the username of the deal if you are in the Deals Tab
		[self.userParseTableController setUserNameOfDeal:self.userNameOfDeal];
		
		[self addChildViewController:self.userParseTableController];
		[self.view addSubview:self.userParseTableController.view];
		self.userParseTableController.view.frame = CGRectMake(0.f, 47.f, 320.f, 420.f);
		[self.userParseTableController.tableView setRowHeight:80];
		[self.userParseTableController.tableView setSeparatorColor:[UIColor darkGrayColor]];
		// Use custom cell ItemCell
		[self.userParseTableController.tableView registerNib:nib
																	forCellReuseIdentifier:@"ItemCell"];
}

- (void)viewDidUnload
{
		[self setPostADealLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - NavBar buttons

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
		[super setEditing:editing animated:animated];
		
		if (self.userParseTableController.tableView.editing) {
				self.userParseTableController.tableView.editing = NO;
		}else {
				self.userParseTableController.tableView.editing = YES;
		}
}

-(void)addNewDeal:(id)sender
{		
		// We are creating a new deal so let's find our current location
		[[LocationDataManager sharedLocation] startUpdatingCurrentLocation];
		
		// In order to create a new deal we must create a photo first
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		if ([UIImagePickerController isSourceTypeAvailable:
				 UIImagePickerControllerSourceTypeCamera]) {
				[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
		} else {
				[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		}
		[imagePicker setDelegate:self];
		[self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
		// Customize to dismiss the modal view, image picker, from right to left
		CATransition *transition = [CATransition animation];
		transition.duration = 0.30;
		transition.timingFunction =
		[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type = kCATransitionMoveIn;
		transition.subtype = kCATransitionFromRight;
		UIView *containerView = picker.view.window;
		[containerView.layer addAnimation:transition forKey:nil];
		
		// Must use the parent to dismiss because [self dismissViewController]
		// was causing to many issues
		[self dismissViewControllerAnimated:NO completion:^{
				
				CreateDealViewController *createDealViewController =
														[[CreateDealViewController alloc] init];
				// Create a new parse object
				PFObject *parseObject = [PFObject objectWithClassName:@"Posts"];
				// Get picked image from info dictionary
				UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
				// Pass the newly created parse object and image to createDealViewController
				[createDealViewController setImage:image];
				[createDealViewController setParseObject:parseObject];
				// Pass a block to reload the User table
				[createDealViewController setReloadUserTableBlock:^{
						[self.userParseTableController loadObjects];
				}];
				// Disable the delete button when you first create a delete
				[createDealViewController setHideDeleteButton:TRUE];
				// Create a nav controller so the CDVC can add nav items
				UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createDealViewController];
				[self presentViewController:navController animated:NO completion:nil];
				
		}];
}
@end



























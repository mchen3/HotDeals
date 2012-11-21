//
//  UserViewController.m
//  HotDeals
//
//  Created by Mike Chen on 10/11/12.
//
//

#import "UserViewController.h"
#import "DealsParseTableController.h"
#import "DealsItemViewController.h"
#import "UserPostViewController.h"
#import "ProfileViewController.h"
#import "UserParseTableController.h"
#import <QuartzCore/QuartzCore.h>
#import "CreateDealViewController.h"
#import "ImageStore.h"


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
		
		if ([self.UserViewBasedOn isEqualToString:@"DealTab"]) {
				//??? Change to show the username of the random profile
				[[self navigationItem] setTitle:@"UVC Random Profile"];
		}
		
		if (self) {
				// If this UserViewController is inside the user tab then
				// this user is viewing his own profile. Allow editing and
				// posting new deals.
				
				if ([self.UserViewBasedOn isEqualToString:@"UserTab"]) {
						
						// Set the title of the nav bar to be the user
						[[self navigationItem] setTitle:@"UVC User Profile"];
						
						// Add a right bar button of type 'ADD' programmically
						// to add items to the table
						UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewDeal:)];
						
						// Add a image to the button
						[[self navigationItem] setRightBarButtonItem:button];
						//[[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
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

- (void)viewWillAppear:(BOOL)animated
{
		// Make sure the flag DealBasedOn is always set to "user" for the
		// UserViewController when you use DealsParseTableController
		//[self.dealsParseTableController setDealBasedOn:@"user"];
	  // [self.dealsParseTableController loadObjects];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
		
		
		NSLog(@"UVC LOAD");
		
		
		
		// DealsParseTableController for the UserViewController
		
		// Load the lib for the table cell and register it to the tableView
		UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
		//[table registerNib:nib forCellReuseIdentifier:@"ItemCell"];
		
		// Add the wall posts tableView as a subview with view containment (new in iOS 5.0);
		self.userParseTableController = [[UserParseTableController alloc] initWithStyle:UITableViewStylePlain];
		
		// Pass the flag UserViewBasedOn which tells the UserParseTableController
		// what tab (Deal or User) you are in
		[self.userParseTableController setUserViewBasedOn:self.UserViewBasedOn];
		// Pass the parse Object so the parse table can query based on
		// the username of the deal if you are in the Deals Tab
		[self.userParseTableController setUserNameOfDeal:self.userNameOfDeal];
		
		// Configure parse to display deals based on UserID
		//[self.dealsParseTableController setDealBasedOn:@"user"];
		
		[self addChildViewController:self.userParseTableController];
		[self.view addSubview:self.userParseTableController.view];
		self.userParseTableController.view.frame = CGRectMake(0.f, 70.f, 320.f, 380.f);
		
		[self.userParseTableController.tableView setRowHeight:80];
		[self.userParseTableController.tableView setSeparatorColor:[UIColor redColor]];
		// Use custom cell ItemCell
		[self.userParseTableController.tableView registerNib:nib forCellReuseIdentifier:@"ItemCell"];
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
		
		
		
		
		
		
		/* PREV
		 // Add a new Parse object and pass it to dealsItemViewController
		 PFObject *parseObject = [PFObject objectWithClassName:@"TestObject"];
		 
		 
		 UserPostViewController *userPostViewController = [[UserPostViewController alloc]
		 initWithName:YES];
		 [userPostViewController setParseObject:parseObject];
		 
		 
		 // Why add a navController?
		 // Because the modal view needs some way to dismiss itself
		 UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:userPostViewController];
		 [navController setModalPresentationStyle:UIModalPresentationFormSheet];
		 [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
		 
		 // Pass a block to reload the table to the DealsItemViewController
		 // Need a dismiss block to reload data for the iPad but not for iPhone
		 // 13.5 for explantion
		 [userPostViewController setDismissBlock:^{
		 [self.userParseTableController loadObjects];
		 }];
		 
		 [self presentViewController:navController animated:YES completion:nil];
		 */
		
}





#pragma mark - Camera

- (IBAction)takePicture:(id)sender {
		
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



// Delegate for UIImagePickerController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
		/*
		 // Get picked image from info dictionary
		 UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		 
		 // Create a CFUUID object - it knows how to create a unique identifier strings
		 CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
		 
		 // Create a string from unique identifier
		 CFStringRef newUniqueIDString =
		 CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
		 
		 // Need to bridge CFStringRef to NSString
		 NSString *key = (__bridge NSString *)newUniqueIDString;
		 */
		
		
		// Add a new Parse object and pass it to dealsItemViewController
		//PFObject *parseObject = [PFObject objectWithClassName:@"TestObject"];
		
		
		
		// Save key, image, and thumbnail
		// If this is a new item parseObject has not been created
		// can't set any values to nil
		//[parseObject setObject:key forKey:@"imageKey"];
		
		// Store image in the ImageStore and on Parse servers with this key
		//[[ImageStore defaultImageStore] setImage:image forKey:key];
		
		
		// Resize the image and get a PFFile associated with it
		//PFFile *thumbnailFile = [[ImageStore defaultImageStore] getThumbnailFileFromImage:image];
		/*
		 We will save the thumbnail file with this parse object inside the
		 same table instead of the separate ImageStore/Photo table. It will
		 be much more efficent this way when we later try to pull the
		 thumbnail image to display inside of a table cell.
		 */
		//[parseObject setObject:thumbnailFile forKey:@"thumbImage"];
		
		//CFRelease(newUniqueIDString);
		//CFRelease(newUniqueID);
		
		
		
		
		
		
		// Customize to dismiss the modal view, image picker, from right to left
		CATransition *transition = [CATransition animation];
		transition.duration = 0.30;
		transition.timingFunction =
		[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type = kCATransitionMoveIn;
		transition.subtype = kCATransitionFromRight;
		UIView *containerView = picker.view.window;
		[containerView.layer addAnimation:transition forKey:nil];
		
		
		// Must use the parent to dismiss because [self dismissViewController
		// was causing to many issues
		//[self.parentViewController dismissViewControllerAnimated:NO completion:^{
		[self dismissViewControllerAnimated:NO completion:^{
				
				
				
				NSLog(@"Parent %@  ", self.parentViewController.nibName);
				NSLog(@"Self %@", self.nibName);
				
			  
				CreateDealViewController *createDealViewController = [[CreateDealViewController alloc] init];
				
				// Create a new parse object
				PFObject *parseObject = [PFObject objectWithClassName:@"TestObject"];
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
				
				
				
				
				
				//[self.navigationController pushViewController:createDealViewController animated:NO];
				// ERROR [self.navigationController pushViewController:navController animated:NO];
				
				
				
				//[self.parentViewController presentViewController:navController
				//animated:NO completion:nil];
				//[self.parentViewController.navigationController
				//pushViewController:navController animated:NO];
		}];
		
		
		
		
		/*
		 DealsItemViewController *dvc = [[DealsItemViewController alloc] init];
		 [self presentModalViewController:dvc animated:NO];
		 */
		
		/*
		 UserPostViewController *upvc = [[UserPostViewController alloc] initWithName:YES];
		 
		 UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:upvc];
		 */
		
		
		//DEL
		//[self dismissViewControllerAnimated:YES completion:^{
		//NewsViewController *nvc = [[NewsViewController alloc] init];
		//[self presentModalViewController:nvc animated:NO];
		//}];
		
		
		
		
}






@end



























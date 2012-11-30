//
//  UserPostViewController.m
//  HotDeals
//
//  Created by Mike Chen on 10/12/12.
//
//

#import "UserPostViewController.h"
#import "ImageStore.h"
#import "LocationDataManager.h"
#import "UserViewController.h"
#import "CreateDealViewController.h"
#import "MapPostViewController.h"
#import <QuartzCore/QuartzCore.h>

// DEl testing
#import "ProfileViewController.h"
#import "DealsItemViewController.h"



#import <QuartzCore/QuartzCore.h>

@interface UserPostViewController ()

@end

@implementation UserPostViewController
@synthesize dismissBlock;
@synthesize parseObject;

#pragma mark - Init

- (id)initWithName:(BOOL)isNew
{
		self = [self initWithNibName:@"UserPostViewController" bundle:nil];
		
		//???
		//[[self navigationItem] setTitle:@"UPVC"];
		
		// ? hide the tab bar
		self.hidesBottomBarWhenPushed = YES;
		
		if (self) {
				
				NSLog(@"UserPost INIT");
				
				// Previous implementai
				//if (isNew) {
				
				// If you are creating a new item, then
				// add a save and cancel button to the nav bar
				UIBarButtonItem *editItem = [[UIBarButtonItem alloc]
																		 initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
				[editItem setTintColor:[UIColor darkGrayColor]];
				[[self navigationItem] setRightBarButtonItem:editItem];
				
				
				
				UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
																		 initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:
																		 @selector(done:)];
				[doneItem setTintColor:[UIColor darkGrayColor]];
				[[self navigationItem] setLeftBarButtonItem:doneItem];
				
				//	}
				
				
		}
		return self;
		
}

#pragma mark - ()

- (void)edit:(id)sender
{
		CATransition *transition = [CATransition animation];
		transition.duration = 0.30;
		transition.timingFunction =
		[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type = kCATransitionMoveIn;
		transition.subtype = kCATransitionFromLeft;
		
		UIView *containerView = self.view.window;
		[containerView.layer addAnimation:transition forKey:nil];
		
		
		
		
		
		NSString *imageKey = [self.parseObject objectForKey:@"imageKey"];
		if (imageKey) {
				//UIImage *parseImage = [[ImageStore defaultImageStore] imageForKey:imageKey];
				
				/*
				 CreateDealViewController *createDealViewController =
				 (CreateDealViewController *)self.presentingViewController;
				 [createDealViewController setImage:parseImage];
				 [createDealViewController setParseObject:self.parseObject];
				 
				 NSString *string =   self.presentingViewController.nibName;
				 
				 NSLog(@"");
				 */
				
		}
		
		
		
		
		[self dismissViewControllerAnimated:NO completion:^{
				// Pass the image and parse object to createDealViewController
				
				
				
				
				
				
				
		}];
		
		
		
		
		
		
		//[self.navigationController popViewControllerAnimated:YES];
}

/*
 - (void)save:(id)sender
 {
 [self.parseObject setObject:[nameField text] forKey:@"name"];
 
 
 // Put the save part here and put the dismiss block in the completetion:self.dismissBlock
 
 [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
 }
 */


-(void)done:(id)sender
{
		
		//Customize to dismiss the current modal view, UserPostViewController, from left to right
		CATransition *transition = [CATransition animation];
		transition.duration = 0.30;
		transition.timingFunction =
		[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type = kCATransitionMoveIn;
		transition.subtype = kCATransitionFromLeft;
		
		UIView *containerView = self.view.window;
		[containerView.layer addAnimation:transition forKey:nil];
		
		//[[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
		/*
		 UserViewController *userPostViewController =
		 [[UserViewController alloc] initWithTab:@"UserTab"];
		 [self presentViewController:userPostViewController animated:NO completion:nil];
		 */
		
		
		[[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
				
		
}

- (void)viewWillDisappear:(BOOL)animated
{
		[super viewWillDisappear:animated];
		
		// Clear the first responder
		[[self view] endEditing:YES];
		
		
		// Save the parse objects in case the objects were edited.
		/*
		 NSString *nameString = [nameField text];
		 
		 //Make sure the objects are not empty because Parse
		 // cannot save objects that are nil
		 if (nameString) {
		 [self.parseObject setObject:nameString forKey:@"name"];
		 
		 // Associate the parseObject with this user
		 PFUser *user = [PFUser currentUser];
		 [self.parseObject setObject:user forKey:@"user"];
		 }*/
		
		// Save the parse objects in case the objects were edited.
		//NSString *descriptionString = [descriptField text];
		
		//Make sure the objects are not empty because Parse
		// cannot save objects that are nil
		
		
		/******** DONT EDIT
		 
		 if (descriptionString) {
		 [self.parseObject setObject:descriptionString forKey:@"description"];
		 
		 // Associate the parseObject with this user
		 PFUser *user = [PFUser currentUser];
		 [self.parseObject setObject:user forKey:@"user"];
		 }
		 
		 
		 // Find the location for this user and save the locality to parse
		 CLLocation *location = [LocationDataManager sharedLocation].currentLocation;
		 NSString *locality = [LocationDataManager sharedLocation].currentPlacemark.locality;
		 
		 CLLocationCoordinate2D coordinate = [LocationDataManager sharedLocation].currentLocation.coordinate;
		 NSLog(@"Los");
		 
		 [self.parseObject setObject:locality forKey:@"locality"];
		 
		 
		 // Save in viewdiddisappear instead of in the save function
		 [self.parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		 if (error) {
		 NSLog(@"Could not save");
		 NSLog(@"%@", error);
		 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		 [alertView show];
		 }
		 // Reload the parse table after you successfully saved
		 if (succeeded) {
		 // Reload the UserParseTableController
		 dispatch_async(dispatch_get_main_queue(), self.dismissBlock);
		 
		 // Alert the DealsParseTableController that a new deal was created
		 dispatch_async(dispatch_get_main_queue(), ^{
		 [[NSNotificationCenter defaultCenter]
		 postNotificationName:@"userDealChange" object:nil];
		 });
		 
		 } else {
		 NSLog(@"Failed to save");
		 }
		 }];
		 */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
		
		[self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

		// Make the corner of the description and image
		// rounded, must import QuartzCore class
		descriptField.layer.cornerRadius = 7.5;
		imageView.layer.cornerRadius = 10.0;
		
		// Load the Parse objects
		//[nameField setText:[self.parseObject objectForKey:@"name"]];
		// Set the values for description and price
		[descriptField setText:[self.parseObject objectForKey:@"description"]];
		
		// Set the image
		NSString *imageKey = [self.parseObject objectForKey:@"imageKey"];
		if (imageKey) {
				/* We want to load the big imageView asynchronously so the UI will be more
				 responsive. We will pass our PFImageView imageView and imageKey to the
				 ImageStore so that class will take care of setting the our image. */
				[[ImageStore defaultImageStore] setLazyLoadPFImageView:imageView];
				[[ImageStore defaultImageStore] imageForKey:imageKey];
		}
		
		// Show the date the deal was created
		NSDate *dateData = self.parseObject.createdAt;
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"MM-dd-yyyy"];
		NSString *dateString = [formatter  stringFromDate:dateData];
		[dateLabel setText:dateString];

		// Set the price
		NSString *price = [self.parseObject objectForKey:@"price"];
		[priceLabel setText:price];
		
}

- (void)viewDidUnload
{
		
		
		NSLog(@"User Post unload");
		
		
		descriptField = nil;
		imageView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Interface

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// Touch background view to dismiss keyboard
- (IBAction)backgroundTouched:(id)sender {
		[[self view] endEditing:YES];
}

// Press enter on the keyboard to dismiss UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
		[textField resignFirstResponder];
		return true;
}

// UITextView doesn't have a delegate method
// for pressing the return key like UITextField
// so you use this workaroun delegate method, textView:shouldChange
// to dimiss the keyboard when you press return

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
		
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
		
		//[self presentModalViewController:imagePicker animated:YES];
		
		[self presentViewController:imagePicker animated:YES completion:^{
		}];
}






// Delegate for UIImagePickerController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
		// Get picked image from info dictionary
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		
		// Create a CFUUID object - it knows how to create a unique identifier strings
		CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
		
		// Create a string from unique identifier
		CFStringRef newUniqueIDString =
		CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
		
		// Need to bridge CFStringRef to NSString
		NSString *key = (__bridge NSString *)newUniqueIDString;
		
		// If this is a new item parseObject has not been created
		// can't set any values to nil
		[self.parseObject setObject:key forKey:@"imageKey"];
		
		// Store image in the ImageStore and on Parse servers with this key
		[[ImageStore defaultImageStore] setImage:image forKey:key];
		
		
		// Resize the image and get a PFFile associated with it
		PFFile *thumbnailFile = [[ImageStore defaultImageStore]
														 getThumbnailFileFromImage:image];
		/*
		 We will save the thumbnail file with this parse object inside the
		 same table instead of the separate ImageStore/Photo table. It will
		 be much more efficent this way when we later try to pull the
		 thumbnail image to display inside of a table cell.
		 */
		[self.parseObject setObject:thumbnailFile forKey:@"thumbImage"];
		
		CFRelease(newUniqueIDString);
		CFRelease(newUniqueID);
		
		
		
		// Transition to move the image picker from right to left
		CATransition *transition = [CATransition animation];
		transition.duration = 0.30;
		transition.timingFunction =
		[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type = kCATransitionMoveIn;
		transition.subtype = kCATransitionFromRight;
		
		UIView *containerView = picker.view.window;
		[containerView.layer addAnimation:transition forKey:nil];
		
		
		
		
		/* DEL
		 CATransition *animation = [CATransition animation];
		 [animation setDelegate:self];
		 [animation setType:kCATransitionPush];
		 [animation setSubtype:kCATransitionFromRight];
		 [animation setDuration:0.50];
		 [animation setTimingFunction:
		 [CAMediaTimingFunction functionWithName:
		 kCAMediaTimingFunctionEaseInEaseOut]];
		 //[picker.view.layer addAnimation:animation forKey:kCATransition];
		 //[self.view.layer addAnimation:animation forKey:kCATransition];
		 */
		//NewsViewController *nvc = [[NewsViewController alloc] init];
		//[self presentModalViewController:nvc animated:NO];
		//[self.view.layer addAnimation:animation forKey:kCATransition];
		
		
		// Must use the parent to dismiss because [self dismissViewController
		// was causing to many issues
		[self.parentViewController dismissViewControllerAnimated:NO completion:^{
				//	NewsViewController *nvc = [[NewsViewController alloc] init];
				//[self presentModalViewController:nvc animated:NO];
				
				
				DealsItemViewController *dvc = [[DealsItemViewController alloc] init];
				//[self presentModalViewController:dvc animated:NO];
	
				[self presentViewController:dvc animated:NO completion:^{}];
		}];
		
		//DEL
		//[self dismissViewControllerAnimated:YES completion:^{
		//NewsViewController *nvc = [[NewsViewController alloc] init];
		//[self presentModalViewController:nvc animated:NO];
		//}];
}

#pragma mark - Buttons

- (IBAction)mapButton:(id)sender {
		// Show the map of the deal 
		MapPostViewController *mapPostViewController = [[MapPostViewController alloc] init];
		// Pass our parse object
		[mapPostViewController setParseObject:self.parseObject];
		
		[self.navigationController pushViewController:mapPostViewController animated:YES];
}
@end






















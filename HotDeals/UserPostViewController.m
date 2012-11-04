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
		[[self navigationItem] setTitle:@"UPVC"];
		
		// ? hide the tab bar
		self.hidesBottomBarWhenPushed = YES;
		
		if (self) {
				
				if (isNew) {
						// If you are creating a new item, then
						// add a save and cancel button to the nav bar
						UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]
																				 initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
						[[self navigationItem] setRightBarButtonItem:saveItem];
						
						UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
																					 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:
																					 @selector(cancel:)];
						[[self navigationItem] setLeftBarButtonItem:cancelItem];
				}
				
				
		}
		return self;
		
}

#pragma mark - ()

- (void)save:(id)sender
{
		[self.parseObject setObject:[nameField text] forKey:@"name"];
		
		
		// Put the save part here and put the dismiss block in the completetion:self.dismissBlock
		
		[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancel:(id)sender
{
		[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
		// Load the Parse objects
		//[nameField setText:[self.parseObject objectForKey:@"name"]];
		[descriptField setText:[self.parseObject objectForKey:@"description"]];

		
		// Load image through imageKey
		NSString *imageKey = [self.parseObject objectForKey:@"imageKey"];
		if (imageKey) {
				UIImage *image = [[ImageStore defaultImageStore] imageForKey:imageKey];
				[imageView setImage:image];
		}
		else {
				[imageView setImage:nil];
		}
		
		
		
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
		NSString *descriptionString = [descriptField text];
		
		//Make sure the objects are not empty because Parse
		// cannot save objects that are nil
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
		
		descriptField = nil;
		nameField = nil;
		priceField = nil;
		dateCreated = nil;
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
		[self presentModalViewController:imagePicker animated:YES];
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
		
		CFRelease(newUniqueIDString);
		CFRelease(newUniqueID);
		
		[self dismissViewControllerAnimated:YES completion:^{
				
		}];
}





@end






















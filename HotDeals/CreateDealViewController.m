//
//  CreateDealViewController.m
//  HotDeals
//
//  Created by Mike Chen on 11/6/12.
//
//

#import "CreateDealViewController.h"
#import "ImageStore.h"
#import "LocationDataManager.h"
#import "UserPostViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface CreateDealViewController ()

@end

@implementation CreateDealViewController
@synthesize parseObject;
@synthesize image;
@synthesize reloadUserTableBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
		
    //???
		[[self navigationItem] setTitle:@"CDVC"];
		
		
		if (self) {
				
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
		return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
		
		NSLog(@"viewWillAppear");
		
		[priceField setKeyboardType:UIKeyboardTypeNumberPad];
		[imageView setImage:self.image];
		
		
		NSString *description = [self.parseObject objectForKey:@"description"];
		if (description) {
				[descriptField setText:description];

		}
		else {
				// Placeholder feature
				
				//if (!self.description) {
				descriptField.text = @"Describe the deal...";
				descriptField.textColor = [UIColor grayColor];
				//}
		}
		
		[self numberOfWordsInDescription];
}

// UITextView has no placeholder option, so you create one manually and
// factor in all posibilites for entering text into descriptField
- (void)viewDidLoad{
		
		NSLog(@"CDVC loading");
		
		[descriptField becomeFirstResponder];
		//[priceField setKeyboardType:UIKeyboardTypeNumberPad];

}

- (void) viewDidAppear:(BOOL)animated {
		
		NSLog(@"viewDidAppear");
		
		[imageView setImage:self.image];
		
}

- (void) viewDidDisappear:(BOOL)animated {
		
		
		
		NSLog(@"DISAPPEAR");
}

// Description TextView delegates
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
		if (descriptField.textColor == [UIColor grayColor]) {
				descriptField.text = @"Describe the deal...";
		}
		else {
				descriptField.textColor = [UIColor blackColor];
		}
		
		return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{

		[self numberOfWordsInDescription];
		
		if(descriptField.text.length == 0){
				descriptField.text = @"Describe the deal...";
				descriptField.textColor = [UIColor grayColor];				
		}
		
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
		
		// If text color is gray, then clear the text and start entering words as black text
		if (descriptField.textColor == [UIColor grayColor]) {
				descriptField.text = @"";
				descriptField.textColor = [UIColor blackColor];
		}
		
		// Always allow the back space or delete key to go through
		if (range.length == 1) {
				return YES;
		}
		
		// If the number of words remaining is 0 (i.e. 150 words overall in description field)
		// then prevent any more keys to be entered
		int numberRemaining = [self numberOfWordsInDescription];
		if (numberRemaining == 0) {
				return NO;
		}
		else {
				return YES;
		}
}

// Price TextField delegates
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
		//[textField setKeyboardAppearance:UIKeyboardTypeNumberPad];

		//[textField becomeFirstResponder];
		
		NSLog(@"TextField");
		return TRUE;
}

// Calculate the amount of words that are left to enter in the description field,
// with the most at 150 words, and enter into the numberOfWords label
-(int)numberOfWordsInDescription
{
		int numberRemaining;
		// If description is gray then there were no words entered otherwise
		// show the remaining words left to enter with the most at 150.
		if (descriptField.textColor == [UIColor grayColor]) {
				numberRemaining = 150;
				numberOfWords.text = @"150";
		}
		else {
				int number = descriptField.text.length;
				numberRemaining = 150 - number;
				numberOfWords.text = [NSString stringWithFormat:@"%d",numberRemaining];
		}
		
		return numberRemaining;
}


#pragma mark - ()

- (void)save:(id)sender
{
		
		MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
		HUD.labelText = @"Loading";
		HUD.detailsLabelText = @"uploading data";
		// Add the HUD view over the keyboard
		[[[UIApplication sharedApplication].windows objectAtIndex:1] addSubview:HUD];
		
		
				
		[HUD showAnimated:YES whileExecutingBlock:^{

		
		// Save the image
		// Get picked image from info dictionary
		//UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		
		// Create a CFUUID object - it knows how to create a unique identifier strings
		CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
		
		// Create a string from unique identifier
		CFStringRef newUniqueIDString =
		CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
		
		// Need to bridge CFStringRef to NSString
		NSString *key = (__bridge NSString *)newUniqueIDString;
		
		
		// Add a new Parse object and pass it to dealsItemViewController
		//PFObject *parseObject = [PFObject objectWithClassName:@"TestObject"];
		
		
		// Save key, image, and thumbnail
		// If this is a new item parseObject has not been created
		// can't set any values to nil
		[self.parseObject setObject:key forKey:@"imageKey"];
		
		// Store image in the ImageStore and on Parse servers with this key
		[[ImageStore defaultImageStore] setImage:self.image forKey:key];
		
		// Resize the image and get a PFFile associated with it
		PFFile *thumbnailFile = [[ImageStore defaultImageStore]
														 getThumbnailFileFromImage:self.image];
		/*
		 We will save the thumbnail file with this parse object inside the
		 same table instead of the separate ImageStore/Photo table. It will
		 be much more efficent this way when we later try to pull the
		 thumbnail image to display inside of a table cell.
		 */
		[parseObject setObject:thumbnailFile forKey:@"thumbImage"];
		
		// Release the objects used for creating a unique key
		CFRelease(newUniqueIDString);
		CFRelease(newUniqueID);
		
		
		
		
		
		// Save the price
		
		// Save the description
		NSString *descriptionField = [descriptField text];
		[self.parseObject setObject:descriptionField forKey:@"description"];
		
		// Make sure the objects are not empty because Parse
		// cannot save objects that are nil
		if (descriptionField) {
				[self.parseObject setObject:descriptionField forKey:@"description"];
		}
		
		// Associate the parseObject with this user
		PFUser *user = [PFUser currentUser];
		[self.parseObject setObject:user forKey:@"user"];
		
		// Find the location for this user and save the locality to parse
		//CLLocation *location = [LocationDataManager sharedLocation].currentLocation;
		//CLLocationCoordinate2D coordinate = [LocationDataManager sharedLocation].currentLocation.coordinate;
		NSString *locality = [LocationDataManager sharedLocation].currentPlacemark.locality;
		[self.parseObject setObject:locality forKey:@"locality"];
		
		
		// Save the parse object
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
						dispatch_async(dispatch_get_main_queue(), self.reloadUserTableBlock);
						
						// Alert the DealsParseTableController that a new deal was created
						dispatch_async(dispatch_get_main_queue(), ^{
								[[NSNotificationCenter defaultCenter]
								 postNotificationName:@"userDealChange" object:nil];
						});
						
				} else {
						NSLog(@"Failed to save");
				}
		}];
		
		
				
				
		} completionBlock:^{
				[HUD removeFromSuperview];
				
				
				
				
				//Customize to dismiss the modal view, CreateDealViewController, from right to left
				CATransition *transition = [CATransition animation];
				transition.duration = 0.30;
				transition.timingFunction =
				[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
				transition.type = kCATransitionMoveIn;
				transition.subtype = kCATransitionFromRight;
				UIView *containerView = self.view.window;
				[containerView.layer addAnimation:transition forKey:nil];
				
				
				UserPostViewController *userPostViewController =
				[[UserPostViewController alloc] initWithName:YES];
				[userPostViewController setParseObject:self.parseObject];
				UINavigationController *navController = [[UINavigationController alloc]
																								 initWithRootViewController:userPostViewController];
				
				[self presentViewController:navController animated:NO completion:^{}];
		}];
		
		
		
		
}

-(void)cancel:(id)sender
{
		
		//Customize to dismiss the current modal view, present view controller, from left to right
		CATransition *transition = [CATransition animation];
		transition.duration = 0.30;
		transition.timingFunction =
		[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type = kCATransitionMoveIn;
		transition.subtype = kCATransitionFromLeft;
		
		UIView *containerView = self.view.window;
		[containerView.layer addAnimation:transition forKey:nil];
		
		//[[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
		[self dismissViewControllerAnimated:NO completion:nil];
		
		//[self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)editImage:(id)sender {
		
		
		
		// Temporarily save the description just
		
		
		UIColor *textColor = descriptField.textColor;
		
		if ([textColor isEqual:[UIColor blackColor]]) {
				
				[self.parseObject setObject:descriptField.text forKey:@"description"];
		}
		else {
				
				
				[self.parseObject removeObjectForKey:@"description"];
				//checkIfCommandIsRunning
				
				
				
		}
		
		
		
		
		
		
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
				
				
				// Get picked image from info dictionary
				UIImage *editImage = [info objectForKey:UIImagePickerControllerOriginalImage];
				[imageView setImage:editImage];
				self.image = editImage;
		}];
		
		
		
		
}




@end





























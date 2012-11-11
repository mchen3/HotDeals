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
				[priceField setKeyboardType:UIKeyboardTypeNumberPad];
				//}
		}
}

// UITextView has no placeholder option, so you create one manually and
// factor in all posibilites for entering text into descriptField
- (void)viewDidLoad{
		
		NSLog(@"CDVC loading");
		
		[descriptField becomeFirstResponder];
}

- (void) viewDidAppear:(BOOL)animated {
		
		NSLog(@"viewDidAppear");
		
		[imageView setImage:self.image];
		
}

- (void) viewDidDisappear:(BOOL)animated {
		
		
		
		NSLog(@"DISAPPEAR");
}

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
		if(descriptField.text.length == 0){
				descriptField.text = @"Describe the deal...";
				descriptField.textColor = [UIColor grayColor];
		}
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
		if (descriptField.textColor == [UIColor grayColor]) {
				descriptField.text = @"";
				descriptField.textColor = [UIColor blackColor];
		}
		return YES;
}



#pragma mark - ()

- (void)save:(id)sender
{
		
		
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
		
		
		//Customize to dismiss the modal view, CreateDealViewController, from right to left
		CATransition *transition = [CATransition animation];
		transition.duration = 0.90;
		transition.timingFunction =
		[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type = kCATransitionMoveIn;
		transition.subtype = kCATransitionFromRight;
		UIView *containerView = self.view.window;
		[containerView.layer addAnimation:transition forKey:nil];
		
		
		
		//[[self presentingViewController] dismissViewControllerAnimated:YES completion:^{
		//	}];
		
		
		//[self.parentViewController dismissViewControllerAnimated:NO completion:^{
		
		//}];
		
		
		//[self dismissViewControllerAnimated:NO  completion:^{	}];
		
		/*		[[self presentingViewController] dismissViewControllerAnimated:NO completion:^{
		 UserPostViewController *userPostViewController =
		 [[UserPostViewController alloc] initWithName:YES];
		 [userPostViewController setParseObject:self.parseObject];
		 UINavigationController *navController = [[UINavigationController alloc]
		 initWithRootViewController:userPostViewController];
		 //[self presentViewController:navController animated:NO completion:nil];
		 [self.parentViewController presentViewController:navController animated:NO completion:nil];
		 
		 }];
		 */
		
		
		// Doesn't work causes you to go back to uvc, error is about window not on hierrachy
		//[[self presentingViewController ] dismissViewControllerAnimated:YES completion:^{
		
		UserPostViewController *userPostViewController =
		[[UserPostViewController alloc] initWithName:YES];
		[userPostViewController setParseObject:self.parseObject];
		UINavigationController *navController = [[UINavigationController alloc]
																						 initWithRootViewController:userPostViewController];
		[self presentViewController:navController animated:NO completion:nil];
		//[self.parentViewController presentViewController:navController
		//animated:NO completion:nil];
		
		/*
		 NSLog(@"TEST %@", [self nibName]);
		 NSLog(@"REST %@", [self parentViewController]);
		 NSString *parent = [self parentViewController];
		 NSLog(@"d");
		 [self.parentViewController nibName];
		 */
		
		//[[self presentingViewController].navigationController pushViewController:userPostViewController animated:YES];
		
		
		//[self.navigationController pushViewController:userPostViewController animated:NO];
		//}];
		
		
		
		
		
		/* Push view
		 UserPostViewController *userPostViewController =
		 [[UserPostViewController alloc] initWithName:YES];
		 [userPostViewController setParseObject:self.parseObject];
		 UINavigationController *navController = [[UINavigationController alloc]
		 initWithRootViewController:userPostViewController];
		 
		 
		 // doesn't work, can't add nav controller on top of nav controller
		 //[self.navigationController pushViewController:navController animated:NO];
		 
		 [self.navigationController pushViewController:userPostViewController animated:NO];
		 */
		
		
		
		
		/*
		 UserPostViewController *userPostViewController =
		 [[UserPostViewController alloc] initWithName:YES];
		 [userPostViewController setParseObject:self.parseObject];
		 UINavigationController *navController = [[UINavigationController alloc]
		 initWithRootViewController:userPostViewController];
		 
		 [self presentViewController:navController animated:NO completion:nil];
		 */
		//[self.parentViewController presentViewController:navController animated:NO completion:nil];
		
		
		
		
		
		
		
		
		
		
		
		/*
		 [self.parentViewController dismissViewControllerAnimated:NO completion:^{
		 
		 // Create a nav controller so the CDVC can add nav items
		 UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createDealViewController];
		 [self presentViewController:navController animated:NO completion:nil];
		 }];*/
		
		
		
		
		
		
		
		/*    DEL
		 
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
		 //		CLLocation *location = [LocationDataManager sharedLocation].currentLocation;
		 //		NSString *locality = [LocationDataManager sharedLocation].currentPlacemark.locality;
		 
		 //		CLLocationCoordinate2D coordinate = [LocationDataManager sharedLocation].currentLocation.coordinate;
		 //		NSLog(@"Los");
		 
		 //		[self.parseObject setObject:locality forKey:@"locality"];
		 
		 
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
		 */
		
		
		
		
		
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





























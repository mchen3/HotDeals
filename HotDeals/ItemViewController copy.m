//
//  ItemViewController.m
//  DealMaker1
//
//  Created by Mike Chen on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemViewController.h"
#import "ImageStore.h"
#import "Items.h"
#import "ItemStore.h"
#import "CategoryPicker.h"
#import "Constants.h"

@interface ItemViewController ()
@end

@implementation ItemViewController
@synthesize item;
@synthesize dismissBlock;
@synthesize parseObject;

#pragma mark - Init

- (id)initWithName:(BOOL)isNew
{
		self = [super initWithNibName:@"ItemViewController" bundle:nil];
		
		// Hide the tab bar        
		self.hidesBottomBarWhenPushed = YES;
		
		if (self) {
				if (isNew) {
						// If the you are creating a new item, then
						// Add a save and a cancel button to the nav bar
						UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] 
										initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																				 target:self 
																				 action:@selector(save:)];
						[[self navigationItem] setRightBarButtonItem:saveItem];
				
						UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] 
						        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																				 target:self 
																				 action:@selector(cancel:)];
						[[self navigationItem] setLeftBarButtonItem:cancelItem];
				}
		}
		return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // Set title to item name
				//   [[self navigationItem] setTitle:[item itemName]];
        
        // Hide the tab bar
				//   self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark - ()

- (void)save:(id)sender
{
		
		// Create a new Parse object, when IVC gets dimissed, the table will
		// reload to server with this new Parse object
		/*
		 PFObject *object = [PFObject objectWithClassName:@"TestObject"];
		 [object setObject:[nameField text] forKey:@"name"];
		 */
		
		// A new parse parseobject was created and passed from [DVC add]
		[self.parseObject setObject:[nameField text] forKey:@"name"];
		
		// Set ACLs
		
		/*
		 // Save
		 [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		 if (error) {
		 NSLog(@"Could not save");
		 NSLog(@"%@", error);
		 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		 [alertView show];
		 }
		 
		 
		 if (succeeded) {
		 /*
		 NSLog(@"Successfully saved!");
		 dispatch_async(dispatch_get_main_queue(), ^{
		 [[NSNotificationCenter defaultCenter]
		 postNotificationName:kDealCreatedNotification object:nil];
		 });
		 
		 */
		
		/*
		 dispatch_async(dispatch_get_main_queue(), dismissBlock);
		 
		 
		 } else {
		 NSLog(@"Failed to save.");
		 }
		 
		 }];
		 */
		
		[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
				
		// Use dismissBlock to reload the tableView of the DVC for Ipad but
		// not Iphone. The iPhone automatically renews for DVC, 13.5
	 	//[[self presentingViewController] dismissViewControllerAnimated:YES
		//		completion:dismissBlock];
}

- (void)cancel:(id)sender
{
		// If the user cancels, remove the item from the store
		//[[ItemStore sharedStore] removeItems:item];
		[[self presentingViewController] dismissViewControllerAnimated:YES
																								completion:self.dismissBlock];
}

// Change the setter method for property Item item
-(void)setItem:(Items *)i
{
    item = i;
		
    // Set the title of the navigational bar
    [[self navigationItem] setTitle:[item itemName]];
}

- (IBAction)showCategory:(id)sender
{
		[[self view] endEditing:YES];
		CategoryPicker *category = [[CategoryPicker alloc] init];
		
		// Pass Items to CategoryPicker
		[category setItem:item];
		[[self navigationController] pushViewController:category animated:YES];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
		
		// Load the Parse objects that was passed from DealViewController
		[nameField setText: [self.parseObject objectForKey:@"name"]];
				
		//	NSString *imageKey = [item imageKey];
		//NSLog(@"%@", imageKey);
		
		// Load image through imageKey
		NSString *imageKey = [self.parseObject objectForKey:@"imageKey"];
		if (imageKey) {
				UIImage *image = 	[[ImageStore defaultImageStore] imageForKey:imageKey];
				[imageView setImage:image];
		}
		else {
				[imageView setImage:nil];
		}
				
		/* BNR
		/* Previous implemenation before Parse using Core Data
    // The item object is passed through DealViewController
    // on TableView:didselectRow    
    
    // Set the labels for name, description, value, and date created
    [nameField setText: [item itemName]];
    [descriptField setText:[item descriptions]];
    
    NSString *price = [NSString stringWithFormat:@"%d", [item valueInDollars]];
    [priceField setText:price];
    
		// Create a NSDateFormatter that will turn a date into a simple date string
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateStyle:NSDateFormatterMediumStyle];
		[format setTimeStyle:NSDateFormatterNoStyle];
		
		// Convert from time interval to date for DateLabel
		NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[item dateCreated]];
    [dateCreated setText:[format stringFromDate:date]];
    
		NSString *imageKey = [item imageKey];
		if (imageKey) {
				
				UIImage *image = 	[[ImageStore defaultImageStore] imageForKey:imageKey];
				[imageView setImage:image];
				
		}
		else {
				[imageView setImage:nil];
		}
		
		// Set the button category to the current category
		NSString *category = [[item category] valueForKey:@"label"];
		if (!category) {
				category = @"None";
		}
		[categoryButton setTitle:[NSString stringWithFormat:@"Type: %@",category]
										forState:UIControlStateNormal];
		*/
		
    /* Archiving
     Format Specifier %@ prints out too much info for NSDate  
     NSString *date = [NSString stringWithFormat:@"%@", [items dateCreated]];
     [dateCreated setText:date];
     */
    /* Archiving
		 NSDateFormatter *format = [[NSDateFormatter alloc] init];
		 [format setDateFormat:@"MM-dd-yyyy"];
		 NSString *date = [format stringFromDate:[item dateCreated]];
		 */ 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Clear the first responder
    [[self view] endEditing:YES];
    
		/*  BNR
		Core Data
    // Set any changed values of the text fields
    [item setItemName:[nameField text]];
    [item setDescriptions:[descriptField text]];
    [item setValueInDollars:[[priceField text] intValue]]; 
		 */ 
		
		// Set the changes in Parse
		// Might have to differentiate between new and old
		// otherwise you could be saving the object twice.
		// because the isNew already saves the object
		
		
		
	//	NSString *testParse1 = [parseObject objectForKey:@"name"];
	//	NSLog(@"viewdiddisappear 1  %@", testParse1);
		
		// Save the Parse objects in case the objects were edited.
		
		NSString *nameString = [nameField text];
		// Make sure the objects are not empty because Parse
		// cannot save objects that nil
		if (nameString) {
				[self.parseObject setObject:nameString forKey:@"name"];
				NSString *imageKeyString = [self.parseObject objectForKey:@"imageKey"];
				
				NSLog(@"Name field  %@", [nameField text]);
				NSLog(@"Image Picker  %@", imageKeyString);
		}		

		// Save in viewdiddisappear instead of in the save function
		[self.parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
				if (error) {
						NSLog(@"Could not save");
						NSLog(@"%@", error);
						UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
						[alertView show];
				}
				if (succeeded) {
						/*
						 NSLog(@"Successfully saved!");
						 dispatch_async(dispatch_get_main_queue(), ^{
						 [[NSNotificationCenter defaultCenter]
						 postNotificationName:kDealCreatedNotification object:nil];
						 });
						 */
						dispatch_async(dispatch_get_main_queue(), self.dismissBlock);
						
				} else {
						NSLog(@"Failed to save.");
				}
		}];
		
		
		
		
		/* Testing after pulling values from [ParseObject objectForKey]
	  //	[parseObject setObject:@"11111" forKey:@"name"];

		//NSString *testParse2 = [parseObject objectForKey:@"name"];
		//NSLog(@"viewdiddisappear 2  %@", testParse2);

		//[parseObject saveInBackground];

		//NSString *testParse3 = [parseObject objectForKey:@"name"];
    //NSLog(@"viewdiddisappear 3  %@", testParse3);
		*/
		

	// BNR
	//	[item setItemName:[nameField text]];

		
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set the background color of the item view to the table view color
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewDidUnload
{
    imageView = nil;
		
		categoryButton = nil;
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

// Press enter on the keyboard to dismiss
- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // UITextView doesn't have a delegate method
    // for pressing the return key like UITextView
    // so you use this delegate method, textView:shouldChange
    // to dimiss yhe keyboard when you press return 
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Camera

- (IBAction)takePicture:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If the device has a camera we will take a picture otherwise we will
    // choose from the photo library
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // Must add UINavigationControllerDelegate, UIImagePickerControllerDelegate
    // otherwise you will get a warning
    [imagePicker setDelegate:self];
		
    [self presentModalViewController:imagePicker animated:YES];
}
							
// Delegate for UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
		
		// If the item has an old image, delete it from the
		// Parse servers
		/*
		NSString *oldImageKey = [parseObject objectForKey:@"imageKey"];
		if (oldImageKey) {
				[[ImageStore defaultImageStore] deleteImageForKey:oldImageKey];
		}
		*/
		
		// BNR
		// If the item has an old image, delete it from the 
		// ImageStore to save on memory
		/*
		NSString *oldImage = [item imageKey];
		if (oldImage) {
				[[ImageStore defaultImageStore] deleteImageForKey:oldImage];
		}
		*/
		
    // Get picked image from info dictionary
   UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];		
		
		// Create a CFUUID object - it knows how to create unique
		// identifier strings
		CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
		
		// Create a string from unique identifier
		CFStringRef newUniqueIDString =
		CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
		
		// Need to bridge CFStringRef to NSString
		NSString *key = (__bridge NSString *)newUniqueIDString;
		// imageKey = (__bridge NSString *)newUniqueIDString;

		// Use that unique ID to set our item's imageKey
		// [item setImageKey:key];
		
		// IF this was a new item, parseObject has not been created
		// can't set any values to nil
		[self.parseObject setObject:key forKey:@"imageKey"];

		
		NSString *holdImage = [self.parseObject objectForKey:@"imageKey"];
		NSLog(@" Hello %@", holdImage);
		
		// Store image in the ImageStore with this key
		[[ImageStore defaultImageStore] setImage:image forKey:key];
		
		CFRelease(newUniqueIDString);
		CFRelease(newUniqueID);

		
		/*
		// Create a thumbnail from the image
		[item setThumbnailDataFromImage:image];
		 */
		
    // Take the image picker off the screen
   // [self dismissViewControllerAnimated:YES completion:nil];
		
		[self dismissViewControllerAnimated:YES completion:^{
				
				/*
				[[ImageStore defaultImageStore] setReloadBlock:^{
						
						// Parse get Parse image and set it
						UIImage *parseImage = [[ImageStore defaultImageStore] imageForKey:imageKey];
						
						[imageView setImage:parseImage];
				}];
				*/
		}];
		
}

			
@end


























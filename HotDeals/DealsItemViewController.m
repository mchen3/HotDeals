//
//  ItemViewController.m
//  DealMaker1
//
//  Created by Mike Chen on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DealsItemViewController.h"
#import "ImageStore.h"
#import "UserViewController.h"
#import "MapPostViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DealsItemViewController ()
@end

@implementation DealsItemViewController
@synthesize dismissBlock;
@synthesize parseObject;
@synthesize userNameOfDeal;

#pragma mark - Init

- (id)initWithName:(BOOL)isNew
{
		self = [super initWithNibName:@"DealsItemViewController" bundle:nil];
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
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
		[descriptField setText: [self.parseObject objectForKey:@"description"]];
		[priceLabel setText:[self.parseObject objectForKey:@"price"]];
		
		// Set the Image
		NSString *imageKey = [self.parseObject objectForKey:@"imageKey"];
		if (imageKey) {
			
				/* We want to load the big imageView asynchronously so the UI will be more
				responsive. We will pass our PFImageView imageView and imageKey to the 
				ImageStore so that class will take care of setting our image. */
				[[ImageStore defaultImageStore] setLazyLoadPFImageView:imageView];
				[[ImageStore defaultImageStore] imageForKey:imageKey];
		}
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Clear the first responder
    [[self view] endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
		// Set the color of the nav items back button and all other buttons
		// for viewcontrollers that get pushed onto the stack
		[[UIBarButtonItem appearance] setTintColor:[UIColor darkGrayColor]];
		
		// Make the description field and image rounded on the corners,
		// must import the QuartzCore class
		descriptField.layer.cornerRadius = 7.5;
		imageView.layer.cornerRadius = 10;

		// Show the date the deal was created
		NSDate *dateData = self.parseObject.createdAt;
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"MM-dd-yyyy"];
		NSString *dateString = [formatter  stringFromDate:dateData];
		[dateLabel setText:dateString];
		
		/* Show the username and profile image of the person who created the deal. 
		 The user data for PFUser is only available for the current user
		 so we must fetch for the user data of the random PFUser*/ 
		PFUser *user = self.userNameOfDeal;
		[user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
				if (!error) {
						NSString *userString = user.username;
						//IF the username is too long, auto shrink
						userButtonLabel.titleLabel.adjustsFontSizeToFitWidth = TRUE;
						[userButtonLabel setTitle:userString forState:UIControlStateNormal];
										
						PFFile *profileImageFile = [object objectForKey:@"profileImage"];
						if (profileImageFile) {
								NSData *profileImageData = [profileImageFile getData];
								UIImage *profileImage = [UIImage imageWithData:profileImageData];
								[self.profileImageView setImage:profileImage];
						}else{
								UIImage *tempProfileImage = [UIImage imageNamed:@"Time.png"];
								[self.profileImageView  setImage:tempProfileImage];
						}
				}
		}];
		
		
}

- (void)viewDidUnload
{
    imageView = nil;
		
    mapPinView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Interface methods

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

#pragma mark - Button actions
// Select button to see user profile
- (IBAction)userButton:(id)sender {
		// Call UserViewController and set its format based on the Deals Tab
		UserViewController *userViewController = [[UserViewController alloc]
																							initWithTab:@"DealTab"];
		// Pass the username of this deal so UserViewController
		// can query it's table based upon the username
		[userViewController setUserNameOfDeal:self.userNameOfDeal];
		[self.navigationController pushViewController:userViewController animated:YES];
}

- (IBAction)mapButton:(id)sender {
		// Display the exact location of this deal
		MapPostViewController *mapPostViewController = [[MapPostViewController alloc] init];
		// Pass our parse object
		[mapPostViewController setParseObject:self.parseObject];
		[self.navigationController pushViewController:mapPostViewController animated:YES];
}
			
@end


























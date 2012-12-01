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

@interface UserPostViewController ()
@end

@implementation UserPostViewController
@synthesize dismissBlock;
@synthesize parseObject;

#pragma mark - Init

- (id)initWithName:(BOOL)isNew
{
		self = [self initWithNibName:@"UserPostViewController" bundle:nil];
		
				// ? hide the tab bar
		self.hidesBottomBarWhenPushed = YES;
		
		if (self) {
				
				NSLog(@"UserPost INIT");
				
				// If you are creating a new item, then
				// add a save and cancel button to the nav bar
				UIBarButtonItem *editItem = [[UIBarButtonItem alloc]
						initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
				[editItem setTintColor:[UIColor darkGrayColor]];
				[[self navigationItem] setRightBarButtonItem:editItem];
				
				UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
						initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
				[doneItem setTintColor:[UIColor darkGrayColor]];
				[[self navigationItem] setLeftBarButtonItem:doneItem];
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

		[self dismissViewControllerAnimated:NO completion:^{}];
}

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

#pragma mark - Buttons

- (IBAction)mapButton:(id)sender {
		// Show the map of the deal 
		MapPostViewController *mapPostViewController = [[MapPostViewController alloc] init];
		// Pass our parse object
		[mapPostViewController setParseObject:self.parseObject];
		
		[self.navigationController pushViewController:mapPostViewController animated:YES];
}
@end






















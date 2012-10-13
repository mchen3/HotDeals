//
//  UserPostViewController.m
//  HotDeals
//
//  Created by Mike Chen on 10/12/12.
//
//

#import "UserPostViewController.h"

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
		
		[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancel:(id)sender
{
		[[self presentingViewController] dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
		[nameField setText:[self.parseObject objectForKey:@"name"]];
		
		
}

- (void)viewWillDisappear:(BOOL)animated
{
		[super viewWillDisappear:animated];
		
		// Clear the first responder
		[[self view] endEditing:YES];
		
		
		// Save the parse objects in case the objects were edited.
		
		NSString *nameString = [nameField text];
		
		//Make sure the objects are not empty because Parse
		// cannot save objects that are nil
		if (nameString) {
				[self.parseObject setObject:nameString forKey:@"name"];
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
						dispatch_async(dispatch_get_main_queue(), self.dismissBlock);
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end






















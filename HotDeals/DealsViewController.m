//
//  DealViewController.m
//  DealMaker1
//
//  Created by Mike Chen on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DealsViewController.h"
#import "Items.h"
#import "ItemStore.h"
#import "ProfileViewController.h"
#import "DealsItemViewController.h"
#import "ItemCell.h"
#import "DealsParseTableController.h"
#import "Constants.h"
#import "LocationDataManager.h"
#import <QuartzCore/QuartzCore.h>

@interface DealsViewController ()
@property (nonatomic, strong) DealsParseTableController *dealsParseTableController;
@end

@implementation DealsViewController

@synthesize dealsParseTableController = _dealsParseTableController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set the title of the nav bar
				//  [[self navigationItem] setTitle:@"DVC Deals"];
        
				/* DEL
				 There is no edit or delete for the DVC
				 // Add a right bar button of type 'ADD' programmically
				 // to add items to the table
				 UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
				 [[self navigationItem] setRightBarButtonItem:button];
				 
				 // If your class was a UITableViewController, then all you
				 // do is add a editButtonItem and the table view is hooked
				 // up automatically to toggle between done and edit
				 // But you have a UIViewController that doesn't have a
				 // table view as its view so you need to override the
				 // setEditing:animated method
				 [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
				 */
				
		}
    return self;
}

#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib
		
		// Set the nav bar to black
		[self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

		// Add a little padding next to the search icon inside the address field
		UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
		addressField.leftView = paddingView;
		addressField.leftViewMode = UITextFieldViewModeAlways;
		
		// Set the values for the enterAddress and currentAddress buttons
		/* Customize the background color of our UIbuttons. Currently the only way
		   to set the background color of UIButton is to set an image. We use our
		   method imageFromColor to set the color */
		[enterAddressButton setBackgroundImage:[DealsViewController imageFromColor:[UIColor darkGrayColor]]forState:UIControlStateNormal];
		enterAddressButton.layer.cornerRadius = 8.0;
		enterAddressButton.layer.masksToBounds = YES;
		enterAddressButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
		enterAddressButton.layer.borderWidth = 1;
		// Set the font type and size
		[enterAddressButton.titleLabel setFont:		[UIFont fontWithName:@"Arial Rounded MT Bold" size:13.0]];
		// Customize our button to include line breaks so words are on top of each other
		[enterAddressButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[enterAddressButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
		[enterAddressButton setTitle:@"Enter\nAddress" forState:UIControlStateNormal];
		
		[currentAddressButton setBackgroundImage:[DealsViewController imageFromColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
		currentAddressButton.layer.cornerRadius = 8.0;
		currentAddressButton.layer.masksToBounds = YES;
		currentAddressButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
		currentAddressButton.layer.borderWidth = 1;
		[enterAddressButton.titleLabel setFont:		[UIFont fontWithName:@"Arial Rounded MT Bold" size:13.0]];
		[currentAddressButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[enterAddressButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
		[currentAddressButton setTitle:@"Current\nAddress" forState:UIControlStateNormal];
		
		
		// Load the lib for the table cell and register it to the tableView
		UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
		//[table registerNib:nib forCellReuseIdentifier:@"ItemCell"];
		
		// Add the wall posts tableview as a subview with view containment (new in iOS 5.0):
		
		
		self.dealsParseTableController = [[DealsParseTableController alloc] initWithStyle:UITableViewStylePlain];
		
		[self.dealsParseTableController.tableView setRowHeight:80];
		[self.dealsParseTableController.tableView setSeparatorColor:[UIColor darkGrayColor]];
		// Use custom ItemCell
		[self.dealsParseTableController.tableView registerNib:nib forCellReuseIdentifier:@"ItemCell"];
		
		
		// Configure parse table to display based on location
		[self.dealsParseTableController setDealBasedOn:@"currentLocation"];
		
		[self addChildViewController:self.dealsParseTableController];
		[self.view addSubview:self.dealsParseTableController.view];
		// COnfig just at the edge, showing a little
		self.dealsParseTableController.view.frame = CGRectMake(0.f, 58.f, 320.f, 408.f);
		//self.dealsParseTableController.view.frame = CGRectMake(0.f, 200.f, 320.f, 370.f);
		//self.dealsParseTableController.view.frame = CGRectMake(0.f, 0.f, 320.f, 370.f);
		
		
		// ??? Notifications
		[[NSNotificationCenter defaultCenter] addObserver:self
																						 selector:@selector(dealCreated:) name:kDealCreatedNotification object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedCurrentLocation) name:@"updatedCurrentLocation" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedAddressLocation) name:@"updatedAddressLocation" object:nil];
}

- (void)viewDidUnload
{
		addressField = nil;
    [super viewDidUnload];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self
																										name:kDealCreatedNotification object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self
																										name:@"updatedCurrentLocation" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self
																										name:@"updatedAddressLocation" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
		// ???
    // Reload the table data just in case changes were made in
    // another view controller
    // [table reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
		[[NSNotificationCenter defaultCenter] removeObserver:self
																										name:kDealCreatedNotification object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self
																										name:@"updatedCurrentLocation" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self
																										name:@"updatedAddressLocation" object:nil];
		
}

#pragma mark - Notification callback
// ???
// Called after the notification notifies that a deal was created
// so you now need to refresh the table.
-(void)dealCreated {
		
}

// DEL
// There is no edit or delete button for DVC
#pragma mark - NavBar buttons
/*
 -(void)setEditing:(BOOL)editing animated:(BOOL)animated
 {
 [super setEditing:editing animated:animated];
 
 if (table.editing) {
 // Turn off editing mode
 table.editing = NO;
 self.dealsParseTableController.tableView.editing = NO;
 }else {
 // Done state
 table.editing = YES;
 self.dealsParseTableController.tableView.editing = YES;
 }
 }
 
 -(IBAction)addNewItem:(id)sender
 {
 /*** DEL
 BNR
 // Create a item
 Items *lastItem = [[ItemStore sharedStore] createItem];
 // Make an index path for the 0th section, last row
 int lastRow = [[[ItemStore sharedStore] allItems] indexOfObject:lastItem];
 NSIndexPath *path = [NSIndexPath indexPathForRow:lastRow inSection:0];
 
 // Insert into table view, pass an array with index path
 [table insertRowsAtIndexPaths:[NSArray arrayWithObject:path ] withRowAnimation:UITableViewRowAnimationTop];
 */
// Let Item controller create a new item
/*
 Items *item = [[ItemStore sharedStore] createItem];
 
 ItemViewController *ivc = [[ItemViewController alloc] initWithName:YES];
 [ivc setItem:item];
 */

/*
 // Add a new Parse object and pass it to ItemViewController
 PFObject *parseObject = [PFObject objectWithClassName:@"TestObject"];
 DealsItemViewController *dealsItemViewController = [[DealsItemViewController alloc] initWithName:YES];
 [dealsItemViewController setParseObject:parseObject];
 
 // Why use a navController?
 // Add navcontroller when you are creating a new item, else
 // a nav controller is not needed.
 // DealItemViewController will initWithName:YES when you add
 // new item
 UINavigationController *navController = [[UINavigationController alloc]
 initWithRootViewController:dealsItemViewController];
 
 [navController setModalPresentationStyle:UIModalPresentationFormSheet];
 [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
 
 
 // Pass a block to reload the table to the ItemViewController
 // Need a dismiss block to reload data for the iPad but not for iPhone
 // 13.5 for explanation
 [dealsItemViewController setDismissBlock: ^{
 //    DVC's table
 //		[table reloadData];
 
 //		[ParseTVC.tableView reloadData];
 
 // Load the parse objects after you create a new Parse object
 // Only reload the block if the save was successful.
 [self.dealsParseTableController loadObjects];
 }];
 [self presentViewController:navController animated:YES completion:nil];
 }
 */

#pragma mark - UITableView actions

// User presses delete when the table view is in edit mode
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove the item from the ItemStore
        Items *item =  [[[ItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
        [[ItemStore sharedStore] removeItems:item];
				
        // Remove the item from the table view
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade] ;
    }
}

// Reorder the table rows
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[ItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
}


#pragma mark - UITableView datasource

-(UITableViewCell *)tableView:(UITableView *)tableView
				cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
		 // Check for reusable cell first, use if there is one
		 UITableViewCell *cell = [tableView
		 dequeueReusableCellWithIdentifier:@"UITableViewController"];
		 
		 // If there is no reusable cell, then create a new one
		 if (!cell) {
		 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableCellIdentifier"];
		 }
		 
		 NSString *itemsDescription= [[NSString alloc] initWithFormat:@"%@", [item itemDescriptions]];
		 [[cell textLabel] setText: itemsDescription];
		 */
		
		// Cell has been created in ViewDidLoad, so just grab the cell
		ItemCell *cell = [tableView
											dequeueReusableCellWithIdentifier:@"ItemCell"];
		
    Items *item = [[[ItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
		
		
		[[cell descriptionLabel] setText:[item descriptions]];
		[[cell priceLabel] setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
		
		// Create a NSDateFormatter that will turn a date into a simple date string
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateStyle:NSDateFormatterMediumStyle];
		[format setTimeStyle:NSDateFormatterNoStyle];
		
		// Convert from time interval to date for DateLabel
		NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[item dateCreated]];
		[[cell dateLabel] setText:[format stringFromDate:date]];
		[[cell thumbnailView] setImage:[item thumbnail]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ItemStore sharedStore]allItems]count];
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
		//Retrieve an item from the ItemStore
    Items *item = [[[ItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    DealsItemViewController *itemViewController = [[DealsItemViewController alloc] initWithName:NO];
    
    // Pass the item object to the Items View Controller
    [itemViewController setItem:item];
    [[self navigationController] pushViewController:itemViewController animated:YES];
		
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
		// [tableView setEditing:NO];
		// tableView.editing = NO;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO];
}


#pragma mark - Interface

- (IBAction)backgroundTouched:(id)sender {
		[[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
		[textField resignFirstResponder];
		return true;
}


// Search for deals based on the address the user has entered
- (IBAction)dealsBasedOnAddress:(id)sender {
		
		NSLog(@"Address pressed");
		
		LocationDataManager *locationManager = [LocationDataManager sharedLocation];
		
		// Validate user address
		NSString *userEnteredAddress = [addressField text];
		if (userEnteredAddress ) {
				[locationManager findLocationByForwardGeocoding:userEnteredAddress];
		}
		
}

// Search deals based on user's current location
- (IBAction)dealsBasedOnUserLocation:(id)sender {
		LocationDataManager *locationManager = [LocationDataManager sharedLocation];
		NSLog(@"Current location pressed - startUpdatingCurrentLocation");
		[locationManager startUpdatingCurrentLocation];
		//[locationManager currentLocationByReverseGeocoding];
}

// Class method we used to customize the color of our UIButton
+ (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - NSNotification handlers
- (void)updatedCurrentLocation {
		
		// A notification was recieved, we have updated to user's current location
		// Update the title bar to reflect the new address
		LocationDataManager *locationManager = [LocationDataManager sharedLocation];
		CLPlacemark *placemark = locationManager.currentPlacemark;
		
		// Set the nav title to the address dictionary of our current placemark
		NSArray *formattedAddressLines = [placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
		NSString *address = [formattedAddressLines objectAtIndex:1];
		[[self navigationItem] setTitle:address];
		
		// Release the keyboard after you found an address
		[addressField resignFirstResponder];
}

- (void)updatedAddressLocation {
		
		// A notification was recieved, we have updated to a location that the user
		// has specified. Update the title bar to reflect the address
		LocationDataManager *locationManager = [LocationDataManager sharedLocation];
		CLPlacemark *placemark = locationManager.addressPlacemark;
		
		// Set the nav title to the address dictionary of our current placemark
		NSArray *formattedAddressLines = [placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
		NSString *address = [formattedAddressLines objectAtIndex:1];
		[[self navigationItem] setTitle:address];
		
		// Release the keyobard after you found an address
		[addressField resignFirstResponder];
		
}
@end


























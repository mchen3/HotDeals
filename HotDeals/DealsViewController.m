//
//  DealViewController.m
//  DealMaker1
//
//  Created by Mike Chen on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DealsViewController.h"
#import "ProfileViewController.h"
#import "DealsItemViewController.h"
#import "ItemCell.h"
#import "DealsParseTableController.h"
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
		UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 20)];
		addressField.leftView = paddingView;
		addressField.leftViewMode = UITextFieldViewModeAlways;
		// Change the color of the border line. Must import QuartzCore
    addressField.layer.masksToBounds=YES;
    addressField.layer.borderColor=[[UIColor darkGrayColor]CGColor];
    addressField.layer.borderWidth= 1;
		
		// Set the values for the enterAddress and currentAddress buttons
		/* Customize the background color of our UIbuttons. Currently the only way
		   to set the background color of UIButton is to set an image. We use our
		   method imageFromColor to set the color. Must import QuartzCore class */
		// Set the color to light blue with heavy transparancy
		[enterAddressButton setBackgroundImage:[DealsViewController imageFromColor:[UIColor colorWithRed:31.0/255.0 green:90.0/255.0 blue:255.0/255.0 alpha:.3]]forState:UIControlStateNormal];
		enterAddressButton.layer.cornerRadius = 7.5;
		enterAddressButton.layer.masksToBounds = YES;
		// Set the border color to be the same as the background	
		// 	Will create a light blue transparent line around the edge of the button
		enterAddressButton.layer.borderColor = [UIColor colorWithRed:31.0/255.0 green:90.0/255.0 blue:255.0/255.0 alpha:.3].CGColor;
		enterAddressButton.layer.borderWidth = 1;
		// Customize our button to include line breaks so words are on top of each other
		[enterAddressButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[enterAddressButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
		[enterAddressButton setTitle:@"Enter\nAddress" forState:UIControlStateNormal];
		[enterAddressButton.titleLabel setTextColor:[UIColor blueColor]];

		[currentAddressButton setBackgroundImage:[DealsViewController imageFromColor:[UIColor colorWithRed:31.0/255.0 green:90.0/255.0 blue:255.0/255.0 alpha:.3]]forState:UIControlStateNormal];
		currentAddressButton.layer.cornerRadius = 7.5;
		currentAddressButton.layer.masksToBounds = YES;
		currentAddressButton.layer.borderColor = [UIColor colorWithRed:31.0/255.0 green:90.0/255.0 blue:255.0/255.0 alpha:.3].CGColor;
		currentAddressButton.layer.borderWidth = 1;
		[currentAddressButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[enterAddressButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
		[currentAddressButton setTitle:@"Current\nAddress" forState:UIControlStateNormal];
		[currentAddressButton.titleLabel setTextColor:[UIColor blueColor]];

		// Load the lib for the table cell and register it to the tableView
		UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
		
		self.dealsParseTableController = [[DealsParseTableController alloc] initWithStyle:UITableViewStylePlain];
		// Configure the parse table to display based on current location
		[self.dealsParseTableController setDealBasedOn:@"currentLocation"];
		[self.dealsParseTableController.tableView setRowHeight:80];
		[self.dealsParseTableController.tableView
								setSeparatorColor:[UIColor darkGrayColor]];
		// Use custom ItemCell
		[self.dealsParseTableController.tableView registerNib:nib forCellReuseIdentifier:@"ItemCell"];
		
		// Add the wall posts tableview as a subview with view containment (new in iOS 5.0):
		[self addChildViewController:self.dealsParseTableController];
		[self.view addSubview:self.dealsParseTableController.view];
		// COnfig just at the edge, showing a little
		self.dealsParseTableController.view.frame = CGRectMake(0.f, 58.f, 320.f, 408.f);
				
		// We will use these two notifications to update our nav. title bar
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedCurrentLocation) name:@"updatedCurrentLocation" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedAddressLocation) name:@"updatedAddressLocation" object:nil];
}

- (void)viewDidUnload
{
		addressField = nil;
    [super viewDidUnload];
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:@"updatedCurrentLocation" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:@"updatedAddressLocation" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:@"updatedCurrentLocation" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:@"updatedAddressLocation" object:nil];		
}
//Test git
#pragma mark - Interface actions and helper

- (IBAction)backgroundTouched:(id)sender {
		[[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
		[textField resignFirstResponder];
		return true;
}

// Class method we used to customize the color of our UIButton
+ (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Button actions

// Search for deals based on the address the user has entered
- (IBAction)dealsBasedOnAddress:(id)sender {
		
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
		[locationManager startUpdatingCurrentLocation];
}

#pragma mark - NSNotification callbacks
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


























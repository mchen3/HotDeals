//
//  UserViewController.m
//  HotDeals
//
//  Created by Mike Chen on 10/11/12.
//
//

#import "UserViewController.h"
#import "DealsParseTableController.h"
#import "DealsItemViewController.h"
#import "UserPostViewController.h"
#import "NewsViewController.h"
#import "UserParseTableController.h"


@interface UserViewController ()
@property (nonatomic, strong) UserParseTableController *userParseTableController;
@end

@implementation UserViewController
@synthesize userParseTableController = _userParseTableController;
@synthesize UserViewBasedOn = _UserViewBasedOn;
@synthesize userNameOfDeal = _userNameOfDeal;

- (id)initWithTab:(NSString *)TabBasedOn
{
		self = [super initWithNibName:@"UserViewController" bundle:nil];
		self.UserViewBasedOn = TabBasedOn;

		if ([self.UserViewBasedOn isEqualToString:@"DealTab"]) {
				//??? Change to show the username of the random profile
				[[self navigationItem] setTitle:@"UVC Random Profile"];
		}
		
		if (self) {
				// If this UserViewController is inside the user tab then
				// this user is viewing his own profile. Allow editing and
				// posting new deals.
				if ([self.UserViewBasedOn isEqualToString:@"UserTab"]) {
						
						// Set the title of the nav bar to be the user
						[[self navigationItem] setTitle:@"UVC User Profile"];
						
						// Add a right bar button of type 'ADD' programmically
						// to add items to the table
						UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
						[[self navigationItem] setRightBarButtonItem:button];
						[[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
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

- (void)viewWillAppear:(BOOL)animated
{
		// Make sure the flag DealBasedOn is always set to "user" for the
		// UserViewController when you use DealsParseTableController
		//[self.dealsParseTableController setDealBasedOn:@"user"];
	  // [self.dealsParseTableController loadObjects];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
		
		
		
		// DealsParseTableController for the UserViewController
		
		// Load the lib for the table cell and register it to the tableView
		UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
		//[table registerNib:nib forCellReuseIdentifier:@"ItemCell"];
		
		// Add the wall posts tableView as a subview with view containment (new in iOS 5.0);
		self.userParseTableController = [[UserParseTableController alloc] initWithStyle:UITableViewStylePlain];
		
		// Pass the flag UserViewBasedOn which tells the UserParseTableController
		// what tab (Deal or User) you are in
		[self.userParseTableController setUserViewBasedOn:self.UserViewBasedOn];
		// Pass the parse Object so the parse table can query based on
		// the username of the deal if you are in the Deals Tab
		[self.userParseTableController setUserNameOfDeal:self.userNameOfDeal];
		
		// Configure parse to display deals based on UserID
		//[self.dealsParseTableController setDealBasedOn:@"user"];
		
		
		[self addChildViewController:self.userParseTableController];
		[self.view addSubview:self.userParseTableController.view];
		self.userParseTableController.view.frame = CGRectMake(0.f, 70.f, 320.f, 380.f);
				
		// Use custom ItemCell
		[self.userParseTableController.tableView registerNib:nib forCellReuseIdentifier:@"ItemCell"];
		[self.userParseTableController.tableView setSeparatorColor:[UIColor redColor]];
		
		
		
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - NavBar buttons

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
		[super setEditing:editing animated:animated];
		
		if (self.userParseTableController.tableView.editing) {
				self.userParseTableController.tableView.editing = NO;
		}else {
				self.userParseTableController.tableView.editing = YES;
		}
}

-(void)addNewItem:(id)sender
{
		// Add a new Parse object and pass it to dealsItemViewController
		PFObject *parseObject = [PFObject objectWithClassName:@"TestObject"];
		
		
		UserPostViewController *userPostViewController = [[UserPostViewController alloc]
																											initWithName:YES];
		[userPostViewController setParseObject:parseObject];
		
		
		// Why add a navController?
		// Because the modal view needs some way to dismiss itself
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:userPostViewController];
		[navController setModalPresentationStyle:UIModalPresentationFormSheet];
		[navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
		
		// Pass a block to reload the table to the DealsItemViewController
		// Need a dismiss block to reload data for the iPad but not for iPhone
		// 13.5 for explantion
		[userPostViewController setDismissBlock:^{
				[self.userParseTableController loadObjects];
		}];
		
		[self presentViewController:navController animated:YES completion:nil];
		
}

@end



























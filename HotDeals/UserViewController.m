//
//  UserViewController.m
//  HotDeals
//
//  Created by Mike Chen on 10/11/12.
//
//

#import "UserViewController.h"
#import "ParseTableController.h"
#import "DealsItemViewController.h"
#import "UserPostViewController.h"
#import "NewsViewController.h"


@interface UserViewController ()
@property (nonatomic, strong) ParseTableController *parseTableController;
@end

@implementation UserViewController
@synthesize parseTableController = _parseTableController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set the title of the nav bar to be the user
				[[self navigationItem] setTitle:@"User"];
				
				// Add a right bar button of type 'ADD' programmically
				// to add items to the table
				UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
				[[self navigationItem] setRightBarButtonItem:button];
				
				[[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
				
		
				
				
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
		// Make sure the flag DealBasedOn is always set to "user" for the
		// UserViewController when you use ParseTableController
		[self.parseTableController setDealBasedOn:@"user"];
	  // [self.parseTableController loadObjects];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
		
		
		
		// ParseTableController for the UserViewController
		
		// Load the lib for the table cell and register it to the tableView
		UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
		//[table registerNib:nib forCellReuseIdentifier:@"ItemCell"];
		
		// Add the wall posts tableView as a subview with view containment (new in iOS 5.0);
		self.parseTableController = [[ParseTableController alloc] initWithStyle:UITableViewStyleGrouped];
		
		// Configure parse to display deals based on UserID
		[self.parseTableController setDealBasedOn:@"user"];
		
		[self addChildViewController:self.parseTableController];
		[self.view addSubview:self.parseTableController.view];
		self.parseTableController.view.frame = CGRectMake(0.f, 70.f, 320.f, 300.f);
		[self.parseTableController.tableView registerNib:nib forCellReuseIdentifier:@"ItemCell"];
		[self.parseTableController.tableView setSeparatorColor:[UIColor redColor]];
		
		
		
		
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
		
		if (self.parseTableController.tableView.editing) {
				self.parseTableController.tableView.editing = NO;
		}else {
				self.parseTableController.tableView.editing = YES;
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
				[self.parseTableController loadObjects];
		}];
		
		[self presentViewController:navController animated:YES completion:nil];
		
}

@end



























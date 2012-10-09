//
//  DealViewController.m
//  DealMaker1
//
//  Created by Mike Chen on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DealViewController.h"
#import "Items.h"
#import "ItemStore.h"
#import "NewsViewController.h"
#import "ItemViewController.h"
#import "ItemCell.h"

@interface DealViewController ()

@property (nonatomic, strong) MyTableController *ParseTVC;

@end

@implementation DealViewController

@synthesize ParseTVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Get the tab bar item
    
        /*
      UITabBarItem *tbi =  [[self navigationController] tabBarItem];
        [tbi setTitle:@"Deal of the day"];
        */
        
        /*
        for (int i=0; i<=2 ; i++) {
            [[ItemStore sharedStore]createItem];
        }
         */

        // Set the title of the nav bar
        [[self navigationItem] setTitle:@"Deals"];
        

        // Add a right bar button of type ADD programmically
        // to add items to the table
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        [[self navigationItem] setRightBarButtonItem:button];
        
        // If your class was a UITableViewController, then all you 
        // do is add a ediButtonItem and the table view is hooked
        // up automatically to toggle between done and edit
        // But you have a UIViewController that doesn't have a
        // table view as its view so you need to override the 
        // setEditing:animated method 
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
				
				
		}
    return self;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (table.editing) {
        // Turn off editing mode
        table.editing = NO;
    }else {
        // Done state
        table.editing = YES;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    // Set background image of the table view
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image.png"]];
    [image setFrame:table.frame];
   // [table setBackgroundView:image];
		
		// Load the lib for the table cell and register it to the tableView
		UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
		
		[table registerNib:nib forCellReuseIdentifier:@"ItemCell"];
		
		
		
		// Parse Query Table
		self.ParseTVC = [[MyTableController alloc] initWithStyle:UITableViewStylePlain];
		[self addChildViewController:self.ParseTVC];
		self.ParseTVC.view.frame = CGRectMake(0.f, 150.f, 320.f, 208.f);
		[self.view addSubview:self.ParseTVC.view];
		

		
		PFObject *test = [PFObject objectWithClassName:@"TestObject"];
		[test setObject:@"Mon" forKey:@"name"];
		//[test save];

		
		
		/*
		PFObject *object = [PFObject objectWithClassName:@"TestObject"];
		//[object setValue:@"9" forKey:@"foo"];
		
	//	[object setObject:@"10" forKey:@"foo"];
	//	[object addUniqueObjectsFromArray:[NSArray arrayWithObjects:@"flying", @"kungfu", nil] forKey:@"foo"];
		
		[object addObject:@"11" forKey:@"foo"];
		[object addObject:@"12" forKey:@"foo"];
		 */
				

		
		/*
		// Query
	 // PFObject *object = [PFObject objectWithClassName:@"TestObject"];
 		PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
		PFObject *object = [query getObjectWithId:@"NNp9tFiGWR"];
		[object setValue:@"1" forKey:@"foo"];
		[object setValue:@"2" forKey:@"name"];
		[object setValue:[NSNumber numberWithInt:50] forKey:@"score"];
		 */
		
		/*
		PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
		//	[ACL setPublicReadAccess:YES];
		[ACL setPublicWriteAccess:YES];
		[object setACL:ACL];
		[object saveInBackground];
		 */
		
		
		

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Reload the table data just in case changes were made in 
    // another view controller
    [table reloadData];
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)addNewItem:(id)sender
{
		/*
    // Create a item
    Items *lastItem = [[ItemStore sharedStore] createItem];
    // Make an index path for the 0th section, last row
    int lastRow = [[[ItemStore sharedStore] allItems] indexOfObject:lastItem];
    NSIndexPath *path = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // Insert into table view, pass an array with index path
    [table insertRowsAtIndexPaths:[NSArray arrayWithObject:path ] withRowAnimation:UITableViewRowAnimationTop];
		*/

		// Let Item controller create a new item
		
		Items *item = [[ItemStore sharedStore] createItem];
		
		ItemViewController *ivc = [[ItemViewController alloc] initWithName:YES];
		[ivc setItem:item];
		
		UINavigationController *nvc = [[UINavigationController alloc] 
																	 initWithRootViewController:ivc];
		
		[nvc setModalPresentationStyle:UIModalPresentationFormSheet];
		[nvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
		
		// Pass a block to reload the table to the ItemViewController
		// Need a dismiss block to reload data for the iPad but not for iPhone
		// 13.5 for explanation
		[ivc setDismissBlock: ^{
				[table reloadData];
		}];
		
		[self presentViewController:nvc animated:YES completion:nil];
 

}

// Toggle is Edit button
-(IBAction)toggleMenuItem:(id)sender
{
    //table.editing = YES;

    // Create a toggle for the EDIT/DONE button
    
    // Edit state
    if (table.editing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        // Turn off editing mode
        table.editing = NO;

    }else {
    // Done state
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        table.editing = YES;
    }
     
}

#pragma mark -
#pragma mark UITableView actions

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


#pragma mark -
#pragma mark UITableView datasource

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
		
		[[cell nameLabel] setText:[item itemName]];
		[[cell descriptionLabel] setText:[item descriptions]];		
		[[cell valueLabel] setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
		
		// Create a NSDateFormatter that will turn a date into a simple date string
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateStyle:NSDateFormatterMediumStyle];
		[format setTimeStyle:NSDateFormatterNoStyle];
		
		// Convert from time interval to date for DateLabel
		NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[item dateCreated]];
		[[cell dateLabel] setText:[format stringFromDate:date]];
		
		
		[[cell thumbnailView] setImage:[item thumbnail]];
		
    return cell;
    
		
		// cell.textLabel.text = [item description];
    
    /*
		 else if ([indexPath section] == 1) {
		 [[cell textLabel] setText:@"Hello"];
		 }
     */
    
    /*  Have the last cell named itseld Last Row
		 int rowCount = [[[ItemStore sharedStore] allItems]count];
		 rowCount--;
		 
		 if ([indexPath row] == rowCount) {
		 [[cell textLabel] setText:@"Last Row"];
		 }
		 else {
		 [[cell textLabel] setText: [item itemDescriptions]];
		 }
		 */    
    
    /*
     NSArray *array = [NSArray arrayWithObjects:@"  Hello",@"Jill", nil];
     
     
     // Convert from int to string
     int value = [[itemArray objectAtIndex:[indexPath row]]valueInDollars];
     NSString *stringValue = [NSString stringWithFormat:@"%d",value];
     
     
     // Convert from date to string
     NSDate *date = [[itemArray objectAtIndex:[indexPath row]] dateCreated];
     NSDateFormatter *format = [[NSDateFormatter alloc] init];
     [format setDateFormat:@"mm-dd-yyyy"];
     NSString *dateString = [format stringFromDate:date];
     */
		
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ItemStore sharedStore]allItems]count];
    
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark -
#pragma mark UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
		
		//Retrieve an item from the ItemStore
    Items *item = [[[ItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    ItemViewController *ivc = [[ItemViewController alloc] initWithName:NO];
    
    // Pass the item object to the Items View Controller
    [ivc setItem:item];
    
    [[self navigationController] pushViewController:ivc animated:YES];
		
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


@end


























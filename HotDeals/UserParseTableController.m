//
//  MyTableController.m
//  ParseStarterProject
//
//  Created by Mike Chen on 7/14/12.
//  Copyright (c) 2011 Parse Inc. All rights reserved.
//

#import "UserParseTableController.h"
#import "ItemCell.h"
#import "DealsItemViewController.h"
#import "LocationDataManager.h"
#import "UserPostViewController.h"

@interface UserParseTableController ()

@end

#pragma mark -
@implementation UserParseTableController
@synthesize UserViewBasedOn;
@synthesize userNameOfDeal;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.className = @"TestObject";
        
        // The key of the PFObject to display in the label of the default cell style
				//   self.keyToDisplay = @"text";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 50;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
		
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
    // the IVC edits, will reload the PFobjects in the array objects
		// but it doesn't actually save to Parse backend
	  //	 [self.tableView reloadData];
		
		//	NSLog(@"Parse will appear: DealsBasedon:%@", self.DealBasedOn);
		
		// Clear to prevent previous Parse table caches from appearing
		//	[self clear];
		
		// If you switch tabs back and forth, the parse table will not
		// be up to date so you must reload to make sure the data is right.
		//	[self loadObjects];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
		//	[self.tableView reloadData];
		//	[self loadObjects];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
		
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
		
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
		
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
		
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
		
		//  [query orderByAscending:@"createdAt"];
		
		
		/* If you are in the Deals Tab then return the query for
		random user, else you are in the User Tab and you will
		return the query for the current user */
		
		if ([self.UserViewBasedOn isEqualToString:@"DealTab"]) {
				
				[query orderByDescending:@"createdAt"];
				PFUser *user = self.userNameOfDeal;
				[query whereKey:@"user" equalTo:user];
		}
		
		
		// Return the query for the current user
		else if ([self.UserViewBasedOn isEqualToString:@"UserTab"]) {
		
		// Return a query based on a current Users ID
		//if ([self.DealBasedOn isEqualToString:@"user"]) {
		
		[query orderByDescending:@"createdAt"];
		
		PFUser *user = [PFUser currentUser];
		
		// If user.objectId is nil, then the user hasn't been saved
		// on the Parse server. There will be an exception if you query
		// with a user.objectId that is nil i.e. unsaved
		if (user.objectId) {
				[query whereKey:@"user" equalTo:user];
				//  Multiple contraints on a query
				// [query whereKey:@"name" equalTo:@"second"];
				
				
				
		}
		else {
				// Else user hasn't been saved to the
				// Parse server, return a empty table
				[query whereKey:@"user" equalTo:@""];
		}
				
		}
		
		//	NSLog(@"Outside");
    return query;
}
// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
		//static NSString *CellIdentifier = @"Cell";
		
		/* Parse cell
		 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		 if (cell == nil) {
		 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		 }
		 
		 // Configure the cell
		 cell.textLabel.text = [object objectForKey:@"name"];
		 // cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@", [object objectForKey:@"priority"]];
		 
		 return cell;
		 */
		
		// Cell has been created in ViewDidLoad, so just grab the cell
		ItemCell *cell =
		[tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
		
		/*
		 static NSString *CellIdentifier = @"ItemCell";
		 ItemCell *cell = [tableView
		 dequeueReusableCellWithIdentifier:CellIdentifier];
		 if (cell == nil) {
		 cell = [[ItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		 }*/
		
		[[cell nameLabel] setText:[object objectForKey:@"name"]];
		
		return cell;
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
		
		
		PFObject *object = [self.objects objectAtIndex:[indexPath row]];
		//NSString *hello = [object objectForKey:@"name"];
		//NSLog(@"%@", hello);
		
		
		/* If this UserViewController is inside the Deals Tab Bar Controller
		   then selecting on a table will bring up a DealsItemViewController
		   which cannot not be edited.
		   If this UserViewController is inside the User Tab Bar Controller
		   then it is a user viewing their own post, so you will bring
		   up the UserPostViewController which will allow a user to edit 
		   his own deals.
		*/
		
		
		//??? Clean up later
		// If you are in the Deals Tab, selecting a row will bring up DealsItemViewController
		// If you are in the User Tab, selecting a row will bring up UserPostViewController
		if ([self.UserViewBasedOn isEqualToString:@"DealTab"]) {
				
				DealsItemViewController *dealsItemViewController =
												[[DealsItemViewController alloc] init];
				// Pass the parse object onto to the DealsItemViewController
				[dealsItemViewController setParseObject:object];
				// Pass the username of the deal
				[dealsItemViewController setUserNameOfDeal:self.userNameOfDeal];
				
				// Set dismiss block for didselectrowatindexpath
				// Previous bug, when you select row and then return it crashed
				// you set it for for addnewitem in DVC but you didn't for didselectrow
				// so when IVC viewdisappears, (it'll save and run dismiss block
				// to reload a table
				[dealsItemViewController setDismissBlock: ^{
						
						//    DVC's table
						//		[table reloadData];
						
						//		[ParseTVC.tableView reloadData];
						
						// Load the parse objects after you create a new Parse object
						// Only reload the block if the save was successful.
						[self loadObjects];
				}];
				// ???? Customize the animation of when hiding the toolbar
				dealsItemViewController.hidesBottomBarWhenPushed = YES;
				
				[self.navigationController pushViewController:dealsItemViewController animated:YES];
		}
		
		// You are in the User Tab so allow the user to edit his own deals
		else if ([self.UserViewBasedOn isEqualToString:@"UserTab"]) {
		
		// Pass the parse object onto to the ItemViewController
		// when it is pushed
		// DEL changed DIVC to UPVC for 
		//DealsItemViewController *dealsItemViewController = [[DealsItemViewController alloc] init];
		//[dealsItemViewController setParseObject:object];
		
		UserPostViewController *userPostViewController = [[UserPostViewController alloc] initWithName:NO];
		[userPostViewController setParseObject:object];
		
		// Set dismiss block for didselectrowatindexpath
		// Previous bug, when you select row and then return it crashed
		// you set it for for addnewitem in DVC but you didn't for didselectrow
		// so when IVC viewdisappears, (it'll save and run dismiss block
		// to reload a table
		[userPostViewController setDismissBlock: ^{
				
				//    DVC's table
				//		[table reloadData];
				
				//		[ParseTVC.tableView reloadData];
				
				// Load the parse objects after you create a new Parse object
				// Only reload the block if the save was successful.
				[self loadObjects];
				
				// Notify the DealViewController parse table to reload
				// because a post may have been changed
				dispatch_async(dispatch_get_main_queue(), ^{
						[[NSNotificationCenter defaultCenter]
						 postNotificationName:@"userDealChange" object:nil];
				});
		}];

		// ???? Customize the animation of when hiding the toolbar
    userPostViewController.hidesBottomBarWhenPushed = YES;
		
		[self.navigationController pushViewController:userPostViewController animated:YES];
		
		
		}
		
}

// For editing / deleting from Parse Table
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		
		if (editingStyle == UITableViewCellEditingStyleDelete) {
				PFObject *object = [self.objects objectAtIndex:[indexPath row]];
				[object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
						
						if (error) {
								return;
						}
						
						//  Reload the Parse Table, this function relaces
						// [tableView deleteRowsAtIndexPaths:withRowAnimation]
						[self loadObjects];
						
						// Alert the DealsParseTableController to reload because a deal was deleted
						dispatch_async(dispatch_get_main_queue(), ^{
								[[NSNotificationCenter defaultCenter]
								 postNotificationName:@"userDealChange" object:nil];
						});
				}];
				
				
				// This causes a error with rows not matching up
				//	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
				
				
		}
}




@end





















//
//  MyTableController.m
//  ParseStarterProject
//
//  Created by Mike Chen on 7/14/12.
//  Copyright (c) 2011 Parse Inc. All rights reserved.
//

#import "DealsParseTableController.h"
#import "ItemCell.h"
#import "DealsItemViewController.h"
#import "LocationDataManager.h"
#import "ImageStore.h"

@interface DealsParseTableController ()
@end

#pragma mark -
@implementation DealsParseTableController

@synthesize DealBasedOn;

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
		
		// Register to be notified when the location data is ready.
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentLocationReady) name:@"currentLocationReady" object:nil];
		
		// Register to be notified when the user has supplied a address
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressLocationReady) name:@"addressLocationReady" object:nil];
		
		// Register to be notified when a user has added a new deal to his locality
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector
		 (userDealChange) name:@"userDealChange" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
		
		[[NSNotificationCenter defaultCenter] removeObserver:self
																										name:@"currentLocationReady" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self
																										name:@"addressLocationReady" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self
																										name:@"userDealChange" object:nil];
		
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
		//[self clear];
		
		// If you switch tabs back and forth, the parse table will not
		// be up to date so you must reload to make sure the data is right.
		// [self loadObjects];
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
		[[NSNotificationCenter defaultCenter] removeObserver:self
																										name:@"currentLocationReady" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self
																										name:@"addressLocationReady" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self
																										name:@"userDealChange" object:nil];
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
		
		
		
		// Return a query based upon a current locality of current user
		if ([self.DealBasedOn isEqualToString:@"currentLocation"]) {
				
				// Pull the location data from LocationDataManager
				NSString *usersCurrentLocality =
				[LocationDataManager sharedLocation].currentPlacemark.locality;
				
				// Check to see if locality is ready, if not return a empty table
				if (usersCurrentLocality) {
						NSLog(@"Current locality ready, query parse");
						[query orderByDescending:@"createdAt"];
						[query whereKey:@"locality" equalTo:usersCurrentLocality];
				} else {
						NSLog(@"Current locality not ready, query empty parse");
						[query whereKey:@"locality" equalTo:@""];
				}
		}
		
		// Return query based upon an address that the user entered
		else if ([self.DealBasedOn isEqualToString:@"userEnteredAddress"]) {
				
				NSString *userEnteredLocality =
				[LocationDataManager sharedLocation].addressPlacemark.locality;
				if (userEnteredLocality) {
						NSLog(@"Address locality ready, query parse");
						[query orderByDescending:@"createdAt"];
						[query whereKey:@"locality" equalTo:userEnteredLocality];
				} else {
						NSLog(@"Address locality not ready, query empty parse");
						[query whereKey:@"locality" equalTo:@""];
				}
				
		}
		
		//	NSLog(@"Outside");
		NSLog(@"DealsBasedon --->>>> %@", self.DealBasedOn);
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
		
		//[[cell nameLabel] setText:[object objectForKey:@"name"]];
		[[cell descriptionLabel] setText:[object objectForKey:@"description"]];
		 
		
		// Set the image
		NSString *imageKey = [object objectForKey:@"imageKey"];
		if (imageKey) {
				
				[[cell descriptionLabel] setText:[object objectForKey:@"description"]];
				
				// Set the thumbnail image
				PFFile *thumbnailFile = [object objectForKey:@"thumbImage"];
				NSData *imageData = [thumbnailFile getData];
				UIImage *thumbnailImage = [UIImage imageWithData:imageData];
				[[cell thumbnailView] setImage:thumbnailImage];
		}
		else {
				[[cell thumbnailView] setImage:nil];
		}
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
		return 80;
}


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
		
		/* DEL
		 NSString *hello = [object objectForKey:@"name"];
		 NSLog(@"%@", hello);
		 */
		
		PFObject *object = [self.objects objectAtIndex:[indexPath row]];
		
		DealsItemViewController *dealsItemViewController = [[DealsItemViewController alloc] init];
		
		// Pass the parse object onto to the DealsItemViewController
		[dealsItemViewController setParseObject:object];
		
		// Retrieve the id i.e. the user who created the deal
		// and pass it to dealsIteViewController
		PFUser *userNameOfDeal = [object objectForKey:@"user"];
		[dealsItemViewController setUserNameOfDeal:userNameOfDeal];
		
		
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

// For editing / deleting from Parse Table
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		
		if (editingStyle == UITableViewCellEditingStyleDelete) {
				PFObject *object = [self.objects objectAtIndex:[indexPath row]];
				[object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
						
						//  Reload the Parse Table, this function relaces
						// [tableView deleteRowsAtIndexPaths:withRowAnimation]
						[self loadObjects];
				}];
				
				
				// This causes a error with rows not matching up
				//	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
				
				
		}
}

#pragma mark - NSNotificationCenter notification handlers

- (void)currentLocationReady {
		
		// Query the parse server again now that location data is available
		NSLog(@"Notification recieved, update table on current location");
		self.DealBasedOn = @"currentLocation";
		[self loadObjects];
}

- (void)addressLocationReady {
		NSLog(@"Notification recieved, update on user address");
		self.DealBasedOn = @"userEnteredAddress";
		[self loadObjects];
}

- (void)userDealChange {
		
		// Reload the table because a user has added a new deal,
		// deleted a deal, or changed a deal.
		[self loadObjects];
}


@end





















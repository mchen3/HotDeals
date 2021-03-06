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
#import "ImageStore.h"
#import <QuartzCore/QuartzCore.h>
#import "CreateDealViewController.h"

@interface UserParseTableController ()
@end

#pragma mark -
@implementation UserParseTableController
@synthesize UserViewBasedOn;
@synthesize userNameOfDeal;
@synthesize parseImageReturned;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.className = @"Posts";
        
        // The key of the PFObject to display in the label of the default cell style
				//   self.keyToDisplay = @"text";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        self.objectsPerPage = 5;
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
		
		//[self loadObjects];
		//[self.tableView reloadData];
		
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

#pragma mark - PFQueryTableViewController methods

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
		return query;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {

		// Cell has been created in ViewDidLoad, so just grab the cell
		ItemCell *cell =
		[tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
		
		// Set the description
		/* Retrieve the description string from Parse
		 If the description text is greater than 70 characters than we will cut it short */
		NSString *parseDescriptionString = [object objectForKey:@"description"];
		NSMutableString *descriptionString = [parseDescriptionString copy];
		int descriptionLength = parseDescriptionString.length;
		int maxCharacters = 70;
		int charactersToSubstract = descriptionLength - maxCharacters;
		if (charactersToSubstract > 0) {
				NSString *newDescriptionString = [descriptionString
																					substringToIndex:descriptionLength -charactersToSubstract];
				NSMutableString *copyString = [newDescriptionString copy];
				NSString *finalDescriptString = [NSString stringWithFormat:@"%@...",copyString];
				[[cell descriptionLabel] setText:finalDescriptString];
		}
		else {
				[[cell descriptionLabel] setText:[object objectForKey:@"description"]];
		}
		// Push the description text to the left upper edge, ie, elimate the padding view
		[cell descriptionLabel].contentInset = UIEdgeInsetsMake(-8,-8,0,0);
		
		// Set the price
		[[cell dollarLabel] setText:@"$"];
		[[cell priceLabel] setText:[object objectForKey:@"price"]];
		
		// Set the date
		// Show the date the deal was created
		NSDate *dateData = object.createdAt;
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"MM-dd-yyyy"];
		NSString *dateString = [formatter  stringFromDate:dateData];
		[[cell dateLabel] setFont:[UIFont
															 fontWithName:@"Arial Rounded MT Bold" size:10.0]];
		[[cell dateLabel] setTextColor:[UIColor grayColor]];
		[[cell dateLabel] setText:dateString];
		
		// Set the thumbnail image
		NSString *imageKey = [object objectForKey:@"imageKey"];
		if (imageKey) {
				// Set the thumbnail image
				/* We will LazyLoad the thumbnail images- meaning we will load the images
				 asynchronously so the table will be more responsive i.e. the table will
				 not delay if the images are not ready. Parse allows you to set the PFTableViewCell's
				 property value PFImageView imageView and all you had to do was set the
				 cell.imageView.file and the "loadInBackground" and "setImage" was done for you.
				 I used my own TableCell implementation cell.thumbnailView which loaded the thumb images
				 faster and I wrote out loadInBackground and setImage so I can see clearly how the
				 thumbnnail image are being set.
				 */
				PFFile *thumbnailFile = [object objectForKey:@"thumbImage"];
				cell.thumbnailView.image = [UIImage imageNamed:@"placeholderimage.png"];
				cell.thumbnailView.file = thumbnailFile;
				[[cell thumbnailView] loadInBackground:^(UIImage *image, NSError *error) {
						//Parse automically sets the image
						//[[cell thumbnailView] setImage:image];
				}];
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
		
		PFObject *object = [self.objects objectAtIndex:[indexPath row]];

		/* If this UserViewController is inside the Deals Tab Bar Controller
		 then selecting on a table will bring up a DealsItemViewController
		 which cannot not be edited.
		 If this UserViewController is inside the User Tab Bar Controller
		 then it is a user viewing their own post, so you will bring
		 up the UserPostViewController which will allow a user to edit
		 his own deals.
		 */
				
		// In the Deals Tab, selecting a row will bring up DealsItemViewController
		// and in the User Tab, selecting a row will bring up UserPostViewController
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
						// Load the parse objects after you create a new Parse object
						[self loadObjects];
				}];
				dealsItemViewController.hidesBottomBarWhenPushed = YES;				
				[self.navigationController pushViewController:dealsItemViewController animated:YES];
		}
		
		// You are in the User Tab so allow the user to edit his own deals
		else if ([self.UserViewBasedOn isEqualToString:@"UserTab"]) {

				UserPostViewController *userPostViewController =
												[[UserPostViewController alloc] initWithName:NO];
				[userPostViewController setParseObject:object];
				
				// Customize to present the modal view from right to left
				CATransition *transition = [CATransition animation];
				transition.duration = 0.30;
				transition.timingFunction =
				[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
				transition.type = kCATransitionMoveIn;
				transition.subtype = kCATransitionFromRight;
				UIView *containerView = self.view.window;
				[containerView.layer addAnimation:transition forKey:nil];
				
				// Create a nav controller so userPostViewController can add nav items to return
				UINavigationController *userPostNavController = [[UINavigationController alloc] initWithRootViewController:userPostViewController];
				
				CreateDealViewController *createDealViewController =
												[[CreateDealViewController alloc] init];
				UINavigationController *createDealNavController = [[UINavigationController alloc] initWithRootViewController:createDealViewController];
		
				// Pass the object, image, and reloadUserTable block to CDVC
				[createDealViewController setParseObject:object];
				
				// Set the image
				NSString *imageKey = [object objectForKey:@"imageKey"];
				/* We want to set the image for CreateDealViewController but do it asynchronously.
				We are presentingly UserPostViewController on top of CreateDealViewController so
				 since they are both presented at the same time we need to leave the ImageStore 
				 free for UPVC to use. The best way is just to query the photo object ourselves
				 and use PFFile getData (instead of PFImageView) method to retrive the PFFile */
				
				PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
				[query whereKey:@"imageKey" equalTo:imageKey];
				[query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
						PFFile *parseFile = [object objectForKey:@"image"];
						NSData *imageData = [parseFile getData];
						parseImageReturned = [UIImage imageWithData:imageData];
						[createDealViewController setImage:parseImageReturned];
				}];
				
				[createDealViewController setReloadUserTableBlock:^{
						[self loadObjects];
				}];
				
				// Present a modal view, createDealNavController, with another modal
				// view, userPostNavController on top of it already
				[self presentViewController:createDealNavController animated:NO completion:^{
						[createDealViewController presentViewController:userPostNavController
																									 animated:NO completion:nil];
				}];
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





















//
//  CategoryPicker.m
//  DealMaker1
//
//  Created by Mike Chen on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryPicker.h"
#import "ItemStore.h"
#import "Items.h"

@implementation CategoryPicker
@synthesize item;

-(id)init
{
		return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
		return [super init];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
		return [[[ItemStore sharedStore] allCategories] count];
}


// Core Data - Category Types 16.12
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
		
		// Different from DealViewController, don't used the created nib ItemCell
		UITableViewCell *cell = [tableView 
														 dequeueReusableCellWithIdentifier:@"UITableViewCell"];
		if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
																reuseIdentifier:@"UITableViewCell"];
		}
		
		// Retrieve the category types (of type NSManagedObject)
		// from the allCategories array
		NSManagedObject *categoryType = [[[ItemStore sharedStore] 
																allCategories] objectAtIndex:[indexPath row]];
		
		// Use key-value codinf to get the category type's label
		NSString *categoryLabel = [categoryType valueForKey:@"label"];
		[[cell textLabel] setText:categoryLabel];
		
		// Checkmark the one that is currently labeled
		if (categoryType == [item category]) {
				[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		} else {
				[cell setAccessoryType:UITableViewCellAccessoryNone];
		}
		return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
		// Checkmark the cell that was selected
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		
		
		// Set the Items category to the one that is selected
		NSManagedObject *categoryType = [[[ItemStore sharedStore] allCategories] 
																			objectAtIndex:[indexPath row]];
		[item setCategory:categoryType];
		[[self navigationController] popViewControllerAnimated:YES];
		
}


@end






























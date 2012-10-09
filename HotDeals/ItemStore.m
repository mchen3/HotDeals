//
//  ItemStore.m
//  DealMaker1
//
//  Created by Mike Chen on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemStore.h"
#import "Items.h"
#import "ImageStore.h"


@implementation ItemStore


+(id)allocWithZone:(NSZone *)zone {
    return [self sharedStore];
}

// Create a singleton, ie only one object of ItemStore
+(ItemStore *)sharedStore
{
    // Static variable declared only once, nil
    // well not be assigned again
    static ItemStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

-(id)init 
{
    self = [super init];
    if (self) {
				
				/*
				// Unarchive the data
				NSString *path = [self itemArchivePath];
				allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
				
				if (!allItems) {
						allItems = [[NSMutableArray alloc] init];
				}
				*/
				
				// Core Data
				
				// Read in DealMaker.xcdatamodeld
				model = [NSManagedObjectModel mergedModelFromBundles:nil];
				
				NSPersistentStoreCoordinator *psc =
						[[NSPersistentStoreCoordinator alloc] 
										initWithManagedObjectModel:model];
				
				//Where does the SQLite file go?
				NSString *path = [self itemArchivePath];
				NSURL *storeURL = [NSURL fileURLWithPath:path];
				NSError *error = nil;
				if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
								URL:storeURL options:nil error:&error])
				{
						[NSException raise:@"Open failed" format:@"Reason: %@",
								[error localizedDescription]];
				}
				
				// Create the managed object context
				context = [[NSManagedObjectContext alloc] init];
				[context setPersistentStoreCoordinator:psc];
				
				//The managed object context can manage undo, but we don't need it
				[context setUndoManager:nil];
				
				// Load the items from CoreData
				[self loadAllItems];
				
							
    }
    return self;
}

-(NSArray *)allItems {
    return allItems;
}

-(Items *)createItem
{
   // Items *randomItem = [Items randomItem];
   // Items *randomItem = [[Items alloc] init];
		
		// Core Data
		 
		 
		double order;
		if ([allItems count] == 0) {
				order = 1.0;
		} else {
				order = [[allItems lastObject] orderingValue] + 1.0;
		}
		NSLog(@"Adding after %d items, order = %.2f", [allItems count], order);
		
		
		// NSEntityDescription:Insert will create and insert a new Items object
		// into CoreData and it will return the Items object to you.
		Items *item = [NSEntityDescription 
									insertNewObjectForEntityForName:@"Items"
									inManagedObjectContext:context];
		
    [allItems addObject:item];
    return item;
		
		
		
		/*
		// Parse
		PFObject *item = [PFObject objectWithClassName:@"Items"];
		[item saveInBackground];

		PFQuery *query = [PFQuery queryWithClassName:@"Items"];
			*/							 
}

-(void)removeItems:(Items *)item
{
		
		// Remove the image from the Image store
		NSString *imageKey = [item imageKey];
		[[ImageStore defaultImageStore] deleteImageForKey:imageKey];
		
		// Remove item from the database
		[context deleteObject:item];
		
		// Remove the item from the array storing all the items
		[allItems removeObjectIdenticalTo:item];

}


// Move the item from one row to another
-(void)moveItemAtIndex:(int)from 
              toIndex :(int)to
{
    if (from == to) {
        return;
    }
    
    // Get a pointer to the item before we remove it
    Items *item = [allItems objectAtIndex:from];
    [allItems removeObjectAtIndex:from];
    
    // Insert the item at the new index
    [allItems insertObject:item atIndex:to];
		
		// CoreData 16.12
		// A ordering value is used to keep track of positions in CoreData
		// We use the value as a double to make it easier to place
		// a item between two items postion, in which we we add the
		// before and after positions and divide by 2
		double lowerBound = 0.0;
		
		// Is there an object before it in the array
		if (to > 0) {
				lowerBound = [[allItems objectAtIndex:to - 1] orderingValue];
		} else {
				lowerBound = [[allItems objectAtIndex:1] orderingValue] - 2.0;
		}
		
		double upperBound = 0.0;
		// Is there an object after it in the array
		if (to < [allItems count] - 1) {
				upperBound = [[allItems objectAtIndex:to + 1] orderingValue];
		} else {
				upperBound = [[allItems objectAtIndex:to -1] orderingValue] + 2.0;
		}
		
		double newOrderValue = (lowerBound + upperBound) / 2.0;
		NSLog(@"moving to order %f", newOrderValue);
		[item setOrderingValue:newOrderValue];
}

- (NSArray *)allCategories 
{
		// If there are no categories, fetch the cateogry from the database
		if (!allCategories) {
				
				NSFetchRequest *request = [[NSFetchRequest alloc] init];
				NSEntityDescription *e = [[model entitiesByName] objectForKey:@"Category"];
				[request setEntity:e];
				NSError *error;
				NSArray *result = [context executeFetchRequest:request error:&error];
				
				if (!result) {
						[NSException raise:@"Fetch failed" format:@"Reason: %@", 
						 [error localizedDescription]];
				}
				// Put the array inside array "allCategories"
				allCategories = [result mutableCopy];
		}
		// Is this the first time the program is being run?
		// Then create three categories by default
		if ([allCategories count] == 0) {
				// Category is of type NSManagedObject, check 
				// DealMaker.xcdatamodelLd for the class type
				// Items is of type Items
				
				// When you NSEntityDescription:insertNewObject into the database, it
				// returns a object of type NSManagedObject
				NSManagedObject *type;
				type = [NSEntityDescription insertNewObjectForEntityForName:@"Category" 
																						 inManagedObjectContext:context];
				[type setValue:@"Drinks" forKey:@"label"];
				[allCategories addObject:type];
				
				type = [NSEntityDescription insertNewObjectForEntityForName:@"Category" 
																						 inManagedObjectContext:context];
				[type setValue:@"Food" forKey:@"label"];
				[allCategories addObject:type];
				
				type = [NSEntityDescription insertNewObjectForEntityForName:@"Category" 
																						 inManagedObjectContext:context];
				[type setValue:@"Restuarants" forKey:@"label"];
				[allCategories addObject:type];
		}
		return allCategories;
}

#pragma mark -
#pragma mark CoreData
// Chapter 14

- (NSString *)itemArchivePath 
{
		
		NSArray *documentDirectories = 
				NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
																						NSUserDomainMask, YES);
		// Get one and only document directory from the list
		NSString *documentDirectory = [documentDirectories objectAtIndex:0];
		
	// Archive	
	//	return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
		
		return [documentDirectory
						stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges 
{
		/*
		//returns success of failure
		NSString *path = [self itemArchivePath];
		return [NSKeyedArchiver archiveRootObject:allItems
																			 toFile:path];
		*/
		
		NSError *err = nil;
		BOOL successful = [context save:&err];
		if (!successful) {
				NSLog(@"Error saving: %@", [err localizedDescription]);
		}
		return successful;
}


// Fetch all the Items in store.data 
// and save the results to allItems array
- (void)loadAllItems
{
		if (!allItems) {
				NSFetchRequest *request = [[NSFetchRequest alloc] init];
				NSEntityDescription *e = [[model entitiesByName] objectForKey:@"Items"];
				[request setEntity:e];
				
				NSSortDescriptor *sd = [NSSortDescriptor 
																sortDescriptorWithKey:@"orderingValue" 
																ascending:YES];
				[request setSortDescriptors:[NSArray arrayWithObject:sd]];
				NSError *error;
				NSArray *result = [context executeFetchRequest:request error:&error];
				
				if (!result) {
						[NSException raise:@"Fetch failed" format:@"Reason: %@", 
						 [error localizedDescription]];
				}
				allItems = [[NSMutableArray alloc] initWithArray:result];
		}
}




@end
  
  
  
  
  
  
  
  
  
  
  
  
  
  

//
//  ItemStore.h
//  DealMaker1
//
//  Created by Mike Chen on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class Items;
@interface ItemStore : NSObject 

{
    NSMutableArray *allItems;
		
		NSMutableArray *allCategories;
		NSManagedObjectContext *context;
		NSManagedObjectModel *model;
}

+(ItemStore *)sharedStore;

-(NSArray *)allItems;
-(Items *)createItem;
-(void)removeItems:(Items *)item;

-(void)moveItemAtIndex:(int)from 
               toIndex:(int)to;
- (NSString *)itemArchivePath;
- (BOOL)saveChanges;

- (NSArray *) allCategories;
- (void)loadAllItems;



@end

//
//  DealViewController.h
//  DealMaker1
//
//  Created by Mike Chen on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MyTableController.h"

@interface DealViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *itemArray;
   __weak IBOutlet UITableView *table;
		
}
 

-(IBAction)addNewItem:(id)sender;
-(IBAction)toggleMenuItem:(id)sender;


@end

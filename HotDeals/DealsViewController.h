//
//  DealViewController.h
//  DealMaker1
//
//  Created by Mike Chen on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DealsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *itemArray;
		__weak IBOutlet UITableView *table;
		__weak IBOutlet UITextField *addressField;
		__weak IBOutlet UILabel *placeMark;
		
}

- (IBAction)backgroundTouched:(id)sender;
- (IBAction)dealsBasedOnAddress:(id)sender;
- (IBAction)dealsBasedOnUserLocation:(id)sender;



@end

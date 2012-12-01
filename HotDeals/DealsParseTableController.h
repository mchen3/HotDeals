//
//  MyTableController.h
//  ParseStarterProject
//
//  Created by Mike Chen on 12/29/11.
//  Copyright (c) 2011 Parse Inc. All rights reserved.
//

#import <Parse/Parse.h>

@interface DealsParseTableController : PFQueryTableViewController
{
		NSString *DealBasedOn;
}
@property (nonatomic, readwrite) NSString *DealBasedOn;

@end

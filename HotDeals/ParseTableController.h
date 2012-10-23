//
//  MyTableController.h
//  ParseStarterProject
//
//  Created by James Yu on 12/29/11.
//  Copyright (c) 2011 Parse Inc. All rights reserved.
//

#import <Parse/Parse.h>

@interface ParseTableController : PFQueryTableViewController
{
		NSString *DealBasedOn;
}


@property (nonatomic, copy) void (^reloadTableBlock)(void);
@property (nonatomic, readwrite) NSString *DealBasedOn;

@end

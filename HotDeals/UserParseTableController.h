
//
//  MyTableController.h
//  ParseStarterProject
//
//  Created by Mike Chen on 12/29/11.
//  Copyright (c) 2011 Parse Inc. All rights reserved.
//

#import <Parse/Parse.h>
@interface UserParseTableController  : PFQueryTableViewController

@property (nonatomic, readwrite) NSString *UserViewBasedOn;
@property (nonatomic, strong) PFUser *userNameOfDeal;
@property (nonatomic, strong) UIImage *parseImageReturned;

@end

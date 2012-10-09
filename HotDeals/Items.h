//
//  Items.h
//  DealMaker1
//
//  Created by Mike Chen on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Items : NSManagedObject

@property (nonatomic) NSTimeInterval dateCreated;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSString * imageKey;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic) int32_t valueInDollars;
@property (nonatomic) double orderingValue;
@property (nonatomic, retain) NSManagedObject *category;

-(void)setThumbnailDataFromImage:(UIImage *)image;

@end

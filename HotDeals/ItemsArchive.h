//
//  Items.h
//  DealMaker1
//
//  Created by Mike Chen on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Items : NSObject <NSCoding>
{
    NSString *itemName;
    NSString *descriptions;
    int valueInDollars;
    NSDate *dateCreated;
    NSString *imageKey;
    
		UIImage *thumbnail;
		NSData *thumbnailData;
}

-(NSString *)itemDescriptions;
- (id)initWithItemName:(NSString *)name
           description:(NSString *)descript
        valueInDollars:(int)value;
+(id)randomItem;

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *descriptions;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;
@property (nonatomic, copy) NSString *imageKey;

@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSData *thumbnailData;

-(void)setThumbnailDataFromImage:(UIImage *)image;


@end











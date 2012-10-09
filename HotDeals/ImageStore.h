//
//  ImageStore.h
//  DealMaker1
//
//  Created by Mike Chen on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface ImageStore : NSObject 
{
    NSMutableDictionary *dictionary;
		
		UIImage *parseImage;
		
}
+ (ImageStore *)defaultImageStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;


- (void)deleteImageForKey:(NSString *)key;

- (NSString *)imagePathForKey:(NSString *)key;

@property (nonatomic, copy) void (^reloadBlock)(void);
@property (nonatomic, retain) NSString * imageKey;


@end









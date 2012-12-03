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
}
+ (ImageStore *)defaultImageStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (PFFile *)getThumbnailFileFromImage:(UIImage *)image;
- (void)deleteImageForKey:(NSString *)key;

@property (nonatomic, copy) void (^reloadBlock)(void);
@property (nonatomic, retain) NSString * imageKey;
@property (nonatomic, strong) UIImage *parseImageReturned;
@property (nonatomic, strong) PFImageView *lazyLoadPFImageView;

@end









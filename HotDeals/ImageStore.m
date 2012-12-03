//
//  ImageStore.m
//  DealMaker1
//
//  Created by Mike Chen on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageStore.h"

@implementation ImageStore
@synthesize reloadBlock;
@synthesize imageKey;
@synthesize parseImageReturned;
@synthesize lazyLoadPFImageView;

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultImageStore];
}
								
// Create a singleton     
+ (ImageStore *)defaultImageStore
{
    static ImageStore *defaultImageStore = nil;
		if (!defaultImageStore) {
				defaultImageStore = [[super allocWithZone:NULL] init];
		}
		return defaultImageStore;
}

- (id)init {
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
				
				// Register for low memory warning so you can clear the cache
				NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
				[nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

// Clear cache when you recieve the low memory warning
-(void)clearCache:(NSNotification *)note;
{		
		[dictionary removeAllObjects];
}

#pragma mark - Image methods

-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
		// Save our image to the Parse servers, while associating it 
		// with the key that is passed through with this image
		
		// Save the image to a temporary storage 
		[dictionary setObject:image forKey:key];
		
		// Save the image to Parse
		NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
		PFFile *imageFile = [PFFile fileWithName:@"Parse.jpg" data:imageData];
		
		// Save PFFile without waiting
		[imageFile save];
		
		// We will save a image in a separate "Photos" table on parse
		// instead of the main table, "Posts"
		PFObject *userPhoto = [PFObject objectWithClassName:@"Photos"];
		[userPhoto setObject:imageFile forKey:@"image"];
		[userPhoto setObject:key forKey:@"imageKey"];
		[userPhoto setObject:[PFUser currentUser] forKey:@"user"];
		[userPhoto saveInBackground];		
}

-(UIImage *)imageForKey:(NSString *) key
{
		/*
		This method can return back an image when you pass a key.
		 
		But it can also be used to asynchronously load a remote image to set a
		PFImage, which we have our property as lazyLoadPFImageView.
		We use this in DealsItemViewController and UserPostViewController which
		both have a large PFImage that we want to lazy load / asynchronous load.
		So in both classes their viewwillappear will call
		 [[ImageStore defaultImageStore] setLazyLoadPFImageView:imageView];
		 [[ImageStore defaultImageStore] imageForKey:imageKey];
		*/
		 
		// Check to see if the image is available on our temporary dictionary
		// storage to save us the trouble of loading from the Parse servers
		parseImageReturned = [dictionary objectForKey:key];
		
		if (!parseImageReturned) {
				// Image is not available, must need connection to Parse servers.
				PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
				[query whereKey:@"imageKey" equalTo:key];
				
				// Get the object from Parse servers
				[query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
						// Use PFImageView which will load and set the our image
						if (!error) {
								PFFile *parseFile = [object objectForKey:@"image"];
								self.lazyLoadPFImageView.file = parseFile;
								[self.lazyLoadPFImageView loadInBackground:^(UIImage *image, NSError *error) {
										
										// Cache the image in our dictionary
										if (image) {
												[dictionary setObject:image forKey:key];
										}
								}];
						}
				 }];
		}
		else {
		    // We have a image in our dictionary
				[self.lazyLoadPFImageView setImage:parseImageReturned];
		}
		return parseImageReturned;
}

-(void)deleteImageForKey:(NSString *)key 
{
    if (!key) {
        return;
    }
		[dictionary removeObjectForKey:key];
		
		// Delete the image from the parse servers
		PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
		[query whereKey:@"imageKey" equalTo:key];
		PFObject *object = [query getFirstObject];
		[object delete];
}

#pragma mark - Resize Image to thumbnail

// Takes a full size image and resizes it to a thumb 
// image and returns a PFFile associated with it
- (PFFile *)getThumbnailFileFromImage:(UIImage *)image
{
		CGSize origImageSize = [image size];
		
		// The rectangle of the thumbnail
		//CGRect newRect = CGRectMake(0, 0, 80, 70);
		CGRect newRect = CGRectMake(0, 0, 160, 140);
		
		// Figure out the scaling ratio to make sure we maintain the same aspect ratio
		float ratio = MAX(newRect.size.width / origImageSize.width,
											newRect.size.height / origImageSize.height);
		
		// Create a transparent bitmap context with a scaling factor
		// equal to that of the screen
		UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
		
		//Create a path that is a rounded rectangle
		UIBezierPath *path = [UIBezierPath
													bezierPathWithRoundedRect:newRect cornerRadius:5.0];
		
		// Make all subsequent drawing clip to this rounded rectangle
		[path addClip];
		
		// Center the image in the thumbnail rectangle
		CGRect projectRect;
		projectRect.size.width = ratio * origImageSize.width;
		projectRect.size.height = ratio * origImageSize.height;
		projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
		projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
		
		// Draw the image on it
		[image drawInRect:projectRect];
		
		// Get the image from the image context, keep it as our thumbnail
		UIImage *thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
		
		// Cleanup image context resources, we're done
		UIGraphicsEndImageContext();
		
		// Reformat the image and associate it with a PFFile
		NSData *thumbnailData = UIImageJPEGRepresentation(thumbnailImage, 0.05f);
		PFFile *thumbnailFile = [PFFile fileWithName:@"thumb.jpg" data:thumbnailData];
		[thumbnailFile save];
		
		return thumbnailFile;
}
@end


























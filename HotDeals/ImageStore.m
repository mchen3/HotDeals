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


-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
		
		// Save the image to a temporary storage 
		[dictionary setObject:image forKey:key];
		
		
		// Upload the image with key to Parse Servers for permanent storage
		/*
		UIGraphicsBeginImageContext(CGSizeMake(640, 960));
		[image drawInRect:CGRectMake(0, 0, 640, 960)];
		UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		*/

		// Parse
		NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
		PFFile *imageFile = [PFFile fileWithName:@"Parse.jpg" data:imageData];
		
		// Save without waiting
		[imageFile save];
		
		PFObject *userPhoto = [PFObject objectWithClassName:@"Photos"];
		[userPhoto setObject:imageFile forKey:@"image"];
		[userPhoto setObject:key forKey:@"imageKey"];
		[userPhoto setObject:[PFUser currentUser] forKey:@"user"];
		
		[userPhoto saveInBackground];
		
		
		
		
		/*
		// Save PFFile
		[imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
				if (!error) {
						
						// Create a PFObject around a PFFile and associate it with the current user
						PFObject *userPhoto = [PFObject objectWithClassName:@"Photos"];
						[userPhoto setObject:imageFile forKey:@"image"];
						[userPhoto setObject:key forKey:@"imageKey"];
						[userPhoto setObject:[PFUser currentUser] forKey:@"user"];
						
						// Set the access control list to current user for security reasons
						//userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
					//	userPhoto.ACL = [PFACL ACLWithUser:user];

						//PFUser *user1 = [PFUser currentUser];
						//[userPhoto setObject:user forKey:@"user"];
						
						[userPhoto save];
				}
		}];
		*/
		
		
		//  [dictionary setObject:image forKey:key];
		
		/* BNR
		/* Writing to the FileSystem with NSData
		// Save the image through a binary write to the file system
		// Create full path for image
		NSString *path = [self imagePathForKey:key];
		
		// Turn image into JPEG data
		NSData *d = UIImageJPEGRepresentation(image, 0.5);
		
		// Write to full path
		[d writeToFile:path atomically:YES];
		*/
}

-(UIImage *)imageForKey:(NSString *) key
{
		
		// Check to see if the image is available on our temporary storage
		// to save us the trouble of loading from the Parse servers
		UIImage *image = [dictionary objectForKey:key];
		
		//UIImage *image = nil;
		if (!image) {
		// Image is not available, must need connection to Parse servers.

		PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
		
		[query whereKey:@"imageKey" equalTo:key];
		
		PFObject *object = [query getFirstObject];
		PFFile *parseFile = [object objectForKey:@"image"];
		NSData *imageData = [parseFile getData];
		image = [UIImage imageWithData:imageData];
				
		
		
		/*
		[query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
				if (!object) {
						//
				} else {
						PFFile *parseFile = [object objectForKey:@"image"];
						NSData *imageData = [parseFile getData];
						parseImage = [UIImage imageWithData:imageData];
						
				//		dispatch_async(dispatch_get_main_queue(), reloadBlock);

				}
		}];
		*/

		//return parseImage;
				
				if (image) {
						[dictionary setObject:image forKey:key];
				}
				else {
						NSLog(@"No image available from parse");
				}
				
		}
		
		return image;
				
		
		
		/* BNR
     //return [dictionary objectForKey:key];
		
		// If possible, retrive the image from the dictionary
		UIImage *image = [dictionary objectForKey:key];
		
		if (!image) {
				// Create a image from the file system
				image = [UIImage imageWithContentsOfFile:[self imagePathForKey:key]];	
				if (image) {
						[dictionary setObject:image forKey:key];
				}
				else {
						NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
				}
		}		
		return  image;
		*/
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
		
		
		/*
    [dictionary removeObjectForKey:key];
		
		// Delete the image from the file system
		NSString *path = [self imagePathForKey:key];
		[[NSFileManager defaultManager] removeItemAtPath:path
																							 error:NULL];
		*/
}

-(void)uploadImage:(NSData *)imageData {
		
		// Save PFFile onto Parse servers
		PFFile *imageFile = [PFFile fileWithName:@"Image1.jpg" data:imageData];
		
		[imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
				if (!error) {
						// Create a PFObject around a PFFile and associate it with the current user
						//	PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
						//	[userPhoto setObject:imageFile forKey:@"imageFile"];
						
						// Set the access control list to current user for security reasons
						//	userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
						
						//	PFUser *user = [PFUser currentUser];
						//	[userPhoto setObject:user forKey:@"user"];
						
						//	[userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
						
						//}];
						
						
						PFObject *saveImage = [PFObject objectWithClassName:@"TestObject"];
						//	[jobApplication setObject:@"Joe Smith" forKey:@"applicantName"];
						[saveImage setObject:imageFile         forKey:@"image"];
						[saveImage saveInBackground];
						
						
						PFObject *test = [PFObject objectWithClassName:@"TestObject"];
						[test setObject:@"re" forKey:@"java"];
						[test save];
						
				}
		}];
		
}

    
- (NSString *)imagePathForKey:(NSString *)key
{
		NSArray *documentDirectories =
				NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
																						NSUserDomainMask, YES);
		NSString *documentDirectory = [documentDirectories objectAtIndex:0];
		
		return [documentDirectory stringByAppendingPathComponent:key];
}




@end


























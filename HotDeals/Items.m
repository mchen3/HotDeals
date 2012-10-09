//
//  Items.m
//  DealMaker1
//
//  Created by Mike Chen on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Items.h"


@implementation Items

@dynamic dateCreated;
@dynamic descriptions;
@dynamic imageKey;
@dynamic itemName;
@dynamic thumbnail;
@dynamic thumbnailData;
@dynamic valueInDollars;
@dynamic orderingValue;
@dynamic category;


#pragma mark
#pragma mark Core Data


// After the Core Data loads all the data
-(void)awakeFromFetch 
{
		[super awakeFromFetch];
		
		UIImage *image = [UIImage imageWithData:[self thumbnailData]];
		
		// NSManageObject setPrimitiveValue to set internal values
		// 16.10 the book selects the 
		// "Use scalar properties for primitive data types"
		// When the Items class was created by NSManagedObject template, Core Data
		
  // Why does thr book set the primitive value for key?
	//	[self setPrimitiveValue:image forKey:@"thumbnail"];			
		
		[self setThumbnail:image];
}


// Before Core Data loads into the database
-(void)awakeFromInsert 
{
		[super awakeFromInsert];
		
		NSTimeInterval time = [[NSDate date] timeIntervalSinceReferenceDate];
		[self setDateCreated:time];
}




#pragma mark
#pragma mark Thumbnail 

// Takes full size image and resizes it to a thumb and sets the
// data for the new thumbnailData so you can pull a image 
// from a thumbnailData
//  You need thumbnailData (NSData) to save a image because
//  you can't encode a UIImage directly
- (void)setThumbnailDataFromImage:(UIImage *)image 
{
		CGSize origImageSize = [image size];
		
		// The rectangle of the thumbnail
		CGRect newRect = CGRectMake(0, 0, 40, 40);
		
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
		UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
		[self setThumbnail:smallImage];
		
		// Get the PNG representation of the image and set it as our archiable data
		NSData *data = UIImagePNGRepresentation(smallImage);
		[self setThumbnailData:data];
		
		// Cleanup image context resources, we're done
		UIGraphicsEndImageContext();
		
}






@end

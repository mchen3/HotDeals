//
//  Items.m
//  DealMaker1
//
//  Created by Mike Chen on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Items.h"

@implementation Items 

@synthesize itemName,descriptions,valueInDollars,dateCreated;
@synthesize imageKey;
@synthesize thumbnail, thumbnailData;

+ (id)randomItem
{
    // Create an array of three adjectives
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy",
                                    @"Rusty",
                                    @"Shiny", nil];
    // Create an array of three nouns
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear",
                               @"Spork",
                               @"Mac", nil];
    // Get the index of a random adjective/noun from the lists
    // Note: The % operator, called the modulo operator, gives
    // you the remainder. So adjectiveIndex is a random number
    // from 0 to 2 inclusive.
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    // Note that NSInteger is not an object, but a type definition
    // for "unsigned long"
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    int randomValue = rand() % 100;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    // Once again, ignore the memory problems with this method
    Items *newItem =
    [[self alloc] initWithItemName:randomName description:randomSerialNumber valueInDollars:randomValue];
    return newItem;
}

-(id)initWithItemName:(NSString *)name description:(NSString *)descript valueInDollars:(int)value
{
    
    self = [super init];
    
    if (self) {
        // Give the instance variables inital values
        [self setItemName:name];
        [self setDescriptions:descript];
        [self setValueInDollars:value];
        
        // dateCreated is readonly, 
        // don't want it to be modified
        // Can't use accessor method setDateCreated
    //    dateCreated = [[NSDate alloc] init];
    }
    return self;
}

-(id)init
{
    return [self initWithItemName:@"Mike"description:@"Cola" valueInDollars:1];
}

-(NSString *)itemDescriptions
{
    NSString *itemDescript = [[NSString alloc] initWithFormat:@"%@ %@ %d %@",
    itemName, descriptions, valueInDollars, dateCreated];
    return itemDescript;
}


#pragma mark
#pragma mark Archiving

// Archiving objects
// Serialize data into a object
-(void)encodeWithCoder:(NSCoder *)aCoder 
{
		[aCoder encodeObject:itemName forKey:@"itemName"];
		[aCoder encodeObject:descriptions forKey:@"description"];
		[aCoder encodeInt:valueInDollars forKey:@"valueInDollars"];
	//	[aCoder encodeObject:dateCreated forKey:@"dateCreated"];
		[aCoder encodeObject:imageKey forKey:@"imageKey"];
		[aCoder encodeObject:thumbnailData forKey:@"thumbnailData"];
}

// Deserializa an object into data
-(id)initWithCoder:(NSCoder *)aDecoder 
{
		self = [super init];
		if (self) {
				
				[self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
				[self setDescriptions:[aDecoder decodeObjectForKey:@"descriptions"]];
				[self setValueInDollars:[aDecoder decodeIntForKey:@"valueInDollars"]];
				[self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
				
			//	dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
			 
				thumbnailData = [aDecoder decodeObjectForKey:@"thumbnailData"];
			
		
		}
		return self;
}


#pragma mark
#pragma mark Thumbnail 

// Takes full size image and resizes it to a thumb and sets the
// data for the new thumbnailData so you can pull a image 
// from a thumbnailData
//  You need thumbnailData (NSData) to archive a image because 
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

// Returns a thumbnail image
- (UIImage *)thumbnail 
{
		
		// You use the two if statements when you restart the program
		// and you have to pull the data from the serialize objects (Archiving)
		// otherwise the thumbnail image is already set after you 
		// take the picture and dismiss ItemViewController
		// imagePickerController didFinishPickingMediaWithInfo:
		
		// If there is no thumbnailData, there is no thumbnail to return
		if (!thumbnailData) {
				return nil;
		}
		
		// If I haven't created my thumbnail image, do so now
		if (!thumbnail) {
				thumbnail = [UIImage imageWithData:thumbnailData];
		}
		
		return thumbnail;
}


@end




























//
//  MapAnnotation.m
//  HotDeals
//
//  Created by Mike Chen on 11/23/12.
//
//

#import "MapAnnotation.h"
@interface MapAnnotation ()
@end

@implementation MapAnnotation
@synthesize coordinate, title, subtitle ;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location title:(NSString *)titleString subtitle:(NSString *)subtitleString
{
		self = [super init];
		if (self != nil) {
				self.coordinate = location;
				self.title = titleString;
				self.subtitle = subtitleString;
		}
		return self;
}
@end































//
//  LocationDataManager.m
//  HotDeals
//
//  Created by Mike Chen on 10/24/12.
//
//

/*
 
 Singleton class to manage location data
 
 */

#import "LocationDataManager.h"

@interface LocationDataManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

#pragma mark

@implementation LocationDataManager

@synthesize currentLocation;
@synthesize currentPlacemark;
@synthesize locationManager;

#pragma mark - Singleton methods

+ (LocationDataManager *)sharedLocation {
		static LocationDataManager *sharedLocation = nil;
		
		if (!sharedLocation) {
				sharedLocation = [[self alloc] init];
		}
		
		return sharedLocation;
}

- (id)init {
		if (self = [super init]) {
				
				[self startUpdatingCurrentLocation];
				
				[self reverseGeocoding];
		}
		return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)startUpdatingCurrentLocation {
		if (nil == self.locationManager) {
				self.locationManager = [[CLLocationManager alloc] init];
		}
		
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		
		// Set a movement threshold for new events.
		// self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
		
		[self.locationManager startUpdatingLocation];
		
		
		CLLocation *location = self.locationManager.location;
		if (location) {
				NSLog(@"locationManager.location");
				self.currentLocation = location;
		}
		
		
}

- (void)stopUpdatingCurrentLocation
{
		[self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
		
		NSLog(@"didUpdate location");
	//	self.currentLocation = newLocation;
		
		[self stopUpdatingCurrentLocation];
		
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
		NSLog(@"Error: %@", [error description]);
		
		if (error.code == kCLErrorDenied) {
				[self.locationManager stopUpdatingLocation];
		} else if (error.code == kCLErrorLocationUnknown) {
				// todo: retry?
				// set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
		} else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
																												message:[error description]
																											 delegate:nil
																							cancelButtonTitle:nil
																							otherButtonTitles:@"Ok", nil];
				[alert show];
		}
}

#pragma mark - ReverseGeocoding

- (void)reverseGeocoding {
		CLGeocoder *geocoder = [[CLGeocoder alloc] init ];
		
		NSLog(@"Geocode");
		/*Testing locations
		CLLocationCoordinate2D coord =
				CLLocationCoordinate2DMake(40.79, -73.81);
		CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
		NSString *lat = [[NSNumber numberWithDouble:self.currentPlacemark.location.coordinate.latitude] stringValue];
		
		NSString *lon = [[NSNumber numberWithDouble:self.currentPlacemark.location.coordinate.longitude]stringValue];
		*/

		[geocoder reverseGeocodeLocation:self.currentLocation completionHandler:
		 ^(NSArray *placemarks, NSError *error) {
				 if (error) {
						 NSLog(@"Error in geocode");
						 return ;
				 }
				 
				CLPlacemark *placemark = [placemarks objectAtIndex:0];
				self.currentPlacemark = placemark;
				 
				NSLog(@"Locality: %@, administrativeArea: %@, subAdministrativeArea: %@, country: %@ ", placemark.locality ,placemark.administrativeArea, placemark.subAdministrativeArea, placemark.country);
				 
				 // Notify DealViewController's subview ParseTableController
				 // that the location data is ready. The location data is
				 // needed when you query the parse server.
				 dispatch_async(dispatch_get_main_queue(), ^{
						 [[NSNotificationCenter defaultCenter] postNotificationName:@"locationReady" object:nil];
				 });
				 
				 
		 }];
		
}


@end







































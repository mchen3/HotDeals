//
//  LocationDataManager.m
//  HotDeals
//
//  Created by Mike Chen on 10/24/12.
//
//

#import "LocationDataManager.h"

@interface LocationDataManager ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

#pragma mark
@implementation LocationDataManager
@synthesize locationManager;
@synthesize currentLocation;
@synthesize currentPlacemark;
@synthesize addressLocation;
@synthesize addressPlacemark;

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
				NSLog(@"LocationDataManager init startUpdating");
				[self startUpdatingCurrentLocation];
				//[self currentLocationByReverseGeocoding];
		}
		return self;
}

#pragma mark - CLLocationManagerDelegate methods and helpers

- (void)startUpdatingCurrentLocation{
		if (nil == self.locationManager) {
				self.locationManager = [[CLLocationManager alloc] init];
		}
		
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
		// Set a movement threshold for new events.
		// self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
		NSLog(@"Start updating current location");
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
		CLLocation *lastLocation = [locations lastObject];
		// Check the locations timestamp, if the location is greater
		// than 3 seconds, it is a old cached location that we will ignore
		NSTimeInterval howRecent = [lastLocation.timestamp timeIntervalSinceNow];
		if (abs(howRecent) > 1.0) {
				return;
		}
		// Update our current location
		self.currentLocation = [locations lastObject];
		// Find our current Placemark
		[self currentLocationByReverseGeocoding];		
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
						message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
				[alert show];
		}
}

#pragma mark - Geocoding methods

// Reverse geocode to find the user's placemark based
// on the device's current GPS location
- (void)currentLocationByReverseGeocoding {
		CLGeocoder *geocoder = [[CLGeocoder alloc] init ];
		
		NSLog(@"currentLocationByReverseGeocoding init");
		[geocoder reverseGeocodeLocation:self.currentLocation completionHandler:
		 ^(NSArray *placemarks, NSError *error) {
				 if (error) {
						 NSLog(@"Error in geocode");
						 return ;
				 }
				 CLPlacemark *placemark = [placemarks objectAtIndex:0];
				 self.currentPlacemark = placemark;
				 
				 NSLog(@"REVERSE GEOCODE Address locality: %@, zipcode: %@, location:%@, diction: %@", placemark.locality , placemark.postalCode,
							 placemark.location   ,   placemark.addressDictionary);
				 
				 
				 dispatch_async(dispatch_get_main_queue(), ^{
						 // Notify DealViewController's subview DealsParseTableController
						 // that the users' current location data is ready. The location
						 // data is needed when you query the parse server.
						 [[NSNotificationCenter defaultCenter]
												postNotificationName:@"currentLocationReady" object:nil];
						 // Notify DealViewController to update its nav title bar to the new current location
						 [[NSNotificationCenter defaultCenter]
												postNotificationName:@"updatedCurrentLocation" object:nil];
				 });
		 }];
} 
/*
We want a specific locality/postal code for the address the user has entered.
We first forward geocode (findLocationByForwardGeocoding) the address string
the user has entered to find a specific coordinate/location and then we use
this location to reverse geocode (findPlacemarkByReverseGeocoding) to find a
complete placemark. The placemark will contain the locality/postal code which 
will be used by the DealsParseTableController to search deals based on locality
 / postal code
*/
-(void)findLocationByForwardGeocoding:(NSString *)userEnteredAddress;
{
		CLGeocoder *geocoder = [[CLGeocoder alloc] init];
		[geocoder geocodeAddressString:userEnteredAddress completionHandler:^(NSArray *placemarks, NSError *error) {
				if (error) {
						NSLog(@"Forward geocode address error");
						return;
				}
				CLPlacemark *placemark = [placemarks objectAtIndex:0];
				self.addressLocation = placemark.location;
				
				NSLog(@"FORWARD Address locality: %@, administrativeArea: %@, subAdministrativeArea: %@, country: %@, zip: %@", placemark.locality ,placemark.administrativeArea, placemark.subAdministrativeArea, placemark.country, placemark.postalCode);
				
				// Find the complete placemark based on location
				[self findPlacemarkByReverseGeocoding:self.addressLocation];
		}];
}

- (void)findPlacemarkByReverseGeocoding:(CLLocation *)userAddressLocation
{
		// Finding placemarks by reverse
		CLGeocoder *geocoder = [[CLGeocoder alloc] init];
		NSLog(@"findPlacemarkByReverseGeocoding");
		[geocoder reverseGeocodeLocation:userAddressLocation
									 completionHandler:^(NSArray *placemarks, NSError *error) {
				if (error) {
						NSLog(@"Reverse geocode address error");
						return;
				}
											 
				CLPlacemark *placemark = [placemarks objectAtIndex:0];
		    self.addressPlacemark = placemark;
											 
	    	NSLog(@"REVERSE Geo Address locality: %@, administrativeArea: %@, subAdministrativeArea: %@, country: %@, zip: %@", placemark.locality ,placemark.administrativeArea, placemark.subAdministrativeArea, placemark.country, placemark.postalCode);
											 
		   
	     	dispatch_async(dispatch_get_main_queue(), ^{
						// Notify DealViewController subview DealsParseTableController
						// that the address location data is ready
						[[NSNotificationCenter defaultCenter]
						postNotificationName:@"addressLocationReady" object:nil];
			    	// Notify DealViewController's nav title to update 
						// to the address that the user has entered
						[[NSNotificationCenter defaultCenter]
				     postNotificationName:@"updatedAddressLocation" object:nil];
				});
		}];
}
@end








































//
//  LocationDataManager.h
//  HotDeals
//
//  Created by Mike Chen on 10/24/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationDataManager : NSObject <CLLocationManagerDelegate>

+ (LocationDataManager *)sharedLocation;


@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLPlacemark *currentPlacemark;

@end

//
//  MapAnnotation.h
//  HotDeals
//
//  Created by Mike Chen on 11/23/12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location title:(NSString *)title subtitle:(NSString *)subtitle;


@end





















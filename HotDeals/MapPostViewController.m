//
//  MapPostViewController.m
//  HotDeals
//
//  Created by Mike Chen on 11/23/12.
//
//

#import "MapPostViewController.h"
#import "MapAnnotation.h"
#import <QuartzCore/QuartzCore.h>

@interface MapPostViewController ()
{
CLLocationCoordinate2D location;
}
@end

@implementation MapPostViewController
@synthesize dealMapView, parseObject, descriptionLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{

		
		// Each parse object from our "Posts" table contains a geopoint for the deal
		// Set the region on our map to be that coordinate
		PFGeoPoint *geopoint = [self.parseObject objectForKey:@"geopoint"];
		location = CLLocationCoordinate2DMake(geopoint.latitude, geopoint.longitude);
		MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance
						(location,0.5*1609.344, 0.5*1609.344);
		[self.dealMapView setRegion:viewRegion animated:YES];

		// Add Annotation
		MapAnnotation *pin = [[MapAnnotation alloc] initWithCoordinates:location
										title:@"Here's the deal" subtitle:nil];
		[self.dealMapView addAnnotation:pin];

		// Show the description
		NSString *description = [self.parseObject objectForKey:@"description"];
		[descriptionLabel setText:description];
		
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
		
		// Make the description field rounded on the corners
		// Must import the QuartzCore class to implement this
    self.descriptionLabel.layer.cornerRadius = 7.5;
		self.navigationItem.title = @"Map Location";		
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

@end



























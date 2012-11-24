//
//  MapPostViewController.h
//  HotDeals
//
//  Created by Mike Chen on 11/23/12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface MapPostViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, strong) PFObject *parseObject;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (weak, nonatomic) IBOutlet MKMapView *dealMapView;

@end























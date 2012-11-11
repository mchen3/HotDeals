//
//  UserViewController.h
//  HotDeals
//
//  Created by Mike Chen on 10/11/12.
//
//

#import <UIKit/UIKit.h>
#import "DealsViewController.h"

@interface UserViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (id)initWithTab:(NSString *)TabBasedOn;
@property (nonatomic, readwrite) NSString *UserViewBasedOn;
@property (nonatomic, strong) PFUser *userNameOfDeal;


@end

//
//  ItemViewController.h
//  DealMaker1
//
//  Created by Mike Chen on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Items.h"
#import <Parse/Parse.h>

@interface DealsItemViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate
, UITextViewDelegate>
{
    
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextView *descriptField;
    __weak IBOutlet UILabel *dateCreated;
    
		__weak IBOutlet PFImageView *imageView;
		__weak IBOutlet UIButton *categoryButton;
		__weak IBOutlet UILabel *priceLabel;
		
		UIImage *imageTest;
		NSString *tempImageKey;
		Items *item;
}

- (IBAction)backgroundTouched:(id)sender;
- (id)initWithName:(BOOL)isNew;
- (IBAction)userButton:(id)sender;
- (IBAction)mapButton:(id)sender;


@property (nonatomic, strong) Items *item;
@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, strong) PFObject *parseObject;
@property (nonatomic, strong) PFUser *userNameOfDeal;

@end























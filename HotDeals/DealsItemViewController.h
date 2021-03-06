//
//  ItemViewController.h
//  DealMaker1
//
//  Created by Mike Chen on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DealsItemViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate
, UITextViewDelegate, UIActionSheetDelegate>
{
    
    __weak IBOutlet UITextView *descriptField;
		__weak IBOutlet PFImageView *imageView;
		__weak IBOutlet UILabel *priceLabel;
		__weak IBOutlet UIButton *mapButtonLabel;
		__weak IBOutlet UILabel *dateLabel;
		__weak IBOutlet UIButton *userButtonLabel;
		__weak IBOutlet UIImageView *mapPinView;
		
		UIImage *imageTest;
		NSString *tempImageKey;
}

- (IBAction)backgroundTouched:(id)sender;
- (id)initWithName:(BOOL)isNew;
- (IBAction)userButton:(id)sender;
- (IBAction)mapButton:(id)sender;
- (IBAction)flagButton:(id)sender;

@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, strong) PFObject *parseObject;
@property (nonatomic, strong) PFUser *userNameOfDeal;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end























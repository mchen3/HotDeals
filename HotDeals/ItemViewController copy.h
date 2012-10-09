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

@interface ItemViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate
, UITextViewDelegate>
{
    
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextView *descriptField;
    __weak IBOutlet UITextField *priceField;
    __weak IBOutlet UILabel *dateCreated;
    __weak IBOutlet UIImageView *imageView;
		__weak IBOutlet UIButton *categoryButton;
		
		UIImage *imageTest;
		NSString *tempImageKey;
		Items *item;
}

- (IBAction)backgroundTouched:(id)sender;
- (IBAction)takePicture:(id)sender;
- (id)initWithName:(BOOL)isNew;
- (IBAction)showCategory:(id)sender;


@property (nonatomic, strong) Items *item;
@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, strong) PFObject *parseObject;

@end























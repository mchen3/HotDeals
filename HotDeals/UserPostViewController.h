//
//  UserPostViewController.h
//  HotDeals
//
//  Created by Mike Chen on 10/12/12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
 
@interface UserPostViewController : UIViewController <UITextFieldDelegate,  UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
		__weak IBOutlet UITextView *descriptField;
		__weak IBOutlet PFImageView *imageView;
		__weak IBOutlet UILabel *priceLabel;
		__weak IBOutlet UILabel *dateLabel;
}

-(id)initWithName:(BOOL)isNew;
- (IBAction)backgroundTouched:(id)sender;
- (IBAction)mapButton:(id)sender;

@property (nonatomic, strong) PFObject *parseObject;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end






















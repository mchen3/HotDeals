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
		
		__weak IBOutlet UITextField *nameField;
		__weak IBOutlet UITextView *descriptField;
		
		__weak IBOutlet UITextField *priceField;
		
		__weak IBOutlet UILabel *dateCreated;
		
		__weak IBOutlet UIImageView *imageView;
}

-(id)initWithName:(BOOL)isNew;

@property (nonatomic, strong) PFObject *parseObject;
@property (nonatomic, copy) void (^dismissBlock)(void);


@end






















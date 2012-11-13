//
//  CreateDealViewController.h
//  HotDeals
//
//  Created by Mike Chen on 11/6/12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CreateDealViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
		
		
		__weak IBOutlet UITextView *descriptField;
		__weak IBOutlet UIImageView *imageView;
		
		__weak IBOutlet UITextField *priceField;
		__weak IBOutlet UILabel *numberOfWords;
		
			
		//__weak IBOutlet UIButton *editButton;

}


- (IBAction)editImage:(id)sender;

@property (nonatomic, strong) PFObject *parseObject;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void (^reloadUserTableBlock)(void);


@end









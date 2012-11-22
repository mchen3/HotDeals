//
//  CreateDealViewController.h
//  HotDeals
//
//  Created by Mike Chen on 11/6/12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CreateDealViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
		
		__weak IBOutlet UITextView *descriptField;
		
		__weak IBOutlet UITextField *priceField;
		__weak IBOutlet UILabel *numberOfWords;
		
		__weak IBOutlet UIButton *deleteDealButton;
			
		//__weak IBOutlet UIButton *editButton;
		
		NSString *storedPriceValue;

}
- (IBAction)priceTextFieldChanged:(id)sender;
- (IBAction)deleteDeal:(id)sender;
- (IBAction)editImage:(id)sender;

@property (nonatomic, strong) PFObject *parseObject;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void (^reloadUserTableBlock)(void);
@property (nonatomic, readwrite) BOOL hideDeleteButton;
@property (nonatomic, readwrite) NSString *storedPriceValue;
@property (weak, nonatomic) IBOutlet PFImageView *imageView;

@end









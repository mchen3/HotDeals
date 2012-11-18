//
//  LoginViewController.h
//  HotDeals
//
//  Created by Mike Chen on 11/16/12.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end

//
//  WelcomeViewController.h
//  HotDeals
//
//  Created by Mike Chen on 11/16/12.
//
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController

- (IBAction)loginButtonSelected:(id)sender;
- (IBAction)signupButtonSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;


@end

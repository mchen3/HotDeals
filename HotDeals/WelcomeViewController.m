//
//  WelcomeViewController.m
//  HotDeals
//
//  Created by Mike Chen on 11/16/12.
//
//

#import "WelcomeViewController.h"
#import "NewUserViewController.h"
#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
		
		// Set the values for the logIn and signUp buttons
		/* Customize the background color of our UIbuttons. Currently the only way
		 to set the background color of UIButton is to set an image. We use our
		 method imageFromColor to set the color. Must imort QuartzCore class */
		[self.logInButton setBackgroundImage:[WelcomeViewController imageFromColor:[UIColor colorWithRed:69.0/255.0 green:71.0/255.0 blue:78.0/255.0 alpha:1.0]]forState:UIControlStateNormal];
		self.logInButton.layer.cornerRadius = 8.0;
		self.logInButton.layer.masksToBounds = YES;
		self.logInButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
		self.logInButton.layer.borderWidth = 1;
		
		[self.signUpButton setBackgroundImage:[WelcomeViewController imageFromColor:[UIColor colorWithRed:69.0/255.0 green:71.0/255.0 blue:78.0/255.0 alpha:1.0]]forState:UIControlStateNormal];
		self.signUpButton.layer.cornerRadius = 8.0;
		self.signUpButton.layer.masksToBounds = YES;
		self.signUpButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
		self.signUpButton.layer.borderWidth = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
		return (interfaceOrientation = UIInterfaceOrientationPortrait);
}

#pragma mark - Buttons

- (IBAction)loginButtonSelected:(id)sender {
		LoginViewController *loginViewController = [[LoginViewController alloc] init];
		[self.navigationController presentViewController:loginViewController animated:YES
																					completion:^{}];
}

- (IBAction)signupButtonSelected:(id)sender {
		NewUserViewController *newUserViewController = [[NewUserViewController alloc] init];
		[self.navigationController presentViewController:newUserViewController animated:YES
														completion:^{}];
}

#pragma mark - User Interface

// Class method we used to customize the color of our UIButton
+ (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (void)viewDidUnload {
		[self setLogInButton:nil];
		[self setSignUpButton:nil];
		[super viewDidUnload];
}
@end























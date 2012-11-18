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


@end























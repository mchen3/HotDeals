//
//  NewsViewController.m
//  DealMaker1
//
//  Created by Mike Chen on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "WelcomeViewController.h"
#import <Parse/Parse.h>
#import "DealAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileViewController ()
@end

@implementation ProfileViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View lifecycles

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
		
		PFUser *currentUser = [PFUser currentUser];
		[self.userNameLabel setText:currentUser.username];
		
		// Set the profile image
		[currentUser fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
				if (!error) {
						PFFile *profileImageFile = [object objectForKey:@"profileImage"];
						if (profileImageFile) {
								NSData *profileImageData = [profileImageFile getData];
								UIImage *profileImage = [UIImage imageWithData:profileImageData];
								[self.profileImageView setImage:profileImage];
						}else{
								UIImage *tempProfileImage = [UIImage imageNamed:@"tempProfileImage.png"];
								[self.profileImageView  setImage:tempProfileImage];
						}
				}
		}];
	
		/* Customize the background color of our UIbuttons. Currently the only way
		 to set the background color of UIButton is to set an image. We use our
		 method imageFromColor to set the color. Must import QuartzCore */
		[self.logOutButton setBackgroundImage:[ProfileViewController imageFromColor:[UIColor lightGrayColor]]forState:UIControlStateNormal];
		self.logOutButton.layer.cornerRadius = 7.5;
		self.logOutButton.layer.masksToBounds = YES;
		self.logOutButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
		self.logOutButton.layer.borderWidth = 1;
		
		self.descriptionField.layer.cornerRadius = 7.5;
		self.descriptionField.layer.borderColor = [UIColor blueColor].CGColor;
}

- (void)viewDidUnload
{
		[self setLogOutButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
		if (buttonIndex == 0) {
				
				// Log out the user out and present the WelcomeViewController as our root controller
				[PFUser logOut];
				
				WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc] init];
				welcomeViewController.title = @"Welcome to Hot Deals";
				UINavigationController *welcomeNavController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
				welcomeNavController.navigationBarHidden = YES;
				
				DealAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
				[[appDelegate window] setRootViewController:welcomeNavController];		
		} 
}

#pragma mark - User Interface helper methods

// Class method we used to customize the color of our UIButton
+ (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Action sheet delegate methods
// Delegate for our profileImage
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		// User has selected to "Take a Picture"
		if (buttonIndex == 0) {
				if ([UIImagePickerController isSourceTypeAvailable:
						 UIImagePickerControllerSourceTypeCamera]) {
						[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
						[imagePicker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
						[imagePicker setDelegate:self];
						[self presentViewController:imagePicker animated:YES completion:nil];
				}
		}
		// User has selected to "Take a photo from his library"
		else if (buttonIndex == 1){
				[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
				[imagePicker setDelegate:self];
				[self presentViewController:imagePicker animated:YES completion:nil];
		}
}

#pragma mark - UIImagePickerController delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
		[self dismissViewControllerAnimated:YES completion:^{
				UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
				// Resize our image to a small thumbnail and save to our backend
				[self resizeToThumbnailAndSave:image];
		}];
}

#pragma mark - Button action 
- (IBAction)profileImageButtonSelected:(id)sender {
		
		UIActionSheet *profileImageMenu = [[UIActionSheet alloc] initWithTitle:nil
				delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
				otherButtonTitles:@"Take a Picture",@"Use Photo from Libarary", nil];
		/* Place your ActionSheet above all views, instead of just your self.view
		 because your viewcontroller is within a tab controller and this will prevent
		 the "Cancel" button, which is beneath your tab controller to be selected */
		[profileImageMenu showInView:[UIApplication sharedApplication].keyWindow];
		
}

- (IBAction)logOutButtonSelected:(id)sender {
		[PFUser logOut];
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log out of HotDeals?" message:nil delegate:self cancelButtonTitle:@"Log out" otherButtonTitles:@"Cancel", nil];
		[alertView show];
}

#pragma mark - Resize our image
// Takes a full size image and resizes it to a smaller
// image and saves it to Parse
- (void)resizeToThumbnailAndSave:(UIImage *)image
{
		CGSize origImageSize = [image size];
		// The rectangle of the thumbnail
		//CGRect newRect = CGRectMake(0, 0, 80, 70);
		CGRect newRect = CGRectMake(0, 0, 160, 140);
		
		// Figure out the scaling ratio to make sure we maintain the same aspect ratio
		float ratio = MAX(newRect.size.width / origImageSize.width,
											newRect.size.height / origImageSize.height);
		// Create a transparent bitmap context with a
		// scaling  factor equal to that of the screen
		UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
		// Center the image in the thumbnail rectangle
		CGRect projectRect;
		projectRect.size.width = ratio * origImageSize.width;
		projectRect.size.height = ratio * origImageSize.height;
		projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
		projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
		// Draw the image on it
		[image drawInRect:projectRect];
		// Get the image from the image context, keep it as our thumbnail
		UIImage *profileImage = UIGraphicsGetImageFromCurrentImageContext();
		// Cleanup image context resources, we're done
		UIGraphicsEndImageContext();
		
		// Reformat the image and associate it with a PFFile
		NSData *profileData = UIImageJPEGRepresentation(profileImage, 0.05f);
		PFFile *profileFile = [PFFile fileWithName:@"profile.jpg" data:profileData];
		[profileFile save];
		
		/* Save our profile image to Parse
		 Access the "User" table on parse servers through PFUser
		 instead of [PFObject objectWithClassName@"User"] */
		PFUser *currentUser = [PFUser currentUser];
		[currentUser setObject:profileFile forKey:@"profileImage"];
		[currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
				if (!error) {
						// Set our new thumnail
						[self.profileImageView setImage:profileImage];
				}
		}];
}

@end



























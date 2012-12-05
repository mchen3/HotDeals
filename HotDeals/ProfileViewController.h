//
//  NewsViewController.h
//  DealMaker1
//
//  Created by Mike Chen on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ProfileViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
- (IBAction)logOutButtonSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
- (IBAction)profileImageButtonSelected:(id)sender;
@end

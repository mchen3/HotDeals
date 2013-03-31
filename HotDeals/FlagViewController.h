//
//  FlagViewController.h
//  HotDeals
//
//  Created by Mike Chen on 3/29/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Parse/Parse.h>

@interface FlagViewController : UIViewController <MFMailComposeViewControllerDelegate>{
		NSString *complaint;
}
- (IBAction)sendToMod:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) PFObject *parseObject;
@property (nonatomic, strong) PFUser *userNameOfDeal;

@end

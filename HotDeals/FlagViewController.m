//
//  FlagViewController.m
//  HotDeals
//
//  Created by Mike Chen on 3/29/13.
//
//

#import "FlagViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FlagViewController ()
{
		UIView *superView;
}

@end
@implementation FlagViewController
@synthesize parseObject,userNameOfDeal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
		
    // Do any additional setup after loading the view from its nib.
		
		superView  = [[UIView alloc] initWithFrame:CGRectMake(20, 120, 280, 230)];
		[superView setBackgroundColor:[UIColor grayColor]];
		[superView.layer setCornerRadius:7.5];
		[superView.layer setMasksToBounds:YES];
		[self.view addSubview:superView];
		
		
		UILabel *complaintLabel1 = [[UILabel alloc]
																initWithFrame:CGRectMake(5, 20, 280, 20)];
		[complaintLabel1 setText:@"\u2022 I find this picture inappropriate"];
		[complaintLabel1 setFont:[UIFont fontWithName:@"Helvetica" size:15]];
		[complaintLabel1 setBackgroundColor:[UIColor clearColor]];
		[superView addSubview:complaintLabel1];
		
		UIButton *radioButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
		[radioButton1 setImage:[UIImage imageNamed:@"checkboxUncheck.png"] forState:UIControlStateNormal];
		[radioButton1 setImage:[UIImage imageNamed:@"checkboxCheck.png"] forState:UIControlStateSelected];
		//[radioButton1 setBackgroundColor:[UIColor whiteColor]];
		[radioButton1 setFrame:CGRectMake(240, 15, 35, 35)];
		radioButton1.tag = 1;
		[radioButton1 addTarget:self action:@selector(checkbox:) forControlEvents:UIControlEventTouchUpInside];
		[radioButton1 setTitle:complaintLabel1.text forState:UIControlStateNormal];
		[superView addSubview:radioButton1];

		
		UILabel *complaintLabel2 = [[UILabel alloc]
																initWithFrame:CGRectMake(5, 60, 280, 20)];
		[complaintLabel2 setText:@"\u2022 This photo is spam or scam"];
		[complaintLabel2 setFont:[UIFont fontWithName:@"Helvetica" size:15]];
		[complaintLabel2 setBackgroundColor:[UIColor clearColor]];
		[superView addSubview:complaintLabel2];
		
		UIButton *radioButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
		[radioButton2  setImage:[UIImage imageNamed:@"checkboxUncheck.png"] forState:UIControlStateNormal];
		[radioButton2  setImage:[UIImage imageNamed:@"checkboxCheck.png"] forState:UIControlStateSelected];
		//[radioButton2 setBackgroundColor:[UIColor whiteColor]];

		[radioButton2  setFrame:CGRectMake(240, 55, 35, 35)];
		radioButton2.tag = 2;
		[radioButton2  addTarget:self action:@selector(checkbox:) forControlEvents:UIControlEventTouchUpInside];
		[radioButton2 setTitle:complaintLabel2.text forState:UIControlStateNormal];
		[superView addSubview:radioButton2 ];
		
		
		UILabel *complaintLabel3 = [[UILabel alloc]
																initWithFrame:CGRectMake(5, 100, 280, 20)];
		[complaintLabel3 setText:@"\u2022 This photo should not be on here"];
		[complaintLabel3 setFont:[UIFont fontWithName:@"Helvetica" size:15]];
		[complaintLabel3 setBackgroundColor:[UIColor clearColor]];
		[superView addSubview:complaintLabel3];

		UIButton *radioButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
		[radioButton3 setImage:[UIImage imageNamed:@"checkboxUncheck.png"] forState:UIControlStateNormal];
		[radioButton3 setImage:[UIImage imageNamed:@"checkboxCheck.png"] forState:UIControlStateSelected];
		[radioButton3 setFrame:CGRectMake(240, 96, 35, 35)];
		//[radioButton3 setBackgroundColor:[UIColor whiteColor]];
		radioButton3.tag = 3;
		[radioButton3 addTarget:self action:@selector(checkbox:) forControlEvents:UIControlEventTouchUpInside];
		[radioButton3 setTitle:complaintLabel3.text forState:UIControlStateNormal];
		[superView addSubview:radioButton3];
		
		
		UILabel *complaintLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(5, 140, 280, 20)];
		[complaintLabel4 setText:@"\u2022 This content puts people at risk"];
		[complaintLabel4 setFont:[UIFont fontWithName:@"Helvetica" size:15]];
		[complaintLabel4 setBackgroundColor:[UIColor clearColor]];
		[superView addSubview:complaintLabel4];
		
		UIButton *radioButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
		[radioButton4 setImage:[UIImage imageNamed:@"checkboxUncheck.png"] forState:UIControlStateNormal];
		[radioButton4 setImage:[UIImage imageNamed:@"checkboxCheck.png"] forState:UIControlStateSelected];
		//[radioButton4 setBackgroundColor:[UIColor whiteColor]];

		[radioButton4 setFrame:CGRectMake(240, 135, 35, 35)];
		radioButton4.tag = 4;
		[radioButton4 addTarget:self action:@selector(checkbox:) forControlEvents:UIControlEventTouchUpInside];
		[radioButton4 setTitle:complaintLabel4.text forState:UIControlStateNormal];
		[superView addSubview:radioButton4];
		
		
		[self.view addSubview:self.sendButton];
}

- (IBAction)checkbox:(UIButton *)button {
		
		for (UIButton *but in [superView subviews]) {
				if ([but isKindOfClass:[UIButton class]] && ![but isEqual:button]) {
						[but setSelected:NO];
				}
		}
		if (!button.selected) {
				button.selected = !button.selected;
	      complaint = button.titleLabel.text;
		}
}


-(void)setComplaint:(int)complaintNum {
		//complaint = complaintNum;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
		[self setSendButton:nil];
		[super viewDidUnload];
}
- (IBAction)sendToMod:(UIButton *)button {
				
		if (!complaint) {

				UIAlertView *alert = [[UIAlertView alloc]
						initWithTitle: @"Announcement" message: @"Error"
						delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
		}
		else {
								
				PFUser *user = [PFUser currentUser];
				NSString *currentUser = user.username;
				
				
				NSString *username = self.userNameOfDeal.username;
				NSDate *date = self.parseObject.createdAt;
				
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
				[dateFormat setDateFormat:@"MMMM d, YYYY"];
				NSString *dateString = [dateFormat stringFromDate:date];
				
				
				NSString *postID = self.parseObject.objectId;
				
		
				NSMutableString *emailBody = [NSMutableString stringWithFormat:@"My name is %@ and I would like to report user: %@\n",currentUser,username];
				NSString *dateBody = [NSString stringWithFormat:@"\n\nCreated at %@\n", dateString];
				[emailBody appendString:dateBody];
				NSString *idBody = [NSString stringWithFormat:@"Post ID: %@\n\nReason:\n", postID];
				[emailBody appendString:idBody];
				NSString *messageBody = complaint;
				[emailBody appendString:messageBody];
				
				
				MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
				controller.mailComposeDelegate = self;
				[controller setSubject:@"Flag photo"];
				[controller setMessageBody:emailBody isHTML:NO];
				[controller setToRecipients:[NSArray arrayWithObjects:@"jlinball@hotmail.com", nil]];
				controller.navigationBar.tintColor = [UIColor blackColor];
		
				
				if (controller) {
				[self presentViewController:controller animated:YES completion:^{
				}];
				}
		}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
		[self dismissModalViewControllerAnimated:YES];
		
		UIAlertView *alert = [[UIAlertView alloc]
													initWithTitle: nil message: @"Your complaint has been sent" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		if (result == MFMailComposeResultSent) {
				[alert show];
		}
}
@end






















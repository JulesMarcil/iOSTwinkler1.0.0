//
//  InviteViewController.m
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 26/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "InviteViewController.h"
#import "AuthAPIClient.h"
#import "Group.h"
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>

@interface InviteViewController ()

@end

@implementation InviteViewController

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
	// Do any additional setup after loading the view.
    self.linkLabel.text = [NSString stringWithFormat:@"http://www.twinkler.co/invitation/%@/%@", self.group.identifier, self.link];
    
    
    UIColor *borderColor = [UIColor colorWithRed:(200/255.0) green:(200/255.0) blue:(200/255.0) alpha:1] ;
    UIColor *textColor = [UIColor colorWithRed:(65/255.0) green:(65/255.0) blue:(65/255.0) alpha:1] ;
    
    [self.shareSMSButton setTitleColor: textColor forState: UIControlStateNormal];
    [self.shareSMSButton.layer  setBorderColor:borderColor.CGColor];
    [self.shareSMSButton.layer  setBorderWidth:1.0];
    
    [self.shareEmailButton setTitleColor: textColor forState: UIControlStateNormal];
    [self.shareEmailButton.layer  setBorderColor:borderColor.CGColor];
    [self.shareEmailButton.layer  setBorderWidth:1.0];
    
    [self.shareFacebookButton setTitleColor: textColor forState: UIControlStateNormal];
    [self.shareFacebookButton.layer  setBorderColor:borderColor.CGColor];
    [self.shareFacebookButton.layer  setBorderWidth:1.0];
    
    [self.doneButton setTitleColor: textColor forState: UIControlStateNormal];
    [self.doneButton.layer  setBorderColor:borderColor.CGColor];
    [self.doneButton.layer  setBorderWidth:1.0];
    
    [self.linkContainer.layer  setBorderColor:borderColor.CGColor];
    [self.linkContainer.layer  setBorderWidth:1.0];
    

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)shareViaSMS:(id)sender {
    
	if([MFMessageComposeViewController canSendText]){
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
		controller.body = [NSString stringWithFormat:@"Hello, I added you to a group on Twinkler, follow this link to access it: http://www.twinkler.co/invitation/%@/%@", self.group.identifier, self.link];
		controller.messageComposeDelegate = self;
		[self presentViewController:controller animated:YES completion:nil];
	} else {
        [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You cannot send sms on this device" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
			NSLog(@"failed");
			break;
		case MessageComposeResultSent:
            NSLog(@"sent");
			break;
		default:
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareViaEmail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.subject = @"I added you to a group on Twinkler";
        [controller setMessageBody:[NSString stringWithFormat:@"Hello, I added you to a group on Twinkler, follow this link to access it: http://www.twinkler.co/invitation/%@/%@", self.group.identifier, self.link] isHTML:NO];
        
        controller.mailComposeDelegate = (id) self;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You cannot send emails on this device" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareViaFacebook:(id)sender {
    
    NSLog(@"share via facebook called");
    
    /*
    NSURL* url = [NSURL URLWithString:@"https://developers.facebook.com/ios"];
    [FBDialogs presentShareDialogWithLink:url
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          NSLog(@"Error: %@", error.description);
                                      } else {
                                          NSLog(@"Success!");
                                      }
                                  }];
     */
}

@end

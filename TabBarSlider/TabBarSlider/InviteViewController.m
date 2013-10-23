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
#import "MenuViewController.h"

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
    self.view.backgroundColor=[UIColor colorWithRed:(247/255.0) green:(245/255.0) blue:(245/255.0) alpha: 1];
    self.toolbar.backgroundColor=[UIColor colorWithRed:(254/255.0) green:(106/255.0) blue:(100/255.0) alpha:1];
    self.buttonContainer.layer.cornerRadius = 5;
    self.buttonContainer.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    self.buttonContainer.layer.borderColor = [UIColor colorWithRed:(204/255.0) green:(204/255.0) blue:(204/255.0) alpha: 1].CGColor;
    self.buttonContainer.layer.borderWidth = 1.0f;
    
    self.linkCopyContainer.layer.cornerRadius = 5;
    self.linkLabel.text= @"Linked Copied into Clipboard";
    
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
		controller.body = [NSString stringWithFormat:@"Hello, I added you to my group %@ on Twinkler. To join me go to http://www.twinkler.co and login", self.group.name];
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
        [controller setMessageBody:[NSString stringWithFormat:@"Hello, I added you to my group %@ on Twinkler. To join me go to http://www.twinkler.co and login", self.group.name] isHTML:NO];
        
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

- (IBAction)doneAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)copyLink:(id)sender {
    [UIPasteboard generalPasteboard].string = @"test";
    self.linkCopyContainer.hidden = NO;
    self.linkCopyContainer.alpha = 1.0f;
    // Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
    [UIView animateWithDuration:0.5 delay:0.6 options:0 animations:^{
        // Animate the alpha value of your imageView from 1.0 to 0.0 here
        self.linkCopyContainer.alpha = 0.0f;
    } completion:^(BOOL finished) {
        // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
        self.linkCopyContainer.hidden = YES;
    }];
}


@end

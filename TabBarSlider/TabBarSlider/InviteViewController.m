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

- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{

}

- (IBAction)shareViaSMS:(id)sender {
    
	if([MFMessageComposeViewController canSendText]){
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
		controller.body = [NSString stringWithFormat:@"Hello, I added you to a group on Twinkler, follow this link to access it: http://www.twinkler.co/invitation/%@/%@", self.group.identifier, self.link];
		controller.messageComposeDelegate = self;
		[self presentViewController:controller animated:YES completion:nil];
	}
}

- (IBAction)shareViaEmail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.subject = @"I added you to a group on Twinkler";
        [controller setMessageBody:[NSString stringWithFormat:@"Hello, I added you to a group on Twinkler, follow this link to access it: http://www.twinkler.co/invitation/%@/%@", self.group.identifier, self.link] isHTML:NO];
        
        controller.mailComposeDelegate = (id) self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (IBAction)shareViaFacebook:(id)sender {
}
@end

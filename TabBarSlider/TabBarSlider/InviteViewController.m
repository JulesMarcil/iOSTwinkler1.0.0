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
	}
}

- (IBAction)shareViaEmail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.subject = @"I added you to a group on Twinkler";
        [controller setMessageBody:[NSString stringWithFormat:@"Hello, I added you to a group on Twinkler, follow this link to access it: http://www.twinkler.co/invitation/%@/%@", self.group.identifier, self.link] isHTML:NO];
        
        [controller setMailComposeDelegate:self];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (IBAction)shareViaFacebook:(id)sender {
}
@end

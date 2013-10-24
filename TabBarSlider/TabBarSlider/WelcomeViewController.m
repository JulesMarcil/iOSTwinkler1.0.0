//
//  welcomeViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 12/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AuthAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "CredentialStore.h"
#import "AppDelegate.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect frame= [self.connectWithFbButton frame];
    [self.connectWithFbButton setFrame:CGRectMake(frame.origin.x,
                                       screenHeight-frame.size.height-80,
                                       frame.size.width,
                                       frame.size.height)];
    
    frame= [self.signinButton frame];
    [self.signinButton setFrame:CGRectMake(frame.origin.x,
                                             screenHeight-frame.size.height-15,
                                             frame.size.width,
                                             frame.size.height)];
    
    frame= [self.loginLabel frame];
    [self.loginLabel setFrame:CGRectMake(frame.origin.x,
                                           screenHeight-frame.size.height-25-18-10,
                                           frame.size.width,
                                           frame.size.height)];
    
    frame= [self.bckgdImage frame];
    [self.bckgdImage setFrame:screenRect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)FBConnect:(id)sender {
    
    self.spinnerContainer.hidden=NO;
    [self.connectWithFbButton setEnabled:NO];
    
    NSLog(@"login with facebook");
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}
@end

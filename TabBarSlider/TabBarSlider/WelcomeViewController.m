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
    self.screenName = @"WelcomeVC";
    
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
    
    frame= [self.whyFBLogin frame];
    [self.whyFBLogin setFrame:CGRectMake(frame.origin.x,
                                         screenHeight+10,
                                         frame.size.width,
                                         frame.size.height)];
    
    frame= [self.seeWhyContainer frame];
    [self.seeWhyContainer setFrame:CGRectMake(frame.origin.x,
                                         screenHeight-frame.size.height,
                                         frame.size.width,
                                         frame.size.height)];
    
    frame= [self.bckgdImage frame];
    [self.bckgdImage setFrame:screenRect];
    
    
    self.whyLabelContainer.layer.cornerRadius=5;
    self.whyLabelContainer.layer.masksToBounds = YES;
    self.whyLabelContainer.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.whyLabelContainer.layer.borderWidth = 1.0f;
    
    self.spinnerContainer.layer.cornerRadius=5;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"WelcomeVC";
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

- (IBAction)dismissFBView:(id)sender {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5f];
    CGRect frame= [self.whyFBLogin frame];
    [self.whyFBLogin setFrame:CGRectMake(frame.origin.x,
                                         screenHeight+10,
                                         frame.size.width,
                                         frame.size.height)];
    [UIView commitAnimations];
}

- (IBAction)whyFBSHow:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5f];
    CGRect frame= [self.whyFBLogin frame];
    [self.whyFBLogin setFrame:CGRectMake(frame.origin.x,
                                         0,
                                         frame.size.width,
                                         frame.size.height)];
    [UIView commitAnimations];
}
@end

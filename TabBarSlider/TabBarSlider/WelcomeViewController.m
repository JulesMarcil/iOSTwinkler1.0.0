//
//  welcomeViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 12/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "WelcomeViewController.h"

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
    
    CGRect frame= [self.registerButton frame];
    [self.registerButton setFrame:CGRectMake(15,
                                       screenHeight-frame.size.height-30,
                                       frame.size.width,
                                       frame.size.height)];
    
    frame= [self.signinButton frame];
    [self.signinButton setFrame:CGRectMake(160,
                                             screenHeight-frame.size.height-30,
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

@end

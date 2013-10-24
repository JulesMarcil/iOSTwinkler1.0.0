//
//  ConnectViewController.m
//  Twinkler
//
//  Created by Jules Marcilhacy on 23/10/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "ConnectViewController.h"
#import "AddFriendsViewController.h"
#import "Group.h"
#import "AppDelegate.h"

@interface ConnectViewController ()

@end

@implementation ConnectViewController

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
    
    self.view.backgroundColor=[UIColor colorWithRed:(247/255.0) green:(245/255.0) blue:(245/255.0) alpha: 1];
    self.toolbar.backgroundColor=[UIColor colorWithRed:(254/255.0) green:(106/255.0) blue:(100/255.0) alpha:1];
    
    UIColor *borderColor = [UIColor colorWithRed:(200/255.0) green:(200/255.0) blue:(200/255.0) alpha:1] ;
    
    self.labelContainerView.layer.cornerRadius = 5;
    [self.labelContainerView.layer  setBorderColor:borderColor.CGColor];
    [self.labelContainerView.layer  setBorderWidth:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectedToFacebook)   name:@"connectedToFacebook"  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectAction:(id)sender {
    
    [self.spinner startAnimating];
    [sender setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:149/255 alpha:0.0] forState: UIControlStateNormal];
    
    NSLog(@"Connect facebook");
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

- (void) connectedToFacebook{
    [self.spinner stopAnimating];
    [self performSegueWithIdentifier:@"ConnectToFriends" sender:self];
}

- (IBAction)noAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ConnectToFriends"]) {
        
        AddFriendsViewController *afvc = [segue destinationViewController];
        afvc.group = self.group;
        
    }
}
@end

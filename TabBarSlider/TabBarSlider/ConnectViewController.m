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
#import <FacebookSDK/FacebookSDK.h>
#import "AuthAPIClient.h"

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
    
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    
    if(fbAccessToken) {
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:fbAccessToken,@"facebook_access_token", nil];
        [[AuthAPIClient sharedClient] postPath:@"api/facebook/merge"
                                    parameters:parameters
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           NSError * error = nil;
                                           NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                           NSLog(@"response: %@",response);
                                           
                                           [self mergedAccount];
                                           
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"error: %@", error);
                                           [self.spinner stopAnimating];
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account not connected"
                                                                                           message:@"The user could not be merged with the Facebook account, please try again"
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"OK"
                                                                                 otherButtonTitles:nil, nil];
                                           [alert show];
                                       }];
    }
}

- (void) mergedAccount{
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

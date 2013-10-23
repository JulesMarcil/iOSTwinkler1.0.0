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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectAction:(id)sender {
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

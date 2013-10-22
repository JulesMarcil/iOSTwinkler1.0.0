//
//  GroupMemberViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 22/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "GroupMemberViewController.h"
#import "AppDelegate.h"
#import "AddFriendsViewController.h"
#import "InviteViewController.h"
#import "Group.h"
#import "MenuViewController.h"

@interface GroupMemberViewController ()

@end

@implementation GroupMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"FacebookModal"]){
        AddFriendsViewController *afvc = [segue destinationViewController];
        afvc.group = self.group;
    }
    if ([segue.identifier isEqualToString:@"InvitationModal"]){
        InviteViewController *ivc = [segue destinationViewController];
        ivc.group = self.group;
    }
}

- (void) done:(id)sender{
    [[NSUserDefaults standardUserDefaults] setObject:self.group.members forKey:@"currentGroupMembers"];
    
    UINavigationController *presenting = (UINavigationController *)self.presentingViewController;
    UIViewController *active = (UIViewController *)presenting.viewControllers[presenting.viewControllers.count-1];
    
    if([active.title isEqualToString:@"welcomeMenu"]){
        MenuViewController *menu = (MenuViewController *)active;
        [menu pushNewGroup:self.group];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

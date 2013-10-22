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
    
    self.view.backgroundColor=[UIColor colorWithRed:(247/255.0) green:(245/255.0) blue:(245/255.0) alpha: 1];
    self.toolbar.backgroundColor=[UIColor colorWithRed:(254/255.0) green:(106/255.0) blue:(100/255.0) alpha:1];
    
    UIColor *textColor = [UIColor whiteColor] ;
    
    
    [self.doneButton setTitleColor: textColor forState: UIControlStateNormal];
    //[self.doneButton.layer  setBorderColor:[UIColor colorWithRed:(136/255.0) green:(202/255.0) blue:(0/255.0) alpha:1].CGColor];
   // [self.doneButton.layer  setBorderWidth:1.0];
    
    self.mainDoneButton.layer.borderColor = [UIColor colorWithRed:(78/255.0) green:(128/255.0) blue:(3/255.0) alpha: 0.6].CGColor;
    self.mainDoneButton.layer.borderWidth = 1.0f;
    
    [self.cancelButton setTitleColor: textColor forState: UIControlStateNormal];
   // [self.cancelButton.layer  setBorderColor:borderColor.CGColor];
   // [self.cancelButton.layer  setBorderWidth:1.0];
    
    self.actionContainer.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    self.actionContainer.layer.borderColor = [UIColor colorWithRed:(204/255.0) green:(204/255.0) blue:(204/255.0) alpha: 1].CGColor;
    self.actionContainer.layer.borderWidth = 1.0f;
    self.actionContainer.layer.cornerRadius = 5;
    
    self.addWithFacebookButton.layer.borderColor = [UIColor colorWithRed:(48/255.0) green:(74/255.0) blue:(138/255.0) alpha: 1].CGColor;
    self.addWithFacebookButton.layer.borderWidth = 1.0f;
    self.addFriendsManuallyButton.layer.borderColor = [UIColor colorWithRed:(204/255.0) green:(204/255.0) blue:(204/255.0) alpha: 1].CGColor;
    self.addFriendsManuallyButton.layer.borderWidth = 1.0f;
    
    
    self.invitationButton.layer.borderColor = [UIColor colorWithRed:(78/255.0) green:(128/255.0) blue:(3/255.0) alpha: 0.6].CGColor;
    self.invitationButton.layer.borderWidth = 1.0f;
    
    
    
    // ADD FIREND MANUALLY POPOVER
    
    CGRect frame= [self.addMemberPopover frame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.addMemberPopover setFrame:CGRectMake(frame.origin.x,
                                                 screenRect.size.height+30,
                                                 frame.size.width,
                                                 frame.size.height)];
    
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

- (IBAction)doneAddMemberPopover:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    //you can change the setAnimationDuration value, it is in seconds.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect rect = CGRectMake(10, screenRect.size.height+30, 300, 290);
    [self.addMemberPopover setFrame:rect];
    
    
    [UIView commitAnimations];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)cancelAddMemberPopover:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    //you can change the setAnimationDuration value, it is in seconds.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect rect = CGRectMake(10, screenRect.size.height+30, 300, 290);
    [self.addMemberPopover setFrame:rect];
    
    
    [UIView commitAnimations];
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

- (IBAction)addVirtualMember:(id)sender {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    //you can change the setAnimationDuration value, it is in seconds.
    
    CGRect rect = CGRectMake(10, 50, 300, 290);
    [self.addMemberPopover setFrame:rect];

    
    [UIView commitAnimations];
}

@end

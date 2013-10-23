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
#import "AuthAPIClient.h"

@interface GroupMemberViewController ()

@end

@implementation GroupMemberViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addedMembersPopover = [[NSMutableDictionary alloc] init];
    
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
    self.addMemberPopover.layer.cornerRadius=10;
    self.addMemberPopover.clipsToBounds=YES;
    
    [self.bckPopover.layer setMasksToBounds:YES];
    [self.bckPopover.layer setCornerRadius:10.0];
    
    UIColor *borderColor = [UIColor colorWithRed:(200/255.0) green:(200/255.0) blue:(200/255.0) alpha:1] ;
    textColor = [UIColor colorWithRed:(65/255.0) green:(65/255.0) blue:(65/255.0) alpha:1] ;
    
    [self.doneButton setTitleColor: textColor forState: UIControlStateNormal];
    [self.doneButton.layer  setBorderColor:borderColor.CGColor];
    [self.doneButton.layer  setBorderWidth:1.0];
    
    [self.cancelButton setTitleColor: textColor forState: UIControlStateNormal];
    [self.cancelButton.layer  setBorderColor:borderColor.CGColor];
    [self.cancelButton.layer  setBorderWidth:1.0];
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



-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag==2) {
        
        [self.memberEmailPopover becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        [self.view viewWithTag:3].frame=CGRectMake(0, self.view.bounds.size.height, 320, 44);
         }
         
    return YES;
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

// --- POPOVER ---

- (IBAction)cancelAddMemberPopover:(id)sender {
    [self dismissPopover];
    
}

- (void)dismissPopover{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    //you can change the setAnimationDuration value, it is in seconds.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect rect = CGRectMake(10, screenRect.size.height+30, 300, 230);
    [self.addMemberPopover setFrame:rect];
    
    [self.view viewWithTag:1].alpha=0;
    [self.view viewWithTag:3].frame=CGRectMake(0, self.view.bounds.size.height, 320, 44);
    
    [UIView commitAnimations];
    
    [[self.view viewWithTag:1] removeFromSuperview];
    
    [[self.view viewWithTag:3] removeFromSuperview];
    
    [self.memberNamePopover resignFirstResponder];
    [self.memberEmailPopover resignFirstResponder];
}


- (IBAction)addMemberPopover:(id)sender {
    
    if (self.memberNamePopover.text.length > 0){
        
        if([self.addedMembersPopover objectForKey:self.memberNamePopover.text]){
            //already a member aded with this name
        } else {
            
            NSDictionary *member = [[NSDictionary alloc] initWithObjects:@[self.memberNamePopover.text, self.memberEmailPopover.text] forKeys:@[@"name", @"email"]];
            [self.addedMembersPopover setObject:member forKey:self.memberNamePopover.text];
            
            NSLog(@"%@ added to list", member[@"name"]);
            
            
            
            self.spinnerContainer.hidden=NO;
            
            self.spinnerPopover.hidden=YES;
            self.spinnerLabel.text=[self.memberNamePopover.text stringByAppendingString:@" was added!"] ;
            
            self.spinnerContainer.hidden = NO;
            self.spinnerContainer.alpha = 1.0f;
            // Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
            [UIView animateWithDuration:0.5 delay:0.6 options:0 animations:^{
                // Animate the alpha value of your imageView from 1.0 to 0.0 here
                self.spinnerContainer.alpha = 0.0f;
            } completion:^(BOOL finished) {
                // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
                self.spinnerContainer.hidden = YES;
            }];
            
            //UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 49, [self.memberNamePopover.text sizeWithFont:[UIFont systemFontOfSize:14]].width+15, 20)];
            //label.text=self.memberNamePopover.text;
            //label.backgroundColor=[UIColor colorWithRed:(254/255.0) green:(106/255.0) blue:(100/255.0) alpha:1];
            //label.textColor=[UIColor whiteColor];
            //label.layer.cornerRadius = 8;
            //label.tag=11;
            //label.textAlignment = NSTextAlignmentCenter;
            //[self.addMemberPopover addSubview:label];
            
            self.memberNamePopover.text = @"";
            self.memberEmailPopover.text = @"";
            
        }
        
    } else {
        //Please enter a name
    }
}


- (IBAction)doneAddMemberPopover:(id)sender {
    
    NSLog(@"doneAddMemberPopover, %u members to add", self.addedMembersPopover.count);
    
    if(self.addedMembersPopover.count > 0){
        
        //show spinner
        [self.spinnerPopover startAnimating];
        
        NSLog(@"list = %@", self.addedMembersPopover);
        
        //Define post parameters
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:@[self.group.identifier, self.addedMembersPopover] forKeys:@[@"group", @"friends"]];
        
        [[AuthAPIClient sharedClient] postPath:@"api/group/manual"
                                    parameters:parameters
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           NSError *error = nil;
                                           NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                           NSLog(@"%@", response);
                                           [self.spinnerPopover stopAnimating];
                                           
                                           Group *group = [[Group alloc] initWithName:response[@"name"]
                                                                           identifier:response[@"id"]
                                                                              members:response[@"members"]
                                                                         activeMember:self.group.activeMember
                                                                             currency:response[@"currency"]];
                                           self.group = group;
                                           [[NSUserDefaults standardUserDefaults] setObject:self.group.members forKey:@"currentGroupMembers"];
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"doneAddMember" object:nil userInfo:nil];
                                           [self dismissPopover];
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"error: %@", error);
                                           [self.spinnerPopover stopAnimating];
                                           self.doneButton.hidden = NO;
                                           
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Friends not added"
                                                                                           message:@"Make sure you have a connection"
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"OK"
                                                                                 otherButtonTitles:nil, nil];
                                           [alert show];
                                       }];
        
    } else {
        [self dismissPopover];
    }
}

// --- call popover
- (IBAction)addVirtualMember:(id)sender {
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 1;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopover)] ;
    [darkView addGestureRecognizer:tapGesture];
    [self.view insertSubview:darkView belowSubview:self.addMemberPopover];
    
    
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)] ;
    toolBar.tag = 3;
    toolBar.tintColor= [UIColor blackColor];
    toolBar.translucent=NO;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton* btton = [UIButton buttonWithType:UIButtonTypeCustom];
    [btton setFrame:CGRectMake(0, 0, 115, 38)];
    [btton addTarget:self action:@selector(addMemberPopover:) forControlEvents:UIControlEventTouchUpInside];
    [btton setImage:[UIImage imageNamed:@"add-friend.png"] forState:UIControlStateNormal];
    UIBarButtonItem* remix = [[UIBarButtonItem alloc] initWithCustomView:btton];
    
    [toolBar setItems:[NSArray arrayWithObjects:spacer, remix, nil]];
    [self.view addSubview:toolBar];
    [self.view bringSubviewToFront:toolBar];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    //you can change the setAnimationDuration value, it is in seconds.
    
    toolBar.frame = toolbarTargetFrame;
    CGRect rect = CGRectMake(10, 30, 300, 230);
    [self.addMemberPopover setFrame:rect];
    darkView.alpha = 0.6;
    
    [UIView commitAnimations];
    
    
    
    [self.memberNamePopover becomeFirstResponder];
}

@end

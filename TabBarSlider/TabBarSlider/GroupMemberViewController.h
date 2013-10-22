//
//  GroupMemberViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 22/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface GroupMemberViewController : UIViewController <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addWithFacebookButton;
@property (weak, nonatomic) IBOutlet UITextField *friendNumber;
@property (weak, nonatomic) IBOutlet UITextField *friendsAdded;
@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (weak, nonatomic) Group *group;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *mainDoneButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *actionContainer;
@property (weak, nonatomic) IBOutlet UIButton *addFriendsManuallyButton;
@property (weak, nonatomic) IBOutlet UIButton *invitationButton;

@property (weak, nonatomic) IBOutlet UIView *addMemberPopover;
@property (weak, nonatomic) IBOutlet UITextField *memberNamePopover;
@property (weak, nonatomic) IBOutlet UITextField *memberEmailPopover;
@property (strong, nonatomic) NSMutableDictionary *addedMembersPopover;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinnerPopover;

- (IBAction)addMemberPopover:(id)sender;
- (IBAction)doneAddMemberPopover:(id)sender;
- (IBAction)cancelAddMemberPopover:(id)sender;

- (IBAction)done:(id)sender;
- (IBAction)addVirtualMember:(id)sender;

@end

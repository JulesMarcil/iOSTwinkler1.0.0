//
//  GroupMemberViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 22/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface GroupMemberViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDataSource>  {
}

@property (weak, nonatomic) IBOutlet UITableView *memberSuggestionTableView;
@property (weak, nonatomic) IBOutlet UITableView *memberTableView;
@property (weak, nonatomic) IBOutlet UITextField *memberNameTextField;
@property (strong, nonatomic) Group *group;
@property (strong, nonatomic) NSMutableArray *memberArray;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSString *link;
@property (nonatomic, assign) BOOL hideBack;
@property (weak, nonatomic) IBOutlet UIView *actionBarContainer;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *groupNameTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)manualAddMember:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)doneButton:(id)sender;
- (IBAction)removeMember:(id)sender;

@end

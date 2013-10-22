//
//  GroupMemberViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 22/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface GroupMemberViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *addWithFacebookButton;
@property (weak, nonatomic) IBOutlet UITextField *friendNumber;
@property (weak, nonatomic) IBOutlet UITextField *friendsAdded;
@property (weak, nonatomic) Group *group;

- (IBAction)done:(id)sender;

@end

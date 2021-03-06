//
//  DashboardViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 22/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>//332120

@interface DashboardViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>  {
    IBOutlet UITableView* mainTableView;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSDictionary *dashboardInfo;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *closeGroupButton;
@property (weak, nonatomic) IBOutlet UIButton *removeFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIView *dashboardTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshSpinner;
@property (weak, nonatomic) IBOutlet UIView *spinnerView;

- (IBAction)AddMemberAction:(id)sender;
- (IBAction)CloseGroupAction:(id)sender;

@end

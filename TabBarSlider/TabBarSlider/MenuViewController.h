//
//  MenuViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 02/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDataController.h"
#import "Profile.h"
#import "SWRevealViewController.h"

@class GroupListCell;
@class Profile;

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  {
    IBOutlet UITableView* groupOnMenu;
}

@property (nonatomic, strong) UITableView *groupOnMenu;
@property (nonatomic, strong) GroupDataController *groupDataController;
@property (nonatomic, strong) Profile *profile;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIButton *addGroupButton;
@property (weak, nonatomic) IBOutlet UIView *tableViewHeader;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendNumberLabel;

- (IBAction)goToTimelineButton:(id)sender;
- (IBAction)doneAddGroup:(UIStoryboardSegue *)segue;
- (IBAction)cancelAddGroup:(UIStoryboardSegue *)segue;
- (IBAction)Logout:(id)sender;
- (void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
- (UIImage *)getImageForMember:(NSDictionary *)member;


@end

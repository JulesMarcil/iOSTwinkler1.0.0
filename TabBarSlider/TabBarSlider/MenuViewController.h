//
//  MenuViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 02/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDataController.h"
#import "SWRevealViewController.h"

@class GroupListCell;

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  {
    IBOutlet UITableView* groupOnMenu;
}

@property (nonatomic, strong) UITableView *groupOnMenu;
@property (nonatomic, strong) GroupDataController *groupDataController;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIButton *addGroupButton;
@property (weak, nonatomic) IBOutlet UIView *tableViewHeader;

- (IBAction)doneAddGroup:(UIStoryboardSegue *)segue;
- (IBAction)cancelAddGroup:(UIStoryboardSegue *)segue;

-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
@end

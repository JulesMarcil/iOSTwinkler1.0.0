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

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  {
    IBOutlet UITableView* groupOnMenu;
}

@property (nonatomic, strong) UITableView *groupOnMenu;
@property (nonatomic, strong) GroupDataController *groupDataController;

- (IBAction)doneAddGroup:(UIStoryboardSegue *)segue;
- (IBAction)cancelAddGroup:(UIStoryboardSegue *)segue;


@end

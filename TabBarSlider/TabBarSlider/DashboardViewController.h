//
//  DashboardViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 22/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  {
    IBOutlet UITableView* mainTableView;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSDictionary *dashboardInfo;

- (IBAction)AddMemberAction:(id)sender;

@end

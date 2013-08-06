//
//  TimelineViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineDataController.h"

@class ExpandableNavigation;

@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  {
    IBOutlet UITableView* messageOnTimeline;
    UIButton* button1;
    UIButton* button2;
    UIButton* button3;
    UIButton* button4;
    UIButton* main;
    ExpandableNavigation* navigation;
}

@property (strong, nonatomic) IBOutlet UIButton *main;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) IBOutlet UIButton *button4;
@property (retain) ExpandableNavigation* navigation;

@property (nonatomic, strong) UITableView *messageOnTimeline;
@property (nonatomic, strong) TimelineDataController *messageDataController;
@property (weak, nonatomic) IBOutlet UIView *actionBar;
@property (weak, nonatomic) IBOutlet UITextField *timelineTextBox;

@end
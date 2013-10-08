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

@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>  {
    IBOutlet UITableView* messageOnTimeline;
    UIButton* button1;
    UIButton* button2;
    UIButton* button3;
    UIButton* main;
    ExpandableNavigation* navigation;
}

@property (strong, nonatomic) IBOutlet UIButton *main;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (retain) ExpandableNavigation* navigation;
@property (weak, nonatomic) NSTimer *refreshTimer;

@property (nonatomic, strong) UITableView *messageOnTimeline;
@property (nonatomic, strong) TimelineDataController *messageDataController;
@property (weak, nonatomic) IBOutlet UIView *actionBar;
@property (weak, nonatomic) IBOutlet UIView *timelineTextBoxContainer;
@property (weak, nonatomic) IBOutlet UITextField *timelineTextBox;
@property (strong, nonatomic) IBOutlet UIView *timelineView;
@property (weak, nonatomic) IBOutlet UIButton *smiley;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshSpinner;
@property (weak, nonatomic) IBOutlet UIView *spinnerContainer;

- (IBAction)addExpenseButton:(id)sender;
- (IBAction)addUserButton:(id)sender;
- (IBAction)sendMessage:(id)sender;
- (IBAction)sendFeedbackButton:(id)sender;
- (IBAction)addListButton:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end

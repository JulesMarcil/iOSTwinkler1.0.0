//
//  TabBarViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 01/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface TabBarViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *expenseButton;
@property (weak, nonatomic) IBOutlet UIButton *timelineButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIImageView *activeTabBarImage;
@property (weak, nonatomic) IBOutlet UIButton *revealButtonItem;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;
@property (nonatomic, weak) UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIImageView *coverPic;
@property (weak, nonatomic) IBOutlet UIView *topWhiteBar;
@property (weak, nonatomic) IBOutlet UIView *toolbar;

-(void)goToExpenses;
-(void)goToTimeline;

@end

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
@property (weak, nonatomic) IBOutlet UILabel *groupTitle;
@property (weak, nonatomic) IBOutlet UIButton *expenseButton;
@property (weak, nonatomic) IBOutlet UIButton *timelineButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIView *activeTabBarImage;
@property (weak, nonatomic) IBOutlet UIButton *revealButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *revealRightButtonItem;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;
@property (nonatomic, weak) UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIImageView *coverPic;
@property (weak, nonatomic) IBOutlet UIView *topWhiteBar;
@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (strong, nonatomic) NSArray *memberArray;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *tabBarBck;

-(void)goToExpenses;
-(void)goToTimeline;
-(void)goToList;

@end

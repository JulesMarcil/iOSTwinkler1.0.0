//
//  TimelineViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineDataController.h"

@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  {
    IBOutlet UITableView* messageOnTimeline;
}

@property (nonatomic, strong) UITableView *messageOnTimeline;
@property (nonatomic, strong) TimelineDataController *messageDataController;

@end

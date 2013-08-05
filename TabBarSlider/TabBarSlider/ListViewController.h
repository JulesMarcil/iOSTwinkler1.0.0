//
//  ListViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDataController.h"

@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  {
    IBOutlet UITableView* listOnLists;
}

@property (nonatomic, strong) UITableView *listOnLists;
@property (nonatomic, strong) ListDataController *listDataController;


@end

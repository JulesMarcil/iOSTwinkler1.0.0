//
//  ItemListViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"

@interface ItemListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>  {
    IBOutlet UITableView* itemListTableView;
}

@property (weak, nonatomic) IBOutlet UITableView *itemListTableView;
@property (weak, nonatomic) IBOutlet UIButton *addItemButton;
@property (weak, nonatomic) List *list;
@property (weak, nonatomic) IBOutlet UIView *bottomToolbar;

- (IBAction)backToList:(UIStoryboardSegue *)segue;

@end

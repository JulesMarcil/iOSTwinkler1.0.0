//
//  ListsViewController.h
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 30/07/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListDataController;

@interface ListsViewController : UITableViewController

@property (strong, nonatomic) ListDataController *dataController;

@end

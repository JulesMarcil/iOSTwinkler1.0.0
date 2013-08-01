//
//  ListItemsViewController.h
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 01/08/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListItemsViewController : UITableViewController

@property (nonatomic, strong) NSArray *items;

- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end

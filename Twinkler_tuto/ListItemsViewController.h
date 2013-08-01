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
@property (nonatomic, strong) NSNumber *list_id;

- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end

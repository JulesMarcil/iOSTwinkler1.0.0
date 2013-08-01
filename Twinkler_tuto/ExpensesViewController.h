//
//  ExpensesViewController.h
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 30/07/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExpenseDataController;
@class AFHTTPRequestOperation;

@interface ExpensesViewController : UITableViewController

@property (strong, nonatomic) ExpenseDataController *dataController;

- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end

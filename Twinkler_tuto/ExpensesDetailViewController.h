//
//  ExpensesDetailViewController.h
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 30/07/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Expense;

@interface ExpensesDetailViewController : UITableViewController

@property (strong, nonatomic) Expense *expense;
@property (weak, nonatomic) IBOutlet UILabel *expenseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *membersLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *addedDateLabel;

@end

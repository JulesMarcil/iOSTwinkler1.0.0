//
//  AddExpenseViewController.h
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 31/07/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Expense;

@interface AddExpenseViewController : UITableViewController
<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *expenseNameInput;
@property (weak, nonatomic) IBOutlet UITextField *amountInput;
@property (strong, nonatomic) Expense *expense;

@end

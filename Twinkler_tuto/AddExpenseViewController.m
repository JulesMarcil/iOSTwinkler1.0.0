//
//  AddExpenseViewController.m
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 31/07/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import "AddExpenseViewController.h"
#import "Expense.h"

@interface AddExpenseViewController ()

@end

@implementation AddExpenseViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ((textField == self.expenseNameInput) || (textField == self.amountInput)) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        if ([self.expenseNameInput.text length] || [self.amountInput.text length]) {
            
            //NSString to NSNumber formatter
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *formattedAmount = [f numberFromString:self.amountInput.text];
            
            //Get date of today
            NSDate *today = [NSDate date];
            
            NSDictionary *owner = [[NSDictionary alloc] initWithObjectsAndKeys:@"julio", @"name", @1, @"id", nil];
            NSArray *members = [[NSArray alloc] init];
            
            Expense *expense;
            expense = [[Expense alloc] initWithName:self.expenseNameInput.text
                                             amount:formattedAmount
                                              owner:owner
                                               date:today
                                            members:members
                                             author:@"moi"
                                          addedDate:today];
            self.expense = expense;
        }
    }
}



@end

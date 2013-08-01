//
//  ExpensesDetailViewController.m
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 30/07/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import "ExpensesDetailViewController.h"
#import "Expense.h"

@interface ExpensesDetailViewController ()

@end

@implementation ExpensesDetailViewController

- (void)setExpense:(Expense *) newExpense
{
    if (_expense != newExpense) {
        _expense = newExpense;
        
        //Update the View.
        [self configureView];
    }
}

-(void)configureView
{
    // Update the user interface for the detail expense.
    Expense *theExpense = self.expense;
    
    // convert NSDate to NSString
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    // convert NSArray to NSString
    NSArray *membersArray = theExpense.members;
    NSString *m = @"";
    for(int i=0; i<membersArray.count; i++) {
        m = [m stringByAppendingString:[[membersArray objectAtIndex:i] objectForKey:@"name"]];
        m = [m stringByAppendingString:@", "];
    }
    
    if (theExpense) {
        self.expenseNameLabel.text = theExpense.name;
        self.amountLabel.text = [theExpense.amount stringValue];
        self.ownerLabel.text = theExpense.owner[@"name"];
        self.dateLabel.text = [dateFormatter stringFromDate:theExpense.date];
        self.membersLabel.text = m;
        self.authorLabel.text = theExpense.author;
        self.addedDateLabel.text = [dateFormatter stringFromDate:theExpense.addedDate];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

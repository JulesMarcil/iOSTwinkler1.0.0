//
//  ExpenseDetailViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 06/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "ExpenseDetailViewController.h"
#import "Expense.h"

@interface ExpenseDetailViewController ()

@end

@implementation ExpenseDetailViewController
@synthesize expenseDetailMemberTable=_expenseDetailMemberTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame= [self.navBar frame];
    [self.navBar setFrame:CGRectMake(0, 0, frame.size.width, 44)];
    [self configureLabels];
    [self.expenseDetailMemberTable reloadData];
}

- (void)setExpense:(Expense *)expense
{
    if (_expense != expense) {
        _expense = expense;
        
        //Update the View.
        [self configureLabels];
        [self.expenseDetailMemberTable reloadData];
    }
}

-(void)configureLabels
{
    // Update the user interface for the detail expense.
    Expense *expense = self.expense;
    
    // convert NSDate to NSString
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    if (expense) {
        self.expenseName.text = expense.name;
        self.expenseAmount.text = [expense.amount stringValue];
        self.expenseOwner.text = expense.owner[@"name"];
        self.expenseDate.text = [dateFormatter stringFromDate:expense.date];
        self.expenseAuthor.text = expense.author;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.expense.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"expenseMemberCell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    };
    
    NSDictionary *member = [self.expense.members
                               objectAtIndex:indexPath.row];
    cell.textLabel.text = member[@"name"];

    return cell;
}

- (IBAction)backToExpenseList:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

//
//  ExpenseViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "ExpenseViewController.h"
#import "ExpenseDataController.h"
#import "Expense.h"
#import "AddExpenseViewController.h"
#import "AuthAPIClient.h"
#import "AFHTTPRequestOperation.h"

@interface ExpenseViewController ()

@end

@implementation ExpenseViewController

@synthesize expenseListTable=_expenseListTable;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.expenseDataController = [[ExpenseDataController alloc] init];
}

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
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect frame= [self.expenseListTable frame];
    [self.expenseListTable setFrame:CGRectMake(0,
                                               -20,
                                               frame.size.width,
                                               screenHeight-208)];
    frame= [self.addItemToolbar frame];
    [self.addItemToolbar setFrame:CGRectMake(0,
                                             screenHeight-228,
                                             frame.size.width,
                                             44)];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(dataRetrieved)
     name:@"expensesWithJSONFinishedLoading"
     object:nil];
}

- (void)dataRetrieved {
    [self.expenseListTable reloadData];
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
    return [self.expenseDataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"expenseCell";
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    };
    
    Expense *expenseAtIndex = [self.expenseDataController
                               objectInListAtIndex:indexPath.row];
    [[cell textLabel] setText:expenseAtIndex.name];
    [[cell detailTextLabel] setText:[formatter stringFromDate:(NSDate
                                                               *)expenseAtIndex.date]];
    return cell;
}

- (IBAction)addExpenseButton:(id)sender {
}

- (IBAction)doneAddMember:(UIStoryboardSegue *)segue {
    {
        if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
            AddExpenseViewController *addController = [segue
                                                       sourceViewController];
            if (addController.expense) {
                
                // initialize the expense
                NSDictionary *expense = [NSDictionary dictionaryWithObjectsAndKeys:
                                         addController.expense.name, @"name",
                                         addController.expense.amount, @"amount",
                                         @"an owner_id", @"owner_id",
                                         @"a date", @"date",
                                         @"some member_ids", @"member_ids",
                                         nil];
                
                AuthAPIClient *client = [AuthAPIClient sharedClient];
                
                NSMutableURLRequest *request = [client requestWithMethod:@"POST"
                                                                    path:@"group/app/expenses"
                                                              parameters:expense];
                
                //Add your request object to an AFHTTPRequestOperation
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                                     initWithRequest:request];
                
                [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
                
                [operation setCompletionBlockWithSuccess:
                 ^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSString *response = [operation responseString];
                     NSLog(@"response: %@",response);
                     [self.expenseListTable reloadData];
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"error: %@", [operation error]);
                 }];
                
                //call start on your request operation
                [operation start];
                
                [self.expenseDataController addExpenseWithExpense:addController.expense];
            }
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

- (IBAction)cancelAddMember:(UIStoryboardSegue *)segue{
    if ([[segue identifier] isEqualToString:@"CancelInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}
@end

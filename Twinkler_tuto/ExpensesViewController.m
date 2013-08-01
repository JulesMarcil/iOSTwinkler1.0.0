//
//  ExpensesViewController.m
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 30/07/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import "ExpensesViewController.h"
#import "ExpensesDetailViewController.h"
#import "AddExpenseViewController.h"
#import "ExpenseDataController.h"
#import "Expense.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface ExpensesViewController ()

@end

@implementation ExpensesViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[ExpenseDataController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(dataRetrieved)
     name:@"expensesWithJSONFinishedLoading"
     object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dataRetrieved {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"anExpenseCell";
    
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    Expense *expenseAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    
    cell.textLabel.text = expenseAtIndex.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ €",
                                 (NSString *)expenseAtIndex.owner[@"name"],
                                 (NSString *)expenseAtIndex.amount];
    
   
    
    // Configure the cell...
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"viewExpenseDetail"]) {
        ExpensesDetailViewController *edvc = [segue destinationViewController];
        edvc.expense = [self.dataController objectInListAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if([[segue identifier] isEqualToString:@"ReturnInput"]){
        AddExpenseViewController *aevc = [segue sourceViewController];
        
        if (aevc.expense) {
            
            NSLog(@"%@", aevc.expense.owner);
            
            NSDictionary *expense = [NSDictionary dictionaryWithObjectsAndKeys:
                                     aevc.expense.name, @"name",
                                     aevc.expense.amount, @"amount",
                                     @"an owner_id", @"owner_id",
                                     @"a date", @"date",
                                     @"some member_ids", @"member_ids",
                                     nil];
            
            NSURL *baseURL = [NSURL URLWithString:@"http://localhost:8888/Twinkler1.2.3/web/app_dev.php/group/json/expenses"];
            
            //build normal NSMutableURLRequest objects
            //make sure to setHTTPMethod to "POST".
            //from https://github.com/AFNetworking/AFNetworking
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
            [httpClient defaultValueForHeader:@"Accept"];
            
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                    path:@"http://localhost:8888/Twinkler1.2.3/web/app_dev.php/group/json/expenses" parameters:expense];
            
            //Add your request object to an AFHTTPRequestOperation
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                                  initWithRequest:request];
            
            //"Why don't I get JSON / XML / Property List in my HTTP client callbacks?"
            //see: https://github.com/AFNetworking/AFNetworking/wiki/AFNetworking-FAQ
            //mattt's suggestion http://stackoverflow.com/a/9931815/1004227 -
            //-still didn't prevent me from receiving plist data
            //[httpClient registerHTTPOperationClass:
            //         [AFPropertyListParameterEncoding class]];
            
            [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
            
            [operation setCompletionBlockWithSuccess:
             ^(AFHTTPRequestOperation *operation,
               id responseObject) {
                 NSString *response = [operation responseString];
                 NSLog(@"response: [%@]",response);
                 [[self tableView] reloadData];
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"error: %@", [operation error]);
             }];
            
            //call start on your request operation
            [operation start];
            
            
            [self.dataController addExpenseWithExpense:aevc.expense];
        }
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end

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
#import "ExpenseDetailViewController.h"
#import "AddExpenseViewController.h"
#import "AuthAPIClient.h"
#import "AFHTTPRequestOperation.h"
#import "ExpenseItemCell.h"
#import "DRNRealTimeBlurView.h"
#import <QuartzCore/QuartzCore.h>

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
                                               screenHeight-164)];
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
    ExpenseItemCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    };
    
    Expense *expenseAtIndex = [self.expenseDataController
                               objectInListAtIndex:indexPath.row];
    cell.expenseNameLabel.text=expenseAtIndex.name;
    cell.expenseSubtitleLabel.text=[formatter stringFromDate:(NSDate *)expenseAtIndex.date];
    
    NSString *currency=[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupCurrency"];
    cell.expenseAmountLabel.text=[NSString stringWithFormat:@"%@%@%@", [expenseAtIndex.amount stringValue], @" ",currency];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"viewExpenseSegue"]) {
        ExpenseDetailViewController *edvc = [segue destinationViewController];
        edvc.expense = [self.expenseDataController objectInListAtIndex:[self.expenseListTable indexPathForSelectedRow].row];
    }
}

- (IBAction)addExpenseButton:(id)sender {
}

- (IBAction)doneAddMember:(UIStoryboardSegue *)segue {
    {
        if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
            AddExpenseViewController *addController = [segue
                                                       sourceViewController];
            if (addController.expense) {
                
                
                NSLog(@"selected owner = %@", addController.selectedExpenseOwner);
                
                // initialize the request parameters
                NSString *currentGroupId = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentGroupId"];
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                         addController.expense.name, @"name",
                                         addController.expense.amount, @"amount",
                                         currentGroupId, @"currentGroupId",
                                         addController.selectedExpenseOwner[@"id"], @"owner_id",
                                         [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"][@"id"], @"author_id",
                                         nil];
                
                AuthAPIClient *client = [AuthAPIClient sharedClient];
                
                NSMutableURLRequest *request = [client requestWithMethod:@"POST"
                                                                    path:@"group/app/expenses"
                                                              parameters:parameters];
                
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

- (IBAction)test:(id)sender {
    

    
    
    DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] initWithFrame:CGRectMake(60, 0, 200, 200)];
    [self.viewContainer addSubview:blurView];
    blurView.tag=2;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    whiteView.tag=1;
    whiteView.backgroundColor = [UIColor clearColor];
    [blurView addSubview:whiteView];
    
    UIView *whiteBckView = [[UIView alloc] initWithFrame:CGRectMake(0, 3, 320, 400)];
    whiteBckView.alpha = 0.7;
    whiteBckView.backgroundColor = [UIColor whiteColor];
    [whiteView addSubview:whiteBckView];
    
    CGRect buttonFrame = CGRectMake( 148, 0, 30, 30 );
    UIButton *button = [[UIButton alloc] initWithFrame: buttonFrame];
    [button setImage:[UIImage imageNamed:@"chevron-arrow.png"] forState:UIControlStateNormal];
    [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
    [whiteView addSubview:button];
    [button addTarget:self action:@selector(dismissDetails) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *border = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    border.image = [UIImage imageNamed:@"expense-detail-border.png"];
    [whiteView addSubview:border];
    
    
    UIColor *textColor = [UIColor colorWithRed:(65/255.0) green:(65/255.0) blue:(65/255.0) alpha:1] ;
    
    UILabel *expenseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, 20)];
    
    [expenseNameLabel setTextColor:textColor];
    [expenseNameLabel setBackgroundColor:[UIColor clearColor]];
    [expenseNameLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Bold" size: 18.0f]];
    expenseNameLabel.text=@"Essence/Peage aller";
    expenseNameLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:expenseNameLabel];
    
    UILabel *expenseDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 70, 320, 20)];
    
    [expenseDescLabel setTextColor:textColor];
    [expenseDescLabel setBackgroundColor:[UIColor clearColor]];
    [expenseDescLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Regular" size: 14.0f]];
    expenseDescLabel.text=@"Julio paid 130€ on Aug 7th";
    expenseDescLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:expenseDescLabel];
    
    UILabel *expenseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 90, 320, 20)];
    
    [expenseDateLabel setTextColor:textColor];
    [expenseDateLabel setBackgroundColor:[UIColor clearColor]];
    [expenseDateLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 14.0f]];
    expenseDateLabel.text=@"Your share: 26€";
    expenseDateLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:expenseDateLabel];
    
    UIImageView *ownerPic = [[UIImageView alloc] initWithFrame:CGRectMake(20, 70, 41, 37)];
    ownerPic.image = [UIImage imageNamed:@"sasa.png"];
    [whiteView addSubview:ownerPic];
    
    
    UIColor *borderColor = [UIColor colorWithRed:(200/255.0) green:(200/255.0) blue:(200/255.0) alpha:1] ;
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame: CGRectMake(-1, 210, 161, 40)];
    [editBtn setTitleColor: textColor forState: UIControlStateNormal];
    [editBtn.layer setBorderColor:borderColor.CGColor];
    [editBtn.layer setBorderWidth:1.0];
    [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 16.0f];
    [whiteView addSubview:editBtn];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame: CGRectMake(159, 210, 161, 40)];
    [deleteBtn setTitleColor: textColor forState: UIControlStateNormal];
    [deleteBtn.layer setBorderColor:borderColor.CGColor];
    [deleteBtn.layer setBorderWidth:1.0];
    [deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 16.0f];
    [whiteView addSubview:deleteBtn];
    
    UILabel *expenseAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 265, 180, 20)];
    
    [expenseAuthorLabel setTextColor:textColor];
    [expenseAuthorLabel setBackgroundColor:[UIColor clearColor]];
    [expenseAuthorLabel setFont:[UIFont fontWithName: @"HelveticaNeue-LightItalic" size: 12.0f]];
    expenseAuthorLabel.text=@"Added by Julio on Aug 8th";
    expenseAuthorLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:expenseAuthorLabel];
    
    blurView.frame = CGRectMake(0, 1000, 320, 400);
    [UIView animateWithDuration:0.5
                     animations:^{
                         blurView.frame = CGRectMake(0, 0, 320, 400);
                     }];
    whiteView.frame = CGRectMake(0, 1000, 320, 400);
    [UIView animateWithDuration:0.5
                     animations:^{
                         whiteView.frame = CGRectMake(0, 0, 320, 400);
                     }];
    
}

-(void)dismissDetails {
    
    [self.view viewWithTag:1].frame = CGRectMake(0, 0, 320, 400);
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view viewWithTag:1].frame = CGRectMake(0, 1000, 320, 400);
                     }];
    [self.view viewWithTag:2].frame = CGRectMake(0, 0, 320, 400);
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view viewWithTag:2].frame = CGRectMake(0, 1000, 320, 400);
                     }];
}

@end

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
#import "UIImageView+AFNetworking.h"
#import "ExpenseItemCell.h"
#import "TabBarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ExpenseDetailViewController.h"

@interface ExpenseViewController ()

@end

@implementation ExpenseViewController

@synthesize expenseListTable=_expenseListTable;

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"awakefromNib from ExpenseViewController");
    self.spinnerView.hidden = NO;
    self.expenseDataController = [[ExpenseDataController alloc] init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.screenName = @"ExpenseVC";
    [self setBalanceLabelValue:self.expenseDataController.balance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataRetrieved)    name:@"expensesWithJSONFinishedLoading"    object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadError)    name:@"expensesWithJSONFailedLoading"      object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataRefreshError) name:@"expensesWithJSONFailedRefreshing"   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addExpense:)      name:@"expenseAddedSuccesfully"            object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeExpense:)   name:@"expenseRemovedSuccesfully"          object:nil];
    
    self.expenseListTable.allowsSelectionDuringEditing = YES;
    self.expenseListTable.separatorColor = [UIColor clearColor];
    self.view.backgroundColor=[UIColor colorWithRed:(247/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    self.headerViewContainer.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect frame= [self.view frame];
    
    frame= [self.expenseListTable frame];
    [self.expenseListTable setFrame:CGRectMake(0,
                                               0,
                                               frame.size.width,
                                               screenHeight-164+24+100)];
    
    frame= [self.timelineImage frame];
    [self.timelineImage setFrame:CGRectMake(frame.origin.x,
                                               0,
                                               4,
                                            screenHeight)];
    
    frame= [self.addExpenseBck frame];
    [self.addExpenseBck setFrame:CGRectMake(frame.origin.x,
                                             screenHeight-60,
                                             320,
                                             frame.size.height)];
    frame= [self.addExpenseView frame];
    [self.addExpenseView setFrame:CGRectMake(frame.origin.x,
                                             screenHeight-49,
                                             240,
                                             41)];
    
    self.addExpenseView.layer.masksToBounds = YES;
    self.addExpenseView.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.addExpenseView.layer.borderWidth = 1.0f;
    
    self.spinnerView.layer.cornerRadius = 10;
    
    self.balanceContainer.layer.cornerRadius = 3;
    self.balanceContainer.layer.masksToBounds = NO;
    self.balanceContainer.layer.shadowOffset = CGSizeMake(0, 0.6);
    self.balanceContainer.layer.shadowRadius = 1.2;
    self.balanceContainer.layer.shadowOpacity = 0.1;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.expenseListTable addSubview:refreshControl];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"ExpenseVC";
}


- (void)refresh:(UIRefreshControl *)refreshControl {
    NSLog(@"refresh function called");
    [refreshControl endRefreshing];
    self.spinnerView.hidden = NO;
    [self.expenseDataController refreshData];
}

- (void)dataRetrieved {
    NSLog(@"dataretrieved in expense");
    [self.expenseListTable reloadData];
    [self setBalanceLabelValue:self.expenseDataController.balance];
    self.spinnerView.hidden = YES;
}

- (void)dataLoadError {
    NSLog(@"dataLoadError in expense");
    self.spinnerView.hidden = YES;
}

- (void)dataRefreshError {
    NSLog(@"dataRefreshError in expense");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"Impossible to refresh expenses, make sure you are connected"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    self.spinnerView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// data management function
- (void)setBalanceLabelValue:(NSNumber *)balance {
    
    if ([balance intValue] > 0) {
        self.balanceLabel.text = [NSString stringWithFormat:@"+%g", [balance doubleValue]];
    } else {
        self.balanceLabel.text = [NSString stringWithFormat:@"%g", [balance doubleValue]];
    }
}

- (void)addExpense:(NSNotification *)note{
    
    NSLog(@"add expense function called");
    
    [self.expenseDataController addExpenseWithExpense:[[note userInfo] valueForKey:@"expense"] atIndex:0];
    [self setBalanceLabelValue:[[note userInfo] valueForKey:@"balance"]];
    [self.expenseListTable reloadData];
}

- (void)removeExpense:(NSNotification *)note{
    
    NSLog(@"remove expense function called");
    
    [self.expenseDataController removeExpenseWithExpense:[[note userInfo] valueForKey:@"expense"]];
    [self setBalanceLabelValue:[[note userInfo] valueForKey:@"balance"]];
    [self.expenseListTable reloadData];
}
// end of data management function

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.expenseDataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"expenseCell";
    
    static NSDateFormatter *formatter = nil;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    ExpenseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor=[UIColor clearColor];
    
    if (cell == nil){
        cell = (ExpenseItemCell*) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    };
    
    //Set expense
    Expense *expenseAtIndex = [self.expenseDataController objectInListAtIndex:indexPath.row];
    
    //Set picture
    NSString *path = expenseAtIndex.owner[@"picturePath"];
    NSNumber *facebookId= [[[NSNumberFormatter alloc] init] numberFromString:path];
    
    NSURL *url;
    if (facebookId) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", facebookId]];
    } else if(![path isEqualToString:@"local"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", appBaseURL, path]];
    }
    
    if(url) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [cell.memberProfilePic setImageWithURLRequest:request
                                     placeholderImage:[UIImage imageNamed:@"profile-pic.png"]
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  cell.memberProfilePic.image = image;
                                                  [cell.memberProfilePic setFrame:CGRectMake(19,14,30,30)];
                                                  [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:30.0];
                                              }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  NSLog(@"Failed with error: %@", error);
                                              }];
    } else {
        cell.memberProfilePic.image = [UIImage imageNamed:@"profile-pic.png"];
    }
    
    [cell.memberProfilePic setFrame:CGRectMake(21,17,30,30)];
    [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:30.0];
    
    
    //Set labels
    cell.self.expenseNameLabel.text = expenseAtIndex.name;
    
    NSDictionary *currency=[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupCurrency"];
    cell.expenseSubtitleLabel.text=[NSString stringWithFormat:@"%@ paid %@ %g - %@", expenseAtIndex.owner[@"name"], currency[@"symbol"], [expenseAtIndex.amount doubleValue], [formatter stringFromDate:(NSDate *)expenseAtIndex.date]];
    
    if ([expenseAtIndex.owner[@"name"] isEqual: @"You"]) {
        cell.getLabel.text = @"You get";
        cell.shareLabel.text = [NSString stringWithFormat:@"%@ %g", currency[@"symbol"], [expenseAtIndex.share doubleValue]];
        cell.shareLabel.textColor = [UIColor colorWithRed:(116/255.0) green:(178/255.0) blue:(20/255.0) alpha: 1];
    } else {
        cell.getLabel.text = @"You owe";
        if ([expenseAtIndex.share doubleValue] == 0) {
            cell.shareLabel.text = [NSString stringWithFormat:@"%@ 0", currency[@"symbol"]];
        } else {
            cell.shareLabel.text = [NSString stringWithFormat:@"%@ %g", currency[@"symbol"], ([expenseAtIndex.share doubleValue]*-1)];
        }
        cell.shareLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(146/255.0) blue:(123/255.0) alpha: 1];
    }
    
    cell.cellSeparatorView.backgroundColor = [UIColor colorWithRed:(236/255.0) green:(231/255.0) blue:(223/255.0) alpha: 1];
    return cell;
}


- (IBAction)addExpenseButton:(id)sender {
    NSLog(@"addexpensebutton from expenseviewcontroller");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"expenseDetailSegue"]){
        
        NSIndexPath *indexPath = [self.expenseListTable indexPathForCell:sender];
        Expense *expenseAtIndex = [self.expenseDataController objectInListAtIndex:indexPath.row];
        ExpenseDetailViewController *edvc = [segue destinationViewController];
        edvc.expense = expenseAtIndex;
    }
}

-(void)goToTimeline {
    UIStoryboard *timelineStoryboard=[UIStoryboard storyboardWithName:@"timelineStoryboard" bundle:nil];
    UIViewController *dst=[timelineStoryboard instantiateInitialViewController];
    
    TabBarViewController *tbvc=(TabBarViewController *) self.parentViewController;
    
    for (UIView *view in tbvc.placeholderView.subviews){
        [view removeFromSuperview];
    }
    tbvc.currentViewController =dst;
    [tbvc.placeholderView addSubview:dst.view];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.parentViewController addChildViewController:dst];
    [self.view removeFromSuperview];
    
    [[tbvc.placeholderView layer] addAnimation:animation forKey:@"showSecondViewController"];
    
    CGPoint pt = timelineCGPoint;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    //you can change the setAnimationDuration value, it is in seconds.
    
    CGRect rect = CGRectMake(pt.x, pt.y, tbvc.activeTabBarImage.frame.size.width,tbvc.activeTabBarImage.frame.size.height);
    
    [tbvc.activeTabBarImage setFrame:rect];
    [tbvc.listButton setSelected:NO];
    [tbvc.timelineButton setSelected:YES];
    [tbvc.expenseButton setSelected:NO];
    
    [UIView commitAnimations];
}

-(NSDictionary *)returnObjectFromArray:(NSArray *)array withId:(NSNumber *)identifier {
    
    NSDictionary *member;
    for (int i=0; i < [array count]; i++){
        if([array objectAtIndex:i][@"id"] == identifier){
            member = [array objectAtIndex:i];
        }
    }
    return member;
}

//----------DESIGN----------
-(void) setRoundedView:(UIImageView *)imageView picture: (UIImage *)picture toDiameter:(float)newSize{
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0f);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:100.0] addClip];
    // Draw your image
    CGRect frame=imageView.bounds;
    frame.size.width=newSize;
    frame.size.height=newSize;
    [picture drawInRect:frame];
    
    // Get the image, here setting the UIImageView image
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
}
-(void)setRoundedBorder:(UIImageView *)roundedView toDiameter:(float)newSize; {
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}
@end

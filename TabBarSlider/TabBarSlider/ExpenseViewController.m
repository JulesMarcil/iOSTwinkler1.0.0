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
#import "DRNRealTimeBlurView.h"
#import "TabBarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AddMemberCell.h"
#import "ExpenseDetailViewController.h"

@interface ExpenseViewController ()

@end

@implementation ExpenseViewController

@synthesize expenseListTable=_expenseListTable;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.expenseDataController = [[ExpenseDataController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addExpense:) name:@"expenseAddedSuccesfully" object:nil];
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
                                               screenHeight-164+44+100)];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(dataRetrieved)
     name:@"expensesWithJSONFinishedLoading"
     object:nil];
    
    
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToTimeline)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
    
    self.expenseListTable.allowsSelectionDuringEditing = YES;
    self.expenseListTable.separatorColor = [UIColor clearColor];
}

- (void)dataRetrieved {
    [self.expenseListTable reloadData];
    self.balanceLabel.text = [NSString stringWithFormat:@"%@ %@", self.expenseDataController.balance, [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupCurrency"][@"symbol"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addExpense:(NSNotification *)note{
    
    NSLog(@"add expense function called");
    
    Expense *expense = [[note userInfo] valueForKey:@"expense"];
    [self.expenseDataController addExpenseWithExpense:expense];
    [self.expenseListTable reloadData];
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
        cell = (ExpenseItemCell*) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    };
    
    
    //Set expense
    Expense *expenseAtIndex = [self.expenseDataController
                               objectInListAtIndex:indexPath.row];
    
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
                                                  [cell.memberProfilePic setFrame:CGRectMake(19,14,35,35)];
                                                  [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:35.0];
                                              }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  NSLog(@"Failed with error: %@", error);
                                              }];
    }
    
    [cell.memberProfilePic setFrame:CGRectMake(19,14,35,35)];
    [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:35.0];
    
    //Set labels
    
    cell.self.expenseNameLabel.text=expenseAtIndex.name;
    
    NSDictionary *currency=[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupCurrency"];
    cell.expenseSubtitleLabel.text=[NSString stringWithFormat:@"%@ paid %@ %@ - %@", expenseAtIndex.owner[@"name"],[expenseAtIndex.amount stringValue],currency[@"symbol"], [formatter stringFromDate:(NSDate *)expenseAtIndex.date]];
    
    if ([expenseAtIndex.owner[@"name"] isEqual: @"You"]) {
        cell.getLabel.text = @"You get";
        cell.shareLabel.text = [NSString stringWithFormat:@"%@ %@", expenseAtIndex.share, currency[@"symbol"]];
        cell.shareLabel.textColor = [UIColor colorWithRed:(116/255.0) green:(178/255.0) blue:(20/255.0) alpha: 1];
    } else {
        cell.getLabel.text = @"You owe";
        cell.shareLabel.text = [NSString stringWithFormat:@"%@ %@", expenseAtIndex.share, currency[@"symbol"]];
        cell.shareLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(146/255.0) blue:(123/255.0) alpha: 1];
    }
    
    tableView.backgroundColor=[UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1];
    cell.expenseContainer.backgroundColor=[UIColor whiteColor];
    cell.expenseContainer.layer.cornerRadius = 3;
    cell.expenseContainer.layer.masksToBounds = NO;
    cell.expenseContainer.layer.shadowOffset = CGSizeMake(0, 0.6);
    cell.expenseContainer.layer.shadowRadius = 0.8;
    cell.expenseContainer.layer.shadowOpacity = 0.1;
    
    return cell;
}


- (IBAction)addExpenseButton:(id)sender {
    // to be kept for link to storyboard ...
}

- (IBAction)cancelAddMember:(UIStoryboardSegue *)segue{
    if ([[segue identifier] isEqualToString:@"CancelInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"expenseDetailSegue"]){
        
        NSIndexPath *indexPath = [self.expenseListTable indexPathForCell:sender];
        Expense *expenseAtIndex = [self.expenseDataController objectInListAtIndex:indexPath.row];
        ExpenseDetailViewController *edvc = [segue destinationViewController];
        edvc.expense = expenseAtIndex;
    }
}

-(void)goToTimeline{
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

-(NSDictionary *) returnObjectFromArray:(NSArray *)array withId:(NSNumber *)identifier {
    
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
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    
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

@end

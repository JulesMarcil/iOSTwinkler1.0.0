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
                                               screenHeight-164+44)];
    frame= [self.addItemToolbar frame];
    [self.addItemToolbar setFrame:CGRectMake(0,
                                             screenHeight-228+44,
                                             frame.size.width,
                                             44)];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(dataRetrieved)
     name:@"expensesWithJSONFinishedLoading"
     object:nil];
    
    
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToTimeline)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
    

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
        cell = (ExpenseItemCell*) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    };
    
    Expense *expenseAtIndex = [self.expenseDataController
                               objectInListAtIndex:indexPath.row];
    cell.expenseNameLabel.text=expenseAtIndex.name;
    cell.expenseSubtitleLabel.text=[formatter stringFromDate:(NSDate *)expenseAtIndex.date];
    
    NSString *currency=[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupCurrency"];
    cell.expenseAmountLabel.text=[NSString stringWithFormat:@"%@%@%@", [expenseAtIndex.amount stringValue], @" ",currency];
    
    //Set picture
    NSArray *memberArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupMembers"];
    NSNumber *memberId = expenseAtIndex.owner[@"id"];
    
    NSDictionary *member = [self returnObjectFromArray:memberArray
                                                withId:memberId];
    NSLog(@"member = %@", member);
    
    NSString *path = member[@"picturePath"];
    NSNumber *facebookId= [[[NSNumberFormatter alloc] init] numberFromString:path];
    
    NSURL *url;
    if (facebookId) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", facebookId]];
    } else if(![path isEqualToString:@"local"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8888/Twinkler1.2.3/web/%@", path]];
    }
    
    if(url) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSLog(@"%@", url);
        
        [cell.memberProfilePic setImageWithURLRequest:request
                                     placeholderImage:[UIImage imageNamed:@"profile-pic.png"]
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  cell.memberProfilePic.image = image;
                                                  [cell.memberProfilePic setFrame:CGRectMake(18,12,35,35)];
                                                  [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:35.0];
                                              }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  NSLog(@"Failed with error: %@", error);
                                              }];
    }
    
    [cell.memberProfilePic setFrame:CGRectMake(18,12,35,35)];
    [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:35.0];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self showExpenseDetail:[self.expenseDataController objectInListAtIndex:indexPath.row] ];
}

- (IBAction)addExpenseButton:(id)sender {
}

- (IBAction)doneAddMember:(UIStoryboardSegue *)segue {
    {
        if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
            AddExpenseViewController *addController = [segue sourceViewController];
            if (addController.expense) {
                
                //create selected member ids array
                NSMutableArray *selectedIds = [[NSMutableArray alloc] init];
                for(NSDictionary *member in addController.expense.members){
                    [selectedIds addObject:member[@"id"]];
                }
                
                
                // initialize the request parameters
                NSString *currentGroupId = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentGroupId"];
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                         addController.expense.name, @"name",
                                         addController.expense.amount, @"amount",
                                         currentGroupId, @"currentGroupId",
                                         addController.selectedExpenseOwner[@"id"], @"owner_id",
                                         selectedIds, @"member_ids",
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

- (void)showExpenseDetail:(Expense*)expense {
    
    DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] initWithFrame:CGRectMake(0, 1000, 320, 400)];
    [self.viewContainer addSubview:blurView];
    blurView.tag=2;
    
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 1000, 320, 400)];
    whiteView.tag=1;
    whiteView.backgroundColor = [UIColor clearColor];
    [blurView addSubview:whiteView];
    
    UIView *whiteBckView = [[UIView alloc] initWithFrame:CGRectMake(0, 3, 320, 400)];
    whiteBckView.alpha = 0.7;
    whiteBckView.backgroundColor = [UIColor whiteColor];
    [whiteView addSubview:whiteBckView];
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, -400, 320, 167)];
    darkView.alpha = 0.5;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 3;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDetails)] ;
    [darkView addGestureRecognizer:tapGesture];
    [self.view.superview.superview addSubview:darkView];
    [self.view.superview.superview bringSubviewToFront:darkView];
    
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDetails)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view.superview.superview addGestureRecognizer:swipeDownGestureRecognizer];
    
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
    expenseNameLabel.text=expense.name;
    expenseNameLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:expenseNameLabel];
    
    UILabel *expenseDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 70, 320, 20)];
    
    [expenseDescLabel setTextColor:textColor];
    [expenseDescLabel setBackgroundColor:[UIColor clearColor]];
    [expenseDescLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Regular" size: 14.0f]];
    expenseDescLabel.text=[NSString stringWithFormat:@"%@ %@ %@ %@",expense.owner[@"name"],@"paid",expense.amount,@"€"];
    expenseDescLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:expenseDescLabel];
    
    UILabel *expenseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 90, 320, 20)];
    
    [expenseDateLabel setTextColor:textColor];
    [expenseDateLabel setBackgroundColor:[UIColor clearColor]];
    [expenseDateLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 14.0f]];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM d, yyy";
    expenseDateLabel.text=[NSString stringWithFormat:@"%@ %@",@"Your Share: 26€ - on",[dateFormatter stringFromDate:expense.date]];
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
    
    UILabel *expenseAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 265, 180, 20)];
    
    [expenseAuthorLabel setTextColor:textColor];
    [expenseAuthorLabel setBackgroundColor:[UIColor clearColor]];
    [expenseAuthorLabel setFont:[UIFont fontWithName: @"HelveticaNeue-LightItalic" size: 12.0f]];
    expenseAuthorLabel.text=[NSString stringWithFormat:@"%@ %@ %@ %@",@"Added by",expense.author,@"on",[dateFormatter stringFromDate:expense.date]];
    expenseAuthorLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:expenseAuthorLabel];

    
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    blurView.frame = CGRectMake(0, 0, 320, 400);
    whiteView.frame = CGRectMake(0, 0, 320, 400);
    darkView.frame=CGRectMake(0, 0, 320, 167);
    darkView.alpha = 0.5;
    [UIView commitAnimations];
    
}

-(void)dismissDetails {
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:1].frame = CGRectMake(0, 1000, 320, 400);
    [self.view viewWithTag:2].frame = CGRectMake(0, 1000, 320, 400);
    [self.view.superview.superview viewWithTag:3].alpha=0;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeDetailsViews:)];
    [UIView commitAnimations];
}

- (void)removeDetailsViews:(id)object {
    [[self.view viewWithTag:1] removeFromSuperview];
    [[self.view viewWithTag:2] removeFromSuperview];
    [[self.view.superview.superview viewWithTag:3] removeFromSuperview];
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
    
    CGPoint pt = {107,0};
    
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

-(NSDictionary *) returnObjectFromArray:(NSArray *)array withId:(NSNumber *)identifier {
    
    NSDictionary *member;
    for (int i=0; i < [array count]; i++){
        if([array objectAtIndex:i][@"id"] == identifier){
            member = [array objectAtIndex:i];
        }
    }
    return member;
}

@end

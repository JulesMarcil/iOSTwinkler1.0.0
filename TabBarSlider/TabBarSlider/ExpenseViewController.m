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
#import "AddMemberCell.h"
#import "ExpenseDetailViewController.h"

@interface ExpenseViewController ()

@end

@implementation ExpenseViewController

@synthesize expenseListTable=_expenseListTable;

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"awakefromNib from ExpenseViewController");
    [self.refreshSpinner startAnimating];
    self.expenseDataController = [[ExpenseDataController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addExpense:) name:@"expenseAddedSuccesfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeExpense:) name:@"expenseRemovedSuccesfully" object:nil];
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
    [self setBalanceLabelValue:self.expenseDataController.balance];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(dataRetrieved)
     name:@"expensesWithJSONFinishedLoading"
     object:nil];
    
    self.expenseListTable.allowsSelectionDuringEditing = YES;
    self.expenseListTable.separatorColor = [UIColor clearColor];
    self.view.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    self.headerViewContainer.backgroundColor=[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect frame= [self.view frame];
    
    frame= [self.expenseListTable frame];
    [self.expenseListTable setFrame:CGRectMake(0,
                                               -20,
                                               frame.size.width,
                                               screenHeight-164+44+100-44)];
    
    frame= [self.timelineImage frame];
    [self.timelineImage setFrame:CGRectMake(frame.origin.x,
                                               0,
                                               4,
                                            screenHeight-64)];
    
    frame= [self.addExpenseView frame];
    [self.addExpenseView setFrame:CGRectMake(frame.origin.x,
                                            screenHeight-64,
                                            321,
                                            frame.size.height)];
    
    self.addExpenseView.layer.masksToBounds = YES;
    self.addExpenseView.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.addExpenseView.layer.borderWidth = 1.0f;
}

- (void)dataRetrieved {
    [self.expenseListTable reloadData];
    [self setBalanceLabelValue:self.expenseDataController.balance];
    [self.refreshSpinner stopAnimating];
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
    [self.refreshSpinner stopAnimating];
}

- (void)removeExpense:(NSNotification *)note{
    
    NSLog(@"remove expense function called");
    
    [self.expenseDataController removeExpenseWithExpense:[[note userInfo] valueForKey:@"expense"]];
    [self setBalanceLabelValue:[[note userInfo] valueForKey:@"balance"]];
    [self.expenseListTable reloadData];
    [self.refreshSpinner stopAnimating];
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
    cell.expenseSubtitleLabel.text=[NSString stringWithFormat:@"%@ paid %@ %@ - %@", expenseAtIndex.owner[@"name"], currency[@"symbol"], [expenseAtIndex.amount stringValue], [formatter stringFromDate:(NSDate *)expenseAtIndex.date]];
    
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
    [self.refreshSpinner stopAnimating];
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

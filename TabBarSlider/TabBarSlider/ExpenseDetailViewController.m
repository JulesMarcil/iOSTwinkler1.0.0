//
//  ExpenseDetailViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/09/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "ExpenseDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Expense.h"
#import "UIImageView+AFNetworking.h"
#import "AuthAPIClient.h"
#import "AddMemberCell.h"

@interface ExpenseDetailViewController ()

@end

@implementation ExpenseDetailViewController

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
    
    //Set picture
    NSString *path = self.expense.owner[@"picturePath"];
    NSNumber *facebookId= [[[NSNumberFormatter alloc] init] numberFromString:path];
    
    NSURL *url;
    if (facebookId) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", facebookId]];
    } else if(![path isEqualToString:@"local"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", appBaseURL, path]];
    }
    
    if(url) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSLog(@"%@", url);
        
        [self.ownerPic setImageWithURLRequest:request
                             placeholderImage:[UIImage imageNamed:@"profile-pic.png"]
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          self.ownerPic.image = image;
                                          [self setRoundedView:self.ownerPic picture:self.ownerPic.image toDiameter:35.0];
                                      }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                          NSLog(@"Failed with error: %@", error);
                                      }];
    }
    
    [self.ownerPic setFrame:CGRectMake(40,102,35,35)];
    [self setRoundedView:self.ownerPic picture:self.ownerPic.image toDiameter:35.0];
    
    //set labels
    self.expenseNameLabel.text = self.expense.name;
    
    NSDictionary *currency=[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupCurrency"];
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    self.expenseOwnerLabel.text = [NSString stringWithFormat:@"%@ paid %@ %@",self.expense.owner[@"name"],currency[@"symbol"], [self.expense.amount stringValue]];
    self.expenseDateLabel.text = [formatter stringFromDate:(NSDate *)self.expense.date];
    
    if ([self.expense.owner[@"name"] isEqual: @"You"]) {
        self.getLabel.text = @"You get";
        self.shareLabel.text = [NSString stringWithFormat:@"%@ %@", currency[@"symbol"], self.expense.share];
        self.shareLabel.textColor = [UIColor colorWithRed:(116/255.0) green:(178/255.0) blue:(20/255.0) alpha: 1];
    } else {
        self.getLabel.text = @"You owe";
        if ([self.expense.share doubleValue] == 0) {
            self.shareLabel.text = [NSString stringWithFormat:@"%@ 0", currency[@"symbol"]];
        } else {
            self.shareLabel.text = [NSString stringWithFormat:@"%@ %@", currency[@"symbol"], [NSNumber numberWithDouble:([self.expense.share doubleValue]*-1)]];
        }
        self.shareLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(146/255.0) blue:(123/255.0) alpha: 1];
    }
    
    self.expenseMembersLabel.text = [NSString stringWithFormat:@"Friends involved (%lu)", (unsigned long)self.expense.members.count];
    self.expenseAuthorLabel.text=[NSString stringWithFormat:@"Added by %@", self.expense.owner[@"name"]];
    
    CGRect frame= [self.actionBarView frame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.actionBarView setFrame:CGRectMake(frame.origin.x,
                                            screenRect.size.height-frame.size.height-50,
                                            frame.size.width,
                                            frame.size.height)];
    
    frame= [self.expenseAuthorLabel frame];
    [self.expenseAuthorLabel setFrame:CGRectMake(frame.origin.x,
                                                 screenRect.size.height-frame.size.height-25,
                                                 frame.size.width,
                                                 frame.size.height)];
    
    frame= [self.memberTableView frame];
    [self.memberTableView setFrame:CGRectMake(frame.origin.x,
                                              185,
                                              frame.size.width,
                                              176)];
    
    UIColor *borderColor = [UIColor colorWithRed:(200/255.0) green:(200/255.0) blue:(200/255.0) alpha:1] ;
    UIColor *textColor = [UIColor colorWithRed:(65/255.0) green:(65/255.0) blue:(65/255.0) alpha:1] ;
    
    [self.editBtn setTitleColor: textColor forState: UIControlStateNormal];
    [self.editBtn.layer  setBorderColor:borderColor.CGColor];
    [self.editBtn.layer  setBorderWidth:1.0];
    
    [self.deleteBtn setTitleColor: textColor forState: UIControlStateNormal];
    [self.deleteBtn.layer  setBorderColor:borderColor.CGColor];
    [self.deleteBtn.layer  setBorderWidth:1.0];
    
    self.memberTableView.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.8];
    self.memberTableView.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.memberTableView.layer.borderWidth = 1.0f;
    
    //-----ScrollView------//
    frame= [self.scrollView frame];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.tag=10;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+screenHeight);
    [self.containerView setFrame:CGRectMake(self.containerView.frame.origin.x,
                                            self.containerView.frame.origin.y+screenHeight,
                                            self.containerView.frame.size.width,
                                            self.containerView.frame.size.height)];
    
    [self.scrollView setContentOffset:CGPointMake(0,screenHeight) animated:YES];
    self.scrollView.bounces=YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor=[UIColor clearColor];
    self.view.backgroundColor=[UIColor clearColor];
    self.containerView.backgroundColor=[UIColor clearColor];
    
    
    UIGraphicsBeginImageContextWithOptions([[UIScreen mainScreen] bounds].size, NO, 0.0f);
    UIViewController *VC=[self presentingViewController];
    [VC.view.layer setFrame:VC.view.layer.frame];
    [VC.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:viewImage];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.memberTableView flashScrollIndicators];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
        if (self.scrollView.contentOffset.y<1) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    CGFloat pageHeight = self.view.frame.size.height;
    
    if(self.scrollView.contentOffset.y<-pageHeight/4){
        self.view.backgroundColor = [UIColor clearColor];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editExpense:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteExpense:(id)sender {
    
    [self showConfirmAlert];
}

- (IBAction)dismissDetail:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showConfirmAlert
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Please, confirm"];
    [alert setMessage:@"Are you sure you want to delete this expense?"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSDictionary *parameters = [NSDictionary dictionaryWithObjects:@[self.expense.identifier, [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"][@"id"]]
                                    forKeys:@[@"id", @"currentMemberId"]];
        
        [[AuthAPIClient sharedClient] postPath:@"api/delete/expense"
                                    parameters:parameters
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           NSError *error = nil;
                                           NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                           NSLog(@"success, new balance =  %@", response[@"balance"]);
                                           
                                           NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
                                           [format setNumberStyle:NSNumberFormatterDecimalStyle];
                                           [format setRoundingMode:NSNumberFormatterRoundHalfUp];
                                           [format setMaximumFractionDigits:2];
                                           NSNumber *balance = [NSNumber numberWithFloat:[response[@"balance"] floatValue]];
                                           
                                           NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:@[self.expense, balance] forKeys:@[@"expense", @"balance"]];
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"expenseRemovedSuccesfully" object:nil userInfo:dictionary];
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"error: %@", error);
                                       }];
    }
    else if (buttonIndex == 1)
    {
        // No
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.expense.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"memberCell";
    AddMemberCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (!cell) {
        cell = (AddMemberCell*) [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                       reuseIdentifier:  CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *memberAtIndex = [self.expense.members objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = memberAtIndex[@"name"];
    
    NSString *path = memberAtIndex[@"picturePath"];
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
                                                  [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:25.0];
                                              }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  NSLog(@"Failed with error: %@", error);
                                              }];
    }
    
    return cell;
    
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

@end

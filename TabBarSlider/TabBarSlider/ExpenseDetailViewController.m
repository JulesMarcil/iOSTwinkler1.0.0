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
                                                  [self.ownerPic setFrame:CGRectMake(19,14,35,35)];
                                                  [self setRoundedView:self.ownerPic picture:self.ownerPic.image toDiameter:35.0];
                                              }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  NSLog(@"Failed with error: %@", error);
                                              }];
    }
    
    [self.ownerPic setFrame:CGRectMake(19,14,35,35)];
    [self setRoundedView:self.ownerPic picture:self.ownerPic.image toDiameter:35.0];
    
    //set labels
    self.expenseNameLabel.text = self.expense.name;
 
    NSDictionary *currency=[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupCurrency"];
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }

    self.expenseOwnerLabel.text = [NSString stringWithFormat:@"%@ paid %@ %@",self.expense.owner[@"name"], [self.expense.amount stringValue],currency[@"symbol"]];
    self.expenseDateLabel.text = [formatter stringFromDate:(NSDate *)self.expense.date];
    
    if ([self.expense.owner[@"name"] isEqual: @"You"]) {
        self.getLabel.text = @"You get";
        self.shareLabel.text = [NSString stringWithFormat:@"%@ %@", self.expense.share, currency[@"symbol"]];
        self.shareLabel.textColor = [UIColor colorWithRed:(116/255.0) green:(178/255.0) blue:(20/255.0) alpha: 1];
    } else {
        self.getLabel.text = @"You owe";
        self.shareLabel.text = [NSString stringWithFormat:@"%@ %@", self.expense.share, currency[@"symbol"]];
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
                                                 frame.size.height,
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
    
    
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDetail:)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGestureRecognizer];
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
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.expense.identifier, @"id", nil];
    
    [[AuthAPIClient sharedClient] postPath:@"api/delete/expense"
                                parameters:parameters
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSError *error = nil;
                                       NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                       
                                       NSLog(@"success: %@", response[@"message"]);
                                       
                                       NSDictionary *dictionary = [NSDictionary dictionaryWithObject:self.expense forKey:@"expense"];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"expenseRemovedSuccesfully" object:nil userInfo:dictionary];
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"error: %@", error);
                                   }];

    
    
}

- (IBAction)dismissDetail:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

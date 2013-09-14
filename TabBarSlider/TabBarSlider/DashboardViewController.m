//
//  DashboardViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 22/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "DashboardViewController.h"
#import "AuthAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "DashboardMemberCell.h"
#import "Group.h"
#import "AddGroupViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DashboardViewController ()

@end

@implementation DashboardViewController

@synthesize mainTableView=_mainTableView;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    //Set notification listener for new group selected
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDashboardInfo) name:@"newGroupSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDashboardInfo) name:@"expenseAddedSuccesfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDashboardInfo) name:@"expenseRemovedSuccesfully" object:nil];
    
    //load data
    [self loadDashboardInfo];
    
}

- (void) loadDashboardInfo{
    
    //load dashboard info
    NSNumber *currentMemberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"][@"id"];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:currentMemberId, @"currentMemberId", nil];
    
    [[AuthAPIClient sharedClient] getPath:@"api/dashboard"
                               parameters:parameters
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError *error = nil;
                                      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      
                                      self.dashboardInfo = response;
                                      [self.mainTableView reloadData];
                                      NSLog(@"dashboard info loaded");
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                  }];
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
	// Do any additional setup after loading the view.
    
    self.mainTableView.separatorColor=[UIColor colorWithRed:(236/255.0) green:(231/255.0) blue:(223/255.0) alpha: 1];
    
    
    self.actionButton.layer.masksToBounds = YES;
    self.actionButton.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.actionButton.layer.borderWidth = 1.0f;
    self.closeGroupButton.layer.masksToBounds = YES;
    self.closeGroupButton.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.closeGroupButton.layer.borderWidth = 1.0f;
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dashboardInfo[@"members"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"memberCell";
    DashboardMemberCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (!cell) {
        cell = (DashboardMemberCell*) [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                      reuseIdentifier:  CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *memberAtIndex = [self.dashboardInfo[@"members"] objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = memberAtIndex[@"name"];
    
    NSDictionary *currency=[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupCurrency"];
    NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    [format setRoundingMode:NSNumberFormatterRoundHalfUp];
    [format setMaximumFractionDigits:2];
    NSNumber *balance = [NSNumber numberWithFloat:[memberAtIndex[@"balance"] floatValue]];
    
    cell.balanceLabel.text = [NSString stringWithFormat:@"%@ %@", [balance stringValue] ,currency[@"symbol"]];
    
    
    if ([balance doubleValue]> 0) {
        cell.balanceLabel.textColor = [UIColor colorWithRed:(116/255.0) green:(178/255.0) blue:(20/255.0) alpha: 1];
    } else if ([balance doubleValue] < 0) {
        cell.balanceLabel.textColor = [UIColor colorWithRed:(202/255.0) green:(73/255.0) blue:(60/255.0) alpha: 1];
    } else {
        cell.balanceLabel.textColor = [UIColor colorWithRed:(60/255.0) green:(60/255.0) blue:(60/255.0) alpha: 1];
    }
    
    cell.balanceContainerView.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha: 0.6];
    cell.balanceContainerView.layer.cornerRadius = 10;
    cell.balanceContainerView.layer.masksToBounds = YES;
    
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
    } else {
        cell.memberProfilePic.image = [UIImage imageNamed:@"profile-pic.png"];
    }
    
    [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:25.0];

    return cell;    
}

- (IBAction)AddMemberAction:(id)sender {
    
    UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"AddGroupStoryboard" bundle:nil] instantiateInitialViewController];
    
    Group *group = [[Group alloc] initWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupName"]
                                    identifier:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupId"]
                                       members:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupMembers"]
                                  activeMember:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"]
                                      currency:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupCurrency"]];
    
    AddGroupViewController *agvc = (AddGroupViewController *)[navigationController topViewController];
    agvc.group = group;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)CloseGroupAction:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                          message:@"If you close this group, you and your friends will not have any access to it anymore"
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 0) {
            //NO clicked
            NSLog(@"No clicked");
        } else if (buttonIndex == 1) {
            
            //YES clicekd
            NSLog(@"Yes clicked");
            NSNumber *currentMemberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"][@"id"];
            NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:currentMemberId, @"currentMemberId", nil];
            
            [[AuthAPIClient sharedClient] getPath:@"api/group/close"
                                       parameters:parameters
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSError *error = nil;
                                              NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                              
                                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentMember"];
                                              NSLog(@"response = %@", response);
                                              
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"groupClosedSuccessfully" object:nil];
                                              
                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                              
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              NSLog(@"error: %@", error);
                                          }];
    }
}

// Design function !!!

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

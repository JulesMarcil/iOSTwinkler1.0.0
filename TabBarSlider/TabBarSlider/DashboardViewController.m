//
//  DashboardViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 22/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "DashboardViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AuthAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "DashboardMemberCell.h"
#import "DashboardSummaryCell.h"
#import "Group.h"
#import "AddGroupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RemoveFriendsViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

@synthesize mainTableView=_mainTableView;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    //Set notification listener for new group selected
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDashboardInfo) name:@"newGroupSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDashboardInfo) name:@"doneAddMember" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDashboardInfo) name:@"expenseAddedSuccesfully" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDashboardInfo) name:@"expenseRemovedSuccesfully" object:nil];
    
    //load data
    [self loadDashboardInfo];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    CGRect frame=self.mainTableView.bounds;
    [self.mainTableView setFrame:CGRectMake(0, 0, 320, frame.size.height)];
    
    
    self.mainTableView.separatorColor=[UIColor colorWithRed:(236/255.0) green:(231/255.0) blue:(223/255.0) alpha: 0];
    self.mainTableView.backgroundColor=[UIColor colorWithRed:(236/255.0) green:(231/255.0) blue:(223/255.0) alpha: 0];
    
    self.actionButton.layer.masksToBounds = YES;
    self.actionButton.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.actionButton.layer.borderWidth = 1.0f;
    self.closeGroupButton.layer.masksToBounds = YES;
    self.closeGroupButton.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.closeGroupButton.layer.borderWidth = 1.0f;
    self.removeFriendButton.layer.masksToBounds = YES;
    self.removeFriendButton.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.removeFriendButton.layer.borderWidth = 1.0f;
    
    self.spinnerView.layer.cornerRadius = 10;
    [self.view bringSubviewToFront:self.spinnerView];
    
    self.dashboardTitle.layer.cornerRadius = 3;
    self.dashboardTitle.layer.masksToBounds = NO;
    self.dashboardTitle.layer.shadowOffset = CGSizeMake(0, 0.6);
    self.dashboardTitle.layer.shadowRadius = 1.2;
    self.dashboardTitle.layer.shadowOpacity = 0.1;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];;
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    refreshControl.alpha=0.6;
    [self.mainTableView addSubview:refreshControl];
    [refreshControl setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin)];
    [[refreshControl.subviews objectAtIndex:0] setFrame:CGRectMake(75, 44, 20, 30)];
    
}
- (void)refresh:(UIRefreshControl *)refreshControl {
    NSLog(@"refresh function called");
    [refreshControl endRefreshing];
    [self refreshDashboardInfo];
}

- (void) loadDashboardInfo {
    
    //Launch Spinner
    self.spinnerView.hidden = NO;
    
    //Load Dashboard Info
    CredentialStore *store = [[CredentialStore alloc] init];
    NSString *authToken = [store authToken];
    NSNumber *currentMemberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"][@"id"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/dashboard?access_token=%@&currentMemberId=%@", appURL, authToken, currentMemberId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse != nil && [[cachedResponse data] length] > 0) {
        // Get cached data
        NSError* error;
        NSDictionary* response = [NSJSONSerialization JSONObjectWithData:cachedResponse.data options:kNilOptions error:&error];
        
        //NSLog(@"cached data = %@", response);
        
        self.dashboardInfo = response;
        [self.mainTableView reloadData];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        self.dashboardInfo = response;
        [self.mainTableView reloadData];
        
        NSLog(@"dashboard info loaded");
        self.spinnerView.hidden = YES;
    }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"error: %@", error);
                                          self.spinnerView.hidden = YES;
                                      }];
    
    [operation start];
}

- (void) refreshDashboardInfo {
    
    //Launch Spinner
    self.spinnerView.hidden = NO;
    
    //Refresh Dashboard Info
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
                                      self.spinnerView.hidden = YES;
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                      
                                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                                                          message:@"Impossible to refresh dashboard, make sure you are connected"
                                                                                         delegate:self
                                                                                cancelButtonTitle:@"Ok"
                                                                                otherButtonTitles:nil, nil];
                                      
                                      [alertView show];
                                      self.spinnerView.hidden = YES;
                                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }else{
        return [self.dashboardInfo[@"members"] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return @"SUMMARY";
    } else {
        return @"BALANCE";
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc] init];
    
    if(section == 0){
        label.frame =CGRectMake(0,25,320,20);
    } else {
        label.frame =CGRectMake(0,25,320,20);
    }
    
    label.text = sectionTitle;
    label.textAlignment = NSTextAlignmentCenter;
    label.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    label.textColor=[UIColor colorWithRed:(135/255.0) green:(135/255.0) blue:(135/255.0) alpha: 1];
    label.backgroundColor=[UIColor clearColor];
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:label];
    
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor=[UIColor colorWithRed:(135/255.0) green:(135/255.0) blue:(135/255.0) alpha: 0.4];
    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor=[UIColor colorWithRed:(135/255.0) green:(135/255.0) blue:(135/255.0) alpha: 0.4];
    
    if(section == 0){
        [leftLineView setFrame:CGRectMake(0, 35, 100, 1)];
        [rightLineView setFrame:CGRectMake(220, 35, 100, 1)];
    } else {
        [leftLineView setFrame:CGRectMake(0, 35, 100, 1)];
        [rightLineView setFrame:CGRectMake(220, 35, 100, 1)];
    }
    
    [view addSubview:rightLineView];
    [view addSubview:leftLineView];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *currency=[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupCurrency"];
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"summaryCell";
        DashboardSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        
        cell.backgroundColor=[UIColor clearColor];
        
        if (!cell) {
            cell = (DashboardSummaryCell*) [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:  CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.separatorView.backgroundColor=[UIColor colorWithRed:(236/255.0) green:(231/255.0) blue:(223/255.0) alpha: 1];
        [cell.contentView setFrame:CGRectMake(0, 0, 320, 42)];
        
        if (indexPath.row == 0){
            cell.balanceContainerView.layer.cornerRadius = 10;
            cell.bottomContainer.hidden=NO;
            cell.nameLabel.text = @"TOTAL GROUP EXPENSES:";
            cell.balanceLabel.text = [NSString stringWithFormat:@"%@ %@", currency[@"symbol"], [NSString stringWithFormat:@"%g", [self.dashboardInfo[@"total_paid"] doubleValue]]];
        } else {
            cell.balanceContainerView.layer.cornerRadius = 10;
            cell.topContainer.hidden=NO;
            cell.separatorView.backgroundColor=[UIColor colorWithRed:(236/255.0) green:(231/255.0) blue:(223/255.0) alpha: 0];
            cell.nameLabel.text = @"YOU PAID:";
            cell.balanceLabel.text = [NSString stringWithFormat:@"%@ %@", currency[@"symbol"], [NSString stringWithFormat:@"%g", [self.dashboardInfo[@"member_paid"] doubleValue]]];
        }
        
        cell.balanceContainerView.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha: 1];
        cell.balanceContainerView.layer.masksToBounds = YES;
        return cell;
        
    } else {
        
        static NSString *CellIdentifier = @"memberCell";
        DashboardMemberCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        
        cell.backgroundColor=[UIColor clearColor];
        
        if (!cell) {
            cell = (DashboardMemberCell*) [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                                 reuseIdentifier:  CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *memberAtIndex = [self.dashboardInfo[@"members"] objectAtIndex:indexPath.row];
        cell.nameLabel.text = memberAtIndex[@"name"];
        
        NSNumber *balance = memberAtIndex[@"balance"];
        cell.balanceLabel.text = [NSString stringWithFormat:@"%@ %g" ,currency[@"symbol"], [balance doubleValue]];
        
        if ([balance doubleValue]> 0) {
            cell.balanceLabel.textColor = [UIColor colorWithRed:(116/255.0) green:(178/255.0) blue:(20/255.0) alpha: 1];
        } else if ([balance doubleValue] < 0) {
            cell.balanceLabel.textColor =  [UIColor colorWithRed:(255/255.0) green:(146/255.0) blue:(123/255.0) alpha: 1];
        } else {
            cell.balanceLabel.textColor = [UIColor colorWithRed:(116/255.0) green:(116/255.0) blue:(116/255.0) alpha: 1];
        }
        
        cell.separatorView.backgroundColor=[UIColor colorWithRed:(236/255.0) green:(231/255.0) blue:(223/255.0) alpha: 1];
        
        if (indexPath.row==0){
            cell.balanceContainerView.layer.cornerRadius = 10;
            cell.bottomContainer.hidden=NO;
        }else if (indexPath.row==[self.dashboardInfo[@"members"] count]-1){
            cell.balanceContainerView.layer.cornerRadius = 10;
            cell.topContainer.hidden=NO;
            cell.separatorView.backgroundColor=[UIColor colorWithRed:(236/255.0) green:(231/255.0) blue:(223/255.0) alpha: 0];
        }
        
        cell.balanceContainerView.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha: 1];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        //NO clicked
        NSLog(@"No clicked");
        NSLog(@"nav array class = %@", self.navigationController.viewControllers.class);
        NSLog(@"nav array count = %lu", (unsigned long)self.navigationController.viewControllers.count);
        NSLog(@"root viewcontroller class = %@", self.navigationController.topViewController.class);
        
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
                                          
                                          
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"groupClosedSuccessfully" object:nil];
                                          
                                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentMember"];
                                          
                                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentGroupName"];
                                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentGroupMembers"];
                                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentGroupCurrency"];
                                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentGroupIndex"];
                                          NSLog(@"response = %@", response);
                                          
                                          UINavigationController * navigationController = self.navigationController.navigationController;
                                          
                                          NSMutableArray *navigationArray = [navigationController.viewControllers mutableCopy];
                                          [navigationArray removeObjectAtIndex:1];
                                          self.navigationController.navigationController.viewControllers = navigationArray;
                                          
                                          [navigationController popToRootViewControllerAnimated:NO];
                                          
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"error: %@", error);
                                      }];
    }
}

// Design function !!!

-(void) setRoundedView:(UIImageView *)imageView picture: (UIImage *)picture toDiameter:(float)newSize {
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

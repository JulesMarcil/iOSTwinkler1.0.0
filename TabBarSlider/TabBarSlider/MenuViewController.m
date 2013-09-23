//
//  MenuViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 02/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "TabBarViewController.h"
#import "GroupDataController.h"
#import "Group.h"
#import "Profile.h"
#import "AddGroupViewController.h"
#import "SWRevealViewController.h"
#import "GroupListCell.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "AuthAPIClient.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize groupOnMenu=_groupOnMenu;

- (void)awakeFromNib {
    
    NSLog(@"menuViewController %@: awakeFromNib", self.title);
    [super awakeFromNib];
    
}

- (void)loginSuccess
{
    NSLog(@"menuViewController %@: loginSuccess", self.title);
    self.groupDataController = nil;
    self.profile = nil;
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] addObserver:appDelegate selector:@selector(dismissLoginView) name:@"profileDisplayed" object:nil];
    [self loadData];
}

- (void)viewDidLoad
{
    NSLog(@"menuViewController %@: viewDidLoad", self.title);
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupDataRetrieved) name:@"groupsWithJSONFinishedLoading" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileDataRetrieved) name:@"profileWithJSONFinishedLoading" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"doneAddMember" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCurrentGroup) name:@"groupClosedSuccessfully" object:nil];
    if ([self.title isEqual: @"welcomeMenu"]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    }
    
    if (![self.title isEqual: @"welcomeMenu"]){
        [self loadData];
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backToGroup)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [[self view] addGestureRecognizer:recognizer];
        
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	// Do any additional setup after loading the view.
    
    //-----------DESIGN---------------//
    UIColor *borderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    CGRect frame= [self.profilePic frame];
    [imageView setFrame:CGRectMake(frame.origin.x,
                                   frame.origin.y,
                                   frame.size.width,
                                   frame.size.height)];
    
    [self setRoundedBorder:imageView toDiameter:71.0];
    [imageView.layer setBorderColor:borderColor.CGColor];
    [imageView.layer setBorderWidth:2.0];
    [self.tableViewHeader addSubview: imageView];
    
    
    borderColor = [UIColor colorWithRed:(231/255.0) green:(231/255.0) blue:(231/255.0) alpha:0] ;
    [self.addGroupButton.layer setBorderColor:borderColor.CGColor];
    [self.addGroupButton.layer setBorderWidth:1.0];
    self.groupOnMenu.separatorColor = [UIColor clearColor];
    self.groupOnMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) backToGroup{
    NSLog(@"menuViewController %@: backToGroup", self.title);
    
    [self performSegueWithIdentifier:@"goToGroupSegue" sender:self];
}

-(void) loadData{
    NSLog(@"menuViewController %@: loadData", self.title);
    
    self.groupDataController = [[GroupDataController alloc] init];
    
    NSDictionary *defaultProfile = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    
    if (defaultProfile) {
        self.profile = [[Profile alloc] initWithName:defaultProfile[@"name"] friendNumber:defaultProfile[@"friendNumber"] picturePath:defaultProfile[@"picturePath"]];
        [self profileDataRetrieved];
    } else {
        self.profile = [[Profile alloc] init];
        [self.profile loadProfile];
    }
}

- (void)groupDataRetrieved {
    NSLog(@"menuViewController %@: groupDataRetrieved", self.title);
    
    [self.groupOnMenu reloadData];
}

- (void)profileDataRetrieved {
    NSLog(@"menuViewController %@: profileDataRetrieved", self.title);
    
    //set a fictious current member if there is no to make sure the group creation process is not blocked
    NSDictionary *currentMember = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"];
    
    if(!currentMember) {
        currentMember = [[NSDictionary alloc] initWithObjects:@[@-1, self.profile.name, self.profile.picturePath]  forKeys:@[@"id", @"name", @"picturePath"]];
        [[NSUserDefaults standardUserDefaults] setObject:currentMember forKey:@"currentMember"];
    }
    
    // display profile information
    self.nameLabel.text = self.profile.name;
    self.friendNumberLabel.text = [NSString stringWithFormat:@"%@ Friends", self.profile.friendNumber];
    
    NSString *facebookId =[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookId"];
    
    NSURL *url = nil;
    if (facebookId) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", facebookId]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", appBaseURL, self.profile.picturePath]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"url before loading profile pic = %@", url);
    
    [self.profilePic setImageWithURLRequest:request
                           placeholderImage:[UIImage imageNamed:@"profile-pic.png"]
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        self.profilePic.image = image;
                                        [self setRoundedView:self.profilePic picture:self.profilePic.image toDiameter:70.0];
                                        
                                        NSLog(@"menuViewController %@: profileDisplayed notification sent", self.title);
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"profileDisplayed" object:nil];
                                        
                                    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        NSLog(@"Failed with error: %@", error);
                                    }];
}

-(void) removeCurrentGroup {
    
    NSLog(@"MenuViewController %@: removeCurrentGroup", self.title);
    NSNumber *index = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupIndex"];
    Group *group = [self.groupDataController objectInListAtIndex:[index intValue]];
    [self.groupDataController removeGroupWithGroup:group];
    [self.groupOnMenu reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([self.groupDataController countOfList]>0){
    return [self.groupDataController countOfList];
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.groupDataController countOfList]>0){
        static NSString *CellIdentifier = @"groupCell";
        static NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
        }
        GroupListCell *cell = [tableView
                               dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        
        if (!cell) {
            cell = [[GroupListCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        Group *groupAtIndex = [self.groupDataController
                               objectInListAtIndex:indexPath.row];
        cell.groupNameLabel.text=groupAtIndex.name;
        
        switch (groupAtIndex.members.count) {
            case 1:
                
                cell.detailLabel.text=@"You are alone :'(";
                break;
            case 2:
                if(![groupAtIndex.members[0][@"name"] isEqual:groupAtIndex.activeMember[@"name"]]){
                    cell.detailLabel.text=[NSString stringWithFormat:@"You and %@", groupAtIndex.members[0][@"name"]];
                }else{
                    cell.detailLabel.text=[NSString stringWithFormat:@"You and %@", groupAtIndex.members[1][@"name"]];
                }
                break;
            default:
                cell.detailLabel.text=[NSString stringWithFormat:@"You and %d friends", groupAtIndex.members.count-1];
        }
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        NSMutableArray *groupMembers = [[NSMutableArray alloc] init];
        NSDictionary *tempActiveMember;
        
        for (NSDictionary *member in groupAtIndex.members) {
            if ([member[@"id"] intValue] != [groupAtIndex.activeMember[@"id"] intValue]) {
                [groupMembers addObject:member];
            } else {
                tempActiveMember = member;
            }
        }
        
        [cell.groupPicPlaceholder.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
        if([groupMembers count]==0){
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 9, 40,40)];
            [self getImageForView:iv Member:tempActiveMember size:40.0];
            [cell.groupPicPlaceholder addSubview:iv];
        }else if([groupMembers count]==1){
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 9, 40,40)];
            [self getImageForView:iv Member:groupMembers[0] size:40.0];
            [cell.groupPicPlaceholder addSubview:iv];
        }else if ([groupMembers count]==2){
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(24, 6, 25, 25)];
            UIImageView *ivbis = [[UIImageView alloc] initWithFrame:CGRectMake(4, 26, 25, 25)];
            [self getImageForView:iv Member:groupMembers[0] size:25.0];
            [self getImageForView:ivbis Member:groupMembers[1] size:25.0];
            [cell.groupPicPlaceholder addSubview:iv];
            [cell.groupPicPlaceholder addSubview:ivbis];
        }else if ([groupMembers count]==3){
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(16, 8, 20,20)];
            UIImageView *ivbis = [[UIImageView alloc] initWithFrame:CGRectMake(4, 29, 20,20)];
            UIImageView *ivtier = [[UIImageView alloc] initWithFrame:CGRectMake(29, 29, 20,20)];
            [self getImageForView:iv Member:groupMembers[0] size:20.0];
            [self getImageForView:ivbis Member:groupMembers[1] size:20.0];
            [self getImageForView:ivtier Member:groupMembers[2] size:20.0];
            [cell.groupPicPlaceholder  addSubview:iv];
            [cell.groupPicPlaceholder  addSubview:ivbis];
            [cell.groupPicPlaceholder  addSubview:ivtier];
        }else if ([groupMembers count]==4){
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(4, 5, 22,22)];
            UIImageView *ivbis = [[UIImageView alloc] initWithFrame:CGRectMake(29, 5, 22,22)];
            UIImageView *ivtier = [[UIImageView alloc] initWithFrame:CGRectMake(4, 30, 22,22)];
            UIImageView *ivquatro = [[UIImageView alloc] initWithFrame:CGRectMake(29, 30, 22,22)];
            [self getImageForView:iv Member:groupMembers[0] size:22.0];
            [self getImageForView:ivbis Member:groupMembers[1] size:22.0];
            [self getImageForView:ivtier Member:groupMembers[2] size:22.0];
            [self getImageForView:ivquatro Member:groupMembers[3] size:22.0];
            [cell.groupPicPlaceholder  addSubview:iv];
            [cell.groupPicPlaceholder  addSubview:ivbis];
            [cell.groupPicPlaceholder  addSubview:ivtier];
            [cell.groupPicPlaceholder  addSubview:ivquatro];
        }
        else if ([groupMembers count]>3){
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(4, 5, 22,22)];
            UIImageView *ivbis = [[UIImageView alloc] initWithFrame:CGRectMake(29, 5, 22,22)];
            UIImageView *ivtier = [[UIImageView alloc] initWithFrame:CGRectMake(4, 30, 22,22)];
            UIImageView *ivquatro = [[UIImageView alloc] initWithFrame:CGRectMake(29, 30, 22,22)];
            [self getImageForView:iv Member:groupMembers[0] size:22.0];
            [self getImageForView:ivbis Member:groupMembers[1] size:22.0];
            [self getImageForView:ivtier Member:groupMembers[2] size:22.0];
            [self getImageForView:ivquatro Member:groupMembers[3] size:22.0];
            [cell.groupPicPlaceholder  addSubview:iv];
            [cell.groupPicPlaceholder  addSubview:ivbis];
            [cell.groupPicPlaceholder  addSubview:ivtier];
            ivquatro.image=[UIImage imageNamed:@"member-icon-placeholder.png"];
            UILabel* membersLabel = [[UILabel alloc] initWithFrame:CGRectMake(29, 30, 22,22)];
            membersLabel.text= [NSString stringWithFormat:@"%i", (int) [groupMembers count]-3];
            membersLabel.backgroundColor=[UIColor clearColor];
            membersLabel.textAlignment = NSTextAlignmentCenter;
            membersLabel.textColor=[UIColor whiteColor];
            [membersLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
            [cell.groupPicPlaceholder  addSubview:ivquatro];
            [cell.groupPicPlaceholder  addSubview:membersLabel];
        }
        
        cell.backgroundView = [UIView new];
        return cell;
    }else{
        static NSString *CellIdentifier = @"emptyTable";
        UITableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
}

- (void)getImageForView:(UIImageView *)view Member:(NSDictionary *)member size:(NSInteger) size{
    
    UIImage *placeholderImage = [[UIImage alloc] init];
    placeholderImage = [UIImage imageNamed:@"profile-pic-placeholder.png"];
    
    NSString *path = member[@"picturePath"];
    NSNumber *facebookId= [[[NSNumberFormatter alloc] init] numberFromString:path];
    
    NSURL *url = nil;
    if (facebookId) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", facebookId]];
    } else if(![path isEqualToString:@"local"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", appBaseURL, path]];
    }
    
    if (url) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [view setImageWithURLRequest:request
                    placeholderImage:placeholderImage
                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                 view.image = image;
                                 [self setRoundedView:view picture:view.image toDiameter:size];
                             }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                 NSLog(@"Failed with error: %@", error);
                             }];
    } else {
        
        view.image = placeholderImage;
        [self setRoundedView:view picture:view.image toDiameter:size];
        
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"MenuViewController %@: didselectrowatindexpath", self.title);
    
    if ([self.title isEqualToString:@"welcomeMenu"]){
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        Group   *selectedGroup=[self.groupDataController objectInListAtIndex:indexPath.row] ;
        
        UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *dst=[mainStoryboard instantiateInitialViewController];
        
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.activeMember forKey:@"currentMember"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.identifier forKey:@"currentGroupId"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.name forKey:@"currentGroupName"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.members forKey:@"currentGroupMembers"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.currency forKey:@"currentGroupCurrency"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:indexPath.row] forKey:@"currentGroupIndex"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newGroupSelected" object:nil];
        NSLog(@"menuViewController %@: newGroupSelected post Notification", self.title);
        
        // Then push the new view controller in the usual way:
        [self.navigationController pushViewController:dst animated:YES];
    }
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // configure the destination view controller:
    if ( [segue.destinationViewController isKindOfClass: [TabBarViewController class]] && [sender isKindOfClass:[UIButton class]] ) {
        
        TabBarViewController* cvc = segue.destinationViewController;
        cvc.groupTitle.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentGroupName"];
        [cvc view];
    }
    
    // configure the segue.
    // in this case we dont swap out the front view controller, which is a UINavigationController.
    // but we could..
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        
        Group *selectedGroup = [self.groupDataController objectInListAtIndex:[self.groupOnMenu indexPathForSelectedRow].row];
        
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.identifier forKey:@"currentGroupId"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.name forKey:@"currentGroupName"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.members forKey:@"currentGroupMembers"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.activeMember forKey:@"currentMember"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.currency forKey:@"currentGroupCurrency"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[self.groupOnMenu indexPathForSelectedRow].row] forKey:@"currentGroupIndex"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newGroupSelected" object:nil];
        NSLog(@"menueViewController %@: newGroupSelected post Notification", self.title);
        
        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        
        SWRevealViewController* rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* nc = (UINavigationController*)rvc.frontViewController;
            [nc setViewControllers: @[ dvc ] animated: YES ];
            
            [rvc setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}

- (IBAction)goToTimelineButton:(id)sender {
    
    NSLog(@"menuViewController %@: goToTimelineButton", self.title);
    
    UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *dst=[mainStoryboard instantiateInitialViewController];
    
    Group *selectedGroup = [self.groupDataController objectInListAtIndex:[self.groupOnMenu indexPathForSelectedRow].row];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.activeMember forKey:@"currentMember"];
    [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.identifier forKey:@"currentGroupId"];
    [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.name forKey:@"currentGroupName"];
    [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.members forKey:@"currentGroupMembers"];
    [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.currency forKey:@"currentGroupCurrency"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[self.groupOnMenu indexPathForSelectedRow].row] forKey:@"currentGroupIndex"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newGroupSelected" object:nil];
    NSLog(@"menuViewController %@: newGroupSelected notification sent", self.title);
    
    // Then push the new view controller in the usual way:
    [self.navigationController pushViewController:dst animated:YES];
    
}

- (IBAction)doneAddGroup:(UIStoryboardSegue *)segue {
    
    NSLog(@"MenuViewController %@: doneAddGroup", self.title);
    
    if ([[segue identifier] isEqualToString:@"ReturnAddGroupInput"]) {
        
        AddGroupViewController *addController = [segue sourceViewController];
        Group *group = addController.group;
        
        if (group) {
            
            //Code to add group here
            NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:addController.group.name, @"group_name", addController.selectedCurrency[@"id"], @"currency_id", nil];
            
            [[AuthAPIClient sharedClient] getPath:@"api/add/group"
                                       parameters:parameters
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *response = [operation responseString];
                                              NSLog(@"response: %@",response);
                                              [self.groupDataController addGroupWithGroup:group];
                                              [self.groupOnMenu reloadData];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"groupsWithJSONFinishedLoading" object:nil];
                                              [self dismissViewControllerAnimated:YES completion:NULL];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              NSLog(@"error: %@", error);
                                          }];
        }
    }
}

- (IBAction)cancelAddGroup:(UIStoryboardSegue *)segue{
    if ([[segue identifier] isEqualToString:@"CancelAddGroupInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)Logout:(id)sender {
    
    NSLog(@"MenuViewController %@: logout", self.title);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You're about to leave :("
                                                        message:@"Are you sure you want to log out?"
                                                       delegate:self
                                              cancelButtonTitle:@"Log Out"
                                              otherButtonTitles:@"Stay Logged In", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        //YES
        NSLog(@"menuViewController %@: logout effectively", self.title);
        
        CredentialStore *store = [[CredentialStore alloc] init];
        NSString *authToken = [store authToken];
        
        if (authToken){
            [store clearSavedCredentials];
            NSLog(@"token cleared ! auth token = %@", authToken);
        }
        
        if (FBSession.activeSession.isOpen){
            [FBSession.activeSession closeAndClearTokenInformation];
            NSLog(@"facebook session closed");
        }
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebookId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebookName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentMember"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentGroupId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentGroupName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentGroupMembers"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentGroupCurrency"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentGroupIndex"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profile"];
        
        //remove the cache
        NSCache *cache = [[NSCache alloc] init];
        [cache removeAllObjects];
        
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        
        if (![self.title isEqual:@"welcomeMenu"]){
            
            UINavigationController * navigationController = self.navigationController;
            
            
            NSMutableArray *navigationArray = [navigationController.viewControllers mutableCopy];;
            NSLog(@"viewcontrollers count = %u", navigationArray.count);
            [navigationArray removeObjectAtIndex:1];
            self.navigationController.viewControllers = navigationArray;
            
            [navigationController popToRootViewControllerAnimated:NO];
        }
        [appDelegate showLoginView];
    }
    else if (buttonIndex == 1) {
        // No
        NSLog(@"menuViewController %@: cancelLogout", self.title);
    }
}

- (IBAction)createGroup:(id)sender {
    NSLog(@"menuViewController: createGroup");
    UIViewController *dst=[[UIStoryboard storyboardWithName:@"AddGroupStoryboard" bundle:nil] instantiateInitialViewController];
    [self presentViewController:dst animated:YES completion:nil];
}

//--------DESIGN------------//
-(void)setRoundedBorder:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

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

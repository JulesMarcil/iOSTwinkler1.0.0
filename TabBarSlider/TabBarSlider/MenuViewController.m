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

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize groupOnMenu=_groupOnMenu;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupDataRetrieved) name:@"groupsWithJSONFinishedLoading" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileDataRetrieved) name:@"profileWithJSONFinishedLoading" object:nil];
    if ([self.title isEqual: @"welcomeMenu"]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    }
}

- (void)loginSuccess
{
    NSLog(@"login success function called");
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [[NSNotificationCenter defaultCenter] addObserver:appDelegate selector:@selector(dismissLoginView) name:@"profileDisplayed" object:nil];
    [self loadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![self.title isEqual: @"welcomeMenu"]){
        [self loadData];
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

-(void) loadData{
    self.groupDataController = [[GroupDataController alloc] init];
    self.profile = [[Profile alloc] init];
    [self.profile loadProfile];
}

- (void)groupDataRetrieved {
    [self.groupOnMenu reloadData];
}

- (void)profileDataRetrieved {
    self.nameLabel.text = self.profile.name;
    self.friendNumberLabel.text = [NSString stringWithFormat:@"%@ Friends", self.profile.friendNumber];
    
    NSString *facebookId =[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookId"];
    
    NSURL *url;
    if (facebookId) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", facebookId]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8888/Twinkler1.2.3/web/%@", self.profile.picturePath]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@", url);
    
    [self.profilePic setImageWithURLRequest:request
                           placeholderImage:[UIImage imageNamed:@"profile-pic.png"]
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        self.profilePic.image = image;
                                        [self setRoundedView:self.profilePic picture:self.profilePic.image toDiameter:70.0];
                                        
                                        NSLog(@"profileDisplayed");
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"profileDisplayed" object:nil];
                                        
                                   }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                         NSLog(@"Failed with error: %@", error);
                                   }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.groupDataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"groupCell";
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    GroupListCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    Group *groupAtIndex = [self.groupDataController
                               objectInListAtIndex:indexPath.row];
    cell.groupNameLabel.text=groupAtIndex.name;
    cell.detailLabel.text=[NSString stringWithFormat:@"You and %d friends", groupAtIndex.members.count-1];
    cell.dateLabel.text=@"Mon";
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
    
    NSInteger memberNumber=[groupMembers count];
    [cell.groupPicPlaceholder.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    if(memberNumber==0){
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 9, 40,40)];
        [self getImageForView:iv Member:tempActiveMember size:40.0];
        [cell.groupPicPlaceholder addSubview:iv];
    }else if(memberNumber==1){
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 9, 40,40)];
        [self getImageForView:iv Member:groupMembers[0] size:40.0];
        [cell.groupPicPlaceholder addSubview:iv];
    }else if (memberNumber==2){
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(24, 6, 25, 25)];
        UIImageView *ivbis = [[UIImageView alloc] initWithFrame:CGRectMake(4, 26, 25, 25)];
        [self getImageForView:iv Member:groupMembers[0] size:25.0];
        [self getImageForView:ivbis Member:groupMembers[1] size:25.0];
        [cell.groupPicPlaceholder addSubview:iv];
        [cell.groupPicPlaceholder addSubview:ivbis];
    }else if (memberNumber==3){
        NSLog(@"%@, group of 3+1 members to be loaded", groupAtIndex.name);
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(16, 8, 20,20)];
        UIImageView *ivbis = [[UIImageView alloc] initWithFrame:CGRectMake(4, 29, 20,20)];
        UIImageView *ivtier = [[UIImageView alloc] initWithFrame:CGRectMake(29, 29, 20,20)];
        [self getImageForView:iv Member:groupMembers[0] size:20.0];
        [self getImageForView:ivbis Member:groupMembers[1] size:20.0];
        [self getImageForView:ivtier Member:groupMembers[2] size:20.0];
        [cell.groupPicPlaceholder  addSubview:iv];
        [cell.groupPicPlaceholder  addSubview:ivbis];
        [cell.groupPicPlaceholder  addSubview:ivtier];
    }else if (memberNumber>3){
        UIImage *image = [[UIImage alloc] init];
        image=[UIImage imageNamed:@"profile-pic-placeholder.png"];
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

    cell.backgroundView = [UIView new];
    return cell;
}

- (void)getImageForView:(UIImageView *)view Member:(NSDictionary *)member size:(NSInteger) size{
    
    NSLog(@"get image for member %@", member);
    
    UIImage *placeholderImage = [[UIImage alloc] init];
    placeholderImage = [UIImage imageNamed:@"profile-pic-placeholder.png"];
    
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
        NSLog(@" requesting image for url: %@", url);
        
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
    if ([self.title isEqualToString:@"welcomeMenu"]){
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        Group   *selectedGroup=[self.groupDataController objectInListAtIndex:indexPath.row] ;
        
        UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *dst=[mainStoryboard instantiateInitialViewController];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.identifier forKey:@"currentGroupId"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.activeMember forKey:@"currentMember"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.name forKey:@"currentGroupName"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.members forKey:@"currentGroupMembers"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.currency forKey:@"currentGroupCurrency"];
        
        // Then push the new view controller in the usual way:
        [self.navigationController pushViewController:dst animated:YES];
    }
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // configure the destination view controller:
    if ( [segue.destinationViewController isKindOfClass: [TabBarViewController class]] &&
        [sender isKindOfClass:[UIButton class]] )
    {
        TabBarViewController* cvc = segue.destinationViewController;
        cvc.groupTitle.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentGroupName"];
        [cvc view];
    }
    
    // configure the segue.
    // in this case we dont swap out the front view controller, which is a UINavigationController.
    // but we could..
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        Group *selectedGroup = [self.groupDataController objectInListAtIndex:[self.groupOnMenu indexPathForSelectedRow].row];
        
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.identifier forKey:@"currentGroupId"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.activeMember forKey:@"currentMember"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.name forKey:@"currentGroupName"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.members forKey:@"currentGroupMembers"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.currency forKey:@"currentGroupCurrency"];
        
        NSLog(@"active member = %@", selectedGroup.activeMember);
        
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
    
            UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            UIViewController *dst=[mainStoryboard instantiateInitialViewController];
    
    Group *selectedGroup = [self.groupDataController objectInListAtIndex:[self.groupOnMenu indexPathForSelectedRow].row];
    
    [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.identifier forKey:@"currentGroupId"];
    [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.activeMember forKey:@"currentMember"];
    [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.name forKey:@"currentGroupName"];
    [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.members forKey:@"currentGroupMembers"];
    [[NSUserDefaults standardUserDefaults] setObject:selectedGroup.currency forKey:@"currentGroupCurrency"];
    
            // Then push the new view controller in the usual way:
    [self.navigationController pushViewController:dst animated:YES];
        
}

- (IBAction)doneAddGroup:(UIStoryboardSegue *)segue {
    {
        if ([[segue identifier] isEqualToString:@"ReturnAddGroupInput"]) {
            AddGroupViewController *addController = [segue
                                                       sourceViewController];
            if (addController.groupName) {
                //Code to add expense here
            }
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

- (IBAction)cancelAddGroup:(UIStoryboardSegue *)segue{
    if ([[segue identifier] isEqualToString:@"CancelAddGroupInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)Logout:(id)sender {
    
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
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentGroupId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentMember"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentGroupName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentGroupMembers"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentGroupCurrency"];
    
    UIStoryboard *welcomeStoryboard = [UIStoryboard storyboardWithName:@"welcomeStoryboard" bundle: nil];
    UINavigationController *navController = (UINavigationController*)[welcomeStoryboard instantiateViewControllerWithIdentifier:@"LoginNavController"];
    
    [navController popToRootViewControllerAnimated:NO];
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate showLoginView];
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

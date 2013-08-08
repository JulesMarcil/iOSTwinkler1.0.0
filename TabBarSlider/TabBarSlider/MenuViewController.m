//
//  MenuViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 02/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "MenuViewController.h"
#import "TabBarViewController.h"
#import "GroupDataController.h"
#import "Group.h"
#import "AddGroupViewController.h"
#import "SWRevealViewController.h"
#import "GroupListCell.h"
#import <QuartzCore/QuartzCore.h>

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize groupOnMenu=_groupOnMenu;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(dataRetrieved)
     name:@"groupsWithJSONFinishedLoading"
     object:nil];
    self.groupDataController=[[GroupDataController alloc] init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"initWithNibName");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.groupDataController = [[GroupDataController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	// Do any additional setup after loading the view.

    
    
    
    //-----------DESIGN---------------//
    UIColor *borderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];

    [self setRoundedView:self.profilePic toDiameter:70.0];
    UIImageView *imageView = [[UIImageView alloc]init];
    CGRect frame= [self.profilePic frame];
    [imageView setFrame:CGRectMake(frame.origin.x,
                                   frame.origin.y,
                                   frame.size.width,
                                   frame.size.height)];
    
    [self setRoundedView:imageView toDiameter:71.0];
    [imageView.layer setBorderColor:borderColor.CGColor];
    [imageView.layer setBorderWidth:2.0];
    [self.tableViewHeader addSubview: imageView];
    
    
    borderColor = [UIColor colorWithRed:(231/255.0) green:(231/255.0) blue:(231/255.0) alpha:0] ;
    [self.addGroupButton.layer setBorderColor:borderColor.CGColor];
    [self.addGroupButton.layer setBorderWidth:1.0];
    self.groupOnMenu.separatorColor = [UIColor clearColor];
    self.groupOnMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    NSLog(@"%@", self.title);
}

- (void)dataRetrieved {
    [self.groupOnMenu reloadData];
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
    cell.detailLabel.text=@"yo, what's up?";
    cell.dateLabel.text=@"Mon";
    cell.contentView.backgroundColor = [UIColor clearColor];

    
    cell.backgroundView = [UIView new];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.title isEqualToString:@"welcomeMenu"]){
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Group   *selectedGroup=[self.groupDataController objectInListAtIndex:[self.groupOnMenu indexPathForSelectedRow].row] ;
        
        NSLog(selectedGroup.name);
        
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


//--------DESIGN------------//
-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

@end

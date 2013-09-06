//
//  ListViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "ListViewController.h"
#import "ListDataController.h"
#import "List.h"
#import "ItemListViewController.h"
#import "TabBarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ListCell.h"


@interface ListViewController ()

@end

@implementation ListViewController

@synthesize listOnLists=_listOnLists;

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
    CGRect frame= [self.listOnLists frame];
    [self.listOnLists setFrame:CGRectMake(0,
                                          -20,
                                          frame.size.width,
                                          screenHeight-208+44+44+100)];
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(dataRetrieved)
     name:@"listsWithJSONFinishedLoading"
     object:nil];
    
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToTimeline)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGestureRecognizer];
    
    
    self.listOnLists.backgroundColor=[UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1];
    self.listOnLists.separatorColor = [UIColor clearColor];

}

- (void)dataRetrieved {
    [self.listOnLists reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.listDataController=[[ListDataController alloc] init];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listDataController countOfList];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"listCell";
    
    ListCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    List *listAtIndex = [self.listDataController
                         objectInListAtIndex:indexPath.row];
    cell.listTitleLabel.text=listAtIndex.name;
    
    cell.itemNumberLabel.text=[[@([listAtIndex.items count]) stringValue] stringByAppendingString:@" items"];;
    
    cell.viewContainer.layer.cornerRadius = 3;
    cell.viewContainer.layer.masksToBounds = NO;
    cell.viewContainer.layer.shadowOffset = CGSizeMake(0, 0.6);
    cell.viewContainer.layer.shadowRadius = 0.8;
    cell.viewContainer.layer.shadowOpacity = 0.1;
    cell.viewContainer.backgroundColor=[UIColor whiteColor];
    
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"itemListSegue"]){
        NSIndexPath *indexPath = [self.listOnLists indexPathForCell:sender];
        
        List *listAtIndex = [self.listDataController objectInListAtIndex:indexPath.row];
        
        ItemListViewController *ilvc = [segue destinationViewController];
        ilvc.list = listAtIndex;
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
    [animation setSubtype:kCATransitionFromLeft];
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
@end

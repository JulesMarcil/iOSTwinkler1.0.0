//
//  TimelineViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "TimelineViewController.h"
#import "ExpandableNavigation.h"
#import "TabBarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AuthAPIClient.h"
#import "AFHTTPRequestOperation.h"
#import "timelineBubbleCell.h"


@interface TimelineViewController ()

@end

@implementation TimelineViewController

@synthesize messageOnTimeline=_messageOnTimeline;
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize main;
@synthesize navigation;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.messageDataController = [[TimelineDataController alloc] init];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataRetrieved) name:@"messagesWithJSONFinishedLoading" object:nil];
    
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(dataRefresh)
                                   userInfo:nil
                                    repeats:YES];
    
    //-------------Position----------------------------
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGRect frame= [self.messageOnTimeline frame];
    [self.messageOnTimeline setFrame:CGRectMake(0,
                                               -20,
                                               frame.size.width,
                                                screenHeight-208)];
    [self.messageOnTimeline setContentOffset:CGPointMake(0, 999999999999)];
    
    
    frame= [self.actionBar frame];
    [self.actionBar setFrame:CGRectMake(0,
                                       screenHeight-228,
                                       frame.size.width,
                                       44)];
    frame= [self.main frame];
    [self.main setFrame:CGRectMake(10,
                                   screenHeight-222,
                                    frame.size.width,
                                   frame.size.height)];
    
    self.actionBar.layer.borderWidth = 1.0f;
    self.actionBar.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.timelineTextBoxContainer.layer.cornerRadius = 3;
    self.timelineTextBoxContainer.layer.masksToBounds = YES;
    self.timelineTextBoxContainer.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.timelineTextBoxContainer.layer.borderWidth = 1.0f;
    

    
  
    //------------TabBar Navigation------------------------------
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToExpense)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGestureRecognizer];
    
    
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToList)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
    
    
    
    //-------------Expandable Button----------------------------
    // initialize ExpandableNavigation object with an array of buttons.
    NSArray* buttons = [NSArray arrayWithObjects:button1, button2, button3, button4, nil];
    
    self.navigation = [[ExpandableNavigation alloc] initWithMenuItems:buttons mainButton:self.main radius:120.0];
}

-(void)viewDidAppear:(BOOL)animated{
}

- (void)dataRefresh{
    
    NSString *currentGroupId = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentGroupId"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:currentGroupId, @"currentGroupId", nil];
    
    [[AuthAPIClient sharedClient] getPath:@"api/get/messages"
                               parameters:parameters
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError *error = nil;
                                      NSArray *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      
                                      int n = response.count;
                                      
                                      NSUInteger diff = n - self.messageDataController.countOfList;
                                      NSLog(@"diff = %u",diff);
                                      
                                      if (diff > 0){
                                          
                                          for (int i = n - diff; i<n; i++){
                                              Message *message = [[Message alloc] initWithContent:response[i][@"body"]
                                                                                           author:response[i][@"author"]
                                                                                             date:[NSDate dateWithTimeIntervalSince1970:[response[i][@"time"] doubleValue]]
                                                                                             type:response[i][@"type"]
                                                                  ];
                                              [self.messageDataController addMessage:message];
                                          }
                                          [self.messageOnTimeline reloadData];
                                          NSLog(@"success: %u messages added", diff);
                                      }else{
                                          NSLog(@"success: data in sync");
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                  }];

}

- (void)dataRetrieved {
    [self.messageOnTimeline reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.refreshTimer invalidate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    self.button4 = nil;
    self.main = nil;
    self.navigation = nil;
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
    return [self.messageDataController countOfList];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *messageAtIndex = [self.messageDataController
                               objectInListAtIndex:indexPath.row];
    CGSize sz = [messageAtIndex.content sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]constrainedToSize:CGSizeMake(200, 20000) lineBreakMode:NSLineBreakByWordWrapping];
    return sz.height+36;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"timelineCell";
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    timelineBubbleCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.messageContainer.layer.cornerRadius = 3;
    cell.messageContainer.layer.masksToBounds = YES;
    
    Message *messageAtIndex = [self.messageDataController
                                   objectInListAtIndex:indexPath.row];
    cell.messageLabel.text=messageAtIndex.content;
    
    
    NSString *currentMemberName=[[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"][@"name"];
    
    if (![currentMemberName isEqualToString:messageAtIndex.author]){
    
    CGRect frame = cell.messageLabel.frame;
    frame.size.height = cell.messageLabel.contentSize.height+20;
    CGSize sz = [cell.messageLabel.text sizeWithFont:cell.messageLabel.font constrainedToSize:CGSizeMake(200, 20000) lineBreakMode:NSLineBreakByWordWrapping];
    cell.messageLabel.editable = NO;
    cell.messageContainer.frame=frame;
    [cell.messageContainer setFrame:CGRectMake(320-sz.width-20-20,10,
                                                sz.width+20,
                                                sz.height+20)];
    
    [cell.bubbleTailImage setFrame:CGRectMake(320-21,sz.height,
                                              cell.bubbleTailImage.frame.size.width,
                                              cell.bubbleTailImage.frame.size.height)];
        
    [cell.memberProfilePicImage removeFromSuperview];
    
    [cell.timelineTimeLabel setFrame:CGRectMake(320-sz.width-20-20-45,sz.height+5,
                                              cell.timelineTimeLabel.frame.size.width,
                                              cell.timelineTimeLabel.frame.size.height)];
    
    [formatter setDateFormat:@"HH:mm"];
    cell.timelineTimeLabel.text=[formatter stringFromDate:(NSDate*)messageAtIndex.date];
        
    }else{
        
        CGRect frame = cell.messageLabel.frame;
        frame.size.height = cell.messageLabel.contentSize.height+20;
        CGSize sz = [cell.messageLabel.text sizeWithFont:cell.messageLabel.font constrainedToSize:CGSizeMake(200, 20000) lineBreakMode:NSLineBreakByWordWrapping];
        cell.messageLabel.editable = NO;
        cell.messageContainer.frame=frame;
        [cell.messageContainer setFrame:CGRectMake(70,10,
                                                   sz.width+20,
                                                   sz.height+20)];
        
        cell.messageContainer.backgroundColor=[UIColor colorWithRed:(243/255.0) green:(243/255.0) blue:(243/255.0) alpha:1];
        cell.bubbleTailImage.image= [UIImage imageNamed:@"bubble-tail-grey"];
        
        [cell.bubbleTailImage setFrame:CGRectMake(52,sz.height,
                                                  cell.bubbleTailImage.frame.size.width,
                                                  cell.bubbleTailImage.frame.size.height)];
        [cell.memberProfilePicImage setFrame:CGRectMake(5,(int) sz.height-15,
                                                        55,
                                                        47)];
        
        [cell.timelineTimeLabel setFrame:CGRectMake(sz.width+25+70,sz.height+5,
                                                    cell.timelineTimeLabel.frame.size.width,
                                                    cell.timelineTimeLabel.frame.size.height)];
        
        [formatter setDateFormat:@"HH:mm"];
        cell.timelineTimeLabel.text=[formatter stringFromDate:(NSDate*)messageAtIndex.date];
    }
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(void)goToExpense{
    UIStoryboard *timelineStoryboard=[UIStoryboard storyboardWithName:@"expenseStoryboard" bundle:nil];
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
    
    CGPoint pt = {0,0};
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    //you can change the setAnimationDuration value, it is in seconds.
    
    CGRect rect = CGRectMake(pt.x, pt.y, tbvc.activeTabBarImage.frame.size.width,tbvc.activeTabBarImage.frame.size.height);
    
    [tbvc.activeTabBarImage setFrame:rect];
    [tbvc.listButton setSelected:NO];
    [tbvc.timelineButton setSelected:NO];
    [tbvc.expenseButton setSelected:YES];
    
    [UIView commitAnimations];
}

-(void)goToList{
    UIViewController *dst=[[UIStoryboard storyboardWithName:@"listStoryboard" bundle:nil] instantiateInitialViewController];
    
    TabBarViewController *tbvc= (TabBarViewController *) self.parentViewController;
    
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
    
    CGPoint pt = {214,0};
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    //you can change the setAnimationDuration value, it is in seconds.
    
    CGRect rect = CGRectMake(pt.x, pt.y, tbvc.activeTabBarImage.frame.size.width,tbvc.activeTabBarImage.frame.size.height);
    
    [tbvc.activeTabBarImage setFrame:rect];
    [tbvc.listButton setSelected:YES];
    [tbvc.timelineButton setSelected:NO];
    [tbvc.expenseButton setSelected:NO];
    
    [UIView commitAnimations];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if (textField.text.length>0) {
        
        // creating the corresponding message locally
        Message *message = [[Message alloc] initWithContent:textField.text
                                                     author:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"][@"name"]
                                                       date:[NSDate date]
                                                       type:@"message"];
        
        [self.messageDataController addMessage:message];
        
        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [insertIndexPaths addObject:newPath];
        
        [self.messageOnTimeline beginUpdates];
        [self.messageOnTimeline insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.messageOnTimeline endUpdates];
        [self.messageOnTimeline reloadData];
        
        textField.text = nil;
        [self dismissViewControllerAnimated:YES completion:NULL];
        
        // preparing the request parameters
        NSArray *keys = [NSArray arrayWithObjects:@"currentMemberId", @"currentGroupId", @"messageBody", nil];
        NSArray *objects = [NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"][@"id"], [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupId"], message.content, nil];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
        // going for the parsing
        [[AuthAPIClient sharedClient] getPath:@"api/post/message"
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSError *error = nil;
                                          NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                          NSLog(@"success: %@", response[@"message"]);
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"addMessageSuccess" object:nil];
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"error: %@", error);
                                      }];
        
    }
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: [self.messageOnTimeline numberOfRowsInSection:0]-1 inSection: 0];
    [self.messageOnTimeline scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: NO];
    return NO;
}

#pragma mark - Text View Delegate

- (void) textFieldDidBeginEditing:(UITextField *)myTextField
{
    [self animateTextField:myTextField up:YES];
}

- (void) textFieldDidEndEditing:(UITextField *)myTextField
{
    [self animateTextField:myTextField up:NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int movement = (up ? -215 : 215);
        
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    self.view.superview.superview.frame = CGRectOffset(self.view.superview.superview.frame, 0, movement);
    [UIView commitAnimations];
    

}

@end

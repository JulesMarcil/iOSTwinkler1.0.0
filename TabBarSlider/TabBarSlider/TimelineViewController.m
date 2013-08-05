//
//  TimelineViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "TimelineViewController.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController

@synthesize messageOnTimeline=_messageOnTimeline;

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
    CGRect frame= [self.messageOnTimeline frame];
    [self.messageOnTimeline setFrame:CGRectMake(0,
                                               -20,
                                               frame.size.width,
                                               screenHeight-44)];
    frame= [self.actionBar frame];
    [self.actionBar setFrame:CGRectMake(0,
                                       screenHeight-44,
                                       frame.size.width,
                                       44)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.messageDataController=[[TimelineDataController alloc] init];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.messageDataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"timelineCell";
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    Message *messageAtIndex = [self.messageDataController
                                   objectInListAtIndex:indexPath.row];
    [[cell textLabel] setText:messageAtIndex.content];
    [[cell detailTextLabel] setText:[formatter stringFromDate:(NSDate
                                                               *)messageAtIndex.date]];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

@end

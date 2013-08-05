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
#import "AddItemListViewController.h"

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
                                               screenHeight-208)];
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(dataRetrieved)
     name:@"listsWithJSONFinishedLoading"
     object:nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"listCell";
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    List *listAtIndex = [self.listDataController
                               objectInListAtIndex:indexPath.row];
    [[cell textLabel] setText:listAtIndex.name];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (IBAction)backToList:(UIStoryboardSegue *)segue{
    if ([[segue identifier] isEqualToString:@"goBackToList"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end

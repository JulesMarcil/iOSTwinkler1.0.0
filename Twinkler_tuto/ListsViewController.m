//
//  ListsViewController.m
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 30/07/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import "ListsViewController.h"
#import "ListItemsViewController.h"
#import "ListDataController.h"
#import "List.h"

@interface ListsViewController ()

@end

@implementation ListsViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[ListDataController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(dataRetrieved)
     name:@"expensesWithJSONFinishedLoading"
     object:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dataRetrieved {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"aListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    List *listAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    
    cell.textLabel.text = listAtIndex.name;
    
    // Configure the cell...
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"viewListItems"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        List *listAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
        
        ListItemsViewController *livc = [segue destinationViewController];
        livc.items = listAtIndex.items;
    }
}

@end

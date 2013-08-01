//
//  ListItemsViewController.m
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 01/08/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import "ListItemsViewController.h"
#import "AddItemViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface ListItemsViewController ()

@end

@implementation ListItemsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"aListItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = self.items[indexPath.row][@"name"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        AddItemViewController *addItem = [segue sourceViewController];
        if (addItem.item) {
            
            NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:
                                     addItem.item[@"name"], @"name",
                                     self.list_id, @"list_id",
                                     nil];
            
            NSURL *baseURL = [NSURL URLWithString:@"http://localhost:8888/Twinkler1.2.3/web/app_dev.php/group/app/items"];
            
            //build normal NSMutableURLRequest objects
            //make sure to setHTTPMethod to "POST".
            //from https://github.com/AFNetworking/AFNetworking
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
            [httpClient defaultValueForHeader:@"Accept"];
            
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                    path:@"http://localhost:8888/Twinkler1.2.3/web/app_dev.php/group/app/items" parameters:item];
            
            //Add your request object to an AFHTTPRequestOperation
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                                 initWithRequest:request];
            
            //"Why don't I get JSON / XML / Property List in my HTTP client callbacks?"
            //see: https://github.com/AFNetworking/AFNetworking/wiki/AFNetworking-FAQ
            //mattt's suggestion http://stackoverflow.com/a/9931815/1004227 -
            //-still didn't prevent me from receiving plist data
            //[httpClient registerHTTPOperationClass:
            //         [AFPropertyListParameterEncoding class]];
            
            [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
            
            [operation setCompletionBlockWithSuccess:
             ^(AFHTTPRequestOperation *operation,
               id responseObject) {
                 
                 NSString *response = [operation responseString];
                 NSLog(@"response: [%@]",response);
                 
                 NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.items];
                 [temp addObject:addItem.item];
                 self.items = temp;
                 
                 [[self tableView] reloadData];
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"error: %@", [operation error]);
             }];
            
            //call start on your request operation
            [operation start];
        }
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } }

@end

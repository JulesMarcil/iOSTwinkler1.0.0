//
//  ItemListViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "ItemListViewController.h"
#import "ListDataController.h"
#import "List.h"
#import "AddItemListViewController.h"
#import "AuthAPIClient.h"
#import "AFHTTPRequestOperation.h"

@interface ItemListViewController ()

@end

@implementation ItemListViewController

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
	// Do any additional setup after loading the view.
    CGRect frame= [self.bottomToolbar frame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    [self.bottomToolbar setFrame:CGRectMake(0,
                                       screenHeight-300,
                                       frame.size.width,
                                       500)];
    frame= [self.itemListTableView frame];
    [self.itemListTableView setFrame:CGRectMake(0,
                                          0,
                                          frame.size.width,
                                          screenHeight-200)];
    
    frame= [self.addItemButton frame];
    [self.addItemButton setFrame:CGRectMake(0,
                                          0,
                                          frame.size.width,
                                          frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"itemListCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell ...
    cell.textLabel.text = self.list.items[indexPath.row][@"name"];
   
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



- (IBAction)doneAddItem:(UIStoryboardSegue *)segue {
    {
        if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
            AddItemListViewController *addController = [segue sourceViewController];
            if (addController.item) {
                
                // prepare request parameters
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"hello", @"name",
                                            self.list.identifier, @"list_id",
                                            nil];
                
                NSLog(@"%@", addController.item[@"name"]);
                
                AuthAPIClient *client = [AuthAPIClient sharedClient];
                
                NSMutableURLRequest *request = [client requestWithMethod:@"POST"
                                                                    path:@"group/app/items"
                                                              parameters:parameters];
                
                //Add your request object to an AFHTTPRequestOperation
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                                     initWithRequest:request];
                
                [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
                
                [operation setCompletionBlockWithSuccess:
                 ^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSString *response = [operation responseString];
                     NSLog(@"response: %@",response);
                     [self.itemListTableView reloadData];
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"error: %@", [operation error]);
                 }];
                
                //call start on your request operation
                [operation start];
                
                NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.list.items];
                [temp addObject:addController.item];
                self.list.items = temp;
                
                [self.itemListTableView reloadData];
            }
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

- (IBAction)cancelAddItem:(UIStoryboardSegue *)segue{
    if ([[segue identifier] isEqualToString:@"CancelInput"]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)backToList:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end

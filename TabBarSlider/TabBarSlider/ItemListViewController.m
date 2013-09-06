//
//  ItemListViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "ItemListViewController.h"
#import "ListViewController.h"
#import "ListDataController.h"
#import "List.h"
#import "AuthAPIClient.h"
#import "AFHTTPRequestOperation.h"
#import <QuartzCore/QuartzCore.h>

@interface ItemListViewController ()

@end

@implementation ItemListViewController

@synthesize itemListTableView=_itemListTableView;


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
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    [self.viewContainer setFrame:screenRect];
    [self.backgroundImage setFrame:screenRect];
    
    CGRect frame= [self.itemListTableView frame];
    [self.itemListTableView setFrame:CGRectMake(20,
                                                120,
                                                280,
                                                screenHeight-152)];
    
    self.itemListTableView.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    self.itemListTableView.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.itemListTableView.layer.borderWidth = 1.0f;
    
    frame= [self.textFieldContainer frame];
    [self.textFieldContainer setFrame:CGRectMake(20,
                                                 52,
                                                 280,
                                                 frame.size.height)];
    
    self.textFieldContainer.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    self.textFieldContainer.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.textFieldContainer.layer.borderWidth = 1.0f;
    
    self.listNameLabel.text=self.list.name;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)addItem:(id)sender {
    
    if (self.itemInput.text.length > 0) {
        NSDictionary *item = [[NSDictionary alloc] initWithObjectsAndKeys: @0, @"id", self.itemInput.text , @"name", @"incomplete", @"status", nil];
        
        // prepare request parameters
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:item[@"name"], @"name", self.list.identifier, @"list_id", nil];
        
        NSLog(@"parameters: %@", parameters);
        
        [[AuthAPIClient sharedClient] postPath:@"api/post/item"
                                    parameters:parameters
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           NSLog(@"item added sucessfully");
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"error: %@", [operation error]);
                                       }];
        
        NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.list.items];
        [temp addObject:item];
        self.list.items = temp;
        [self.itemListTableView reloadData];
        self.itemInput.text = nil;
    }
}

- (IBAction)backToLists:(id)sender {
    NSLog(@"back to list in itemlistview");
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end

//
//  InviteViewController.m
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 26/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "InviteViewController.h"
#import "AuthAPIClient.h"
#import "Group.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAdd:(id)sender {
    
    NSMutableArray *addMembers = [[NSMutableArray alloc] init];
    NSMutableArray *addFriends = [[NSMutableArray alloc] init];
    NSMutableArray *removeMembers = [[NSMutableArray alloc] init];
    
    NSLog(@"members = %@", self.group.members);
    
    for (id member in self.group.members) {
        if ([member[@"status"] isEqualToString:@"manualAdd"]) {
            [addMembers addObject:member[@"name"]];
        } else if([member[@"status"] isEqualToString:@"friendAdd"]) {
            [addFriends addObject:member[@"id"]];
        } else if ([member[@"status"] isEqualToString:@"remove"] && [member[@"id"] doubleValue]>0) {
            [removeMembers addObject:member[@"id"]];
        } else {
            NSLog(@"nothing happens to %@ (%@)", member[@"name"], member[@"id"]);
        }
    }
    
    if(addMembers.count == 0) {
        [addMembers addObject:@"-1"];
    }
    
    if(addFriends.count == 0) {
        [addFriends addObject:@"-1"];
    }
    
    NSNumber *identifier;
    if (self.group.identifier) {
        identifier = self.group.identifier;
    } else {
        identifier = @0;
    }
    
    NSArray *keys = @[@"id", @"name", @"currency", @"addMembers", @"addFriends", @"activeMember"];
    NSArray *objects = @[identifier, self.group.name, self.group.currency[@"id"], addMembers, addFriends, self.group.activeMember[@"id"]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects
                                                             forKeys:keys];
    
    [[AuthAPIClient sharedClient] postPath:@"api/post/group"
                               parameters:parameters
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError *error = nil;
                                      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      NSLog(@"%@", response);
                                      
                                      self.group.identifier = response[@"id"];
                                      self.group.name = response[@"name"];
                                      self.group.members = response[@"members"];
                                      self.group.activeMember = response[@"activeMember"];
                                      self.group.currency = response[@"currency"];
                                      
                                      UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                                      UIViewController *dst=[mainStoryboard instantiateInitialViewController];
                                      
                                      [[NSUserDefaults standardUserDefaults] setObject:self.group.identifier forKey:@"currentGroupId"];
                                      [[NSUserDefaults standardUserDefaults] setObject:self.group.name forKey:@"currentGroupName"];
                                      [[NSUserDefaults standardUserDefaults] setObject:self.group.members forKey:@"currentGroupMembers"];
                                      [[NSUserDefaults standardUserDefaults] setObject:self.group.activeMember forKey:@"currentMember"];
                                      [[NSUserDefaults standardUserDefaults] setObject:self.group.currency forKey:@"currentGroupCurrency"];
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"newGroupSelected" object:nil];
                                      [self.navigationController pushViewController:dst animated:YES];
                                      
                                      
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                  }];
}

// Old function from Arnaud, kept in case of need again ...
/*
 - (IBAction)goToTimeline:(id)sender {
 [self presentModalViewController:[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateInitialViewController] animated:YES];
 }
 */
@end

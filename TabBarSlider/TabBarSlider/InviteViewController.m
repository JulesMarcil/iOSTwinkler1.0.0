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
    
    NSNumber *identifier;
    if (self.group.identifier) {
        identifier = self.group.identifier;
    } else {
        identifier = @0;
    }
    
    NSArray *keys = @[@"id", @"name", @"members", @"currency"];
    NSArray *objects = @[identifier, self.group.name, self.group.members, self.group.currency[@"id"]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects
                                                             forKeys:keys];
    
    [[AuthAPIClient sharedClient] postPath:@"api/post/group"
                               parameters:parameters
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError *error = nil;
                                      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      
                                      NSLog(@"postgroup response = %@", response);
                                      
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                  }];
}
@end

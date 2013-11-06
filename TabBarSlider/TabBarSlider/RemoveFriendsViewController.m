//
//  RemoveFriendsViewController.m
//  Twinkler
//
//  Created by Jules Marcilhacy on 22/10/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "RemoveFriendsViewController.h"
#import "removeFriendCell.h"
#import "Group.h"
#import "UIImageView+AFNetworking.h"
#import "AuthAPIClient.h"

@interface RemoveFriendsViewController ()

@end

@implementation RemoveFriendsViewController

@synthesize friendTable=_friendTable;

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
    self.screenName = @"RemoveFriendVC";
	// Do any additional setup after loading the view.
    self.selectedList = [[NSMutableArray alloc] init];
    [self.spinner stopAnimating];
    
    self.group = [[Group alloc] initWithName:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupName"]
                                  identifier:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupId"]
                                     members:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupMembers"]
                                activeMember:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"]
                                    currency:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupCurrency"]];
    [self.friendTable reloadData];
    
    if ([self.friendTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.friendTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    NSLog(@"view did load in remove friends with group of %u members", self.group.members.count);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"RemoveFriendVC";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.group.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"removeFriendCell";
    removeFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = (removeFriendCell*) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    };
    
    // Configure the cell...
    NSDictionary* friend = [self.group.members objectAtIndex:indexPath.row];
    
    NSLog(@"friend   = %@", friend);
    NSLog(@"currency = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupCurrency"]);
    
    cell.friendName.text = friend[@"name"];
    [self getImageForView:cell.profilePic Friend:friend size:45.0];
    
    NSString *currency = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupCurrency"][@"symbol"];
    NSLog(@"currency = %@", currency);
    
    if ([friend[@"balance"] doubleValue] < 0){
        cell.balance.text = [NSString stringWithFormat:@"Owes %@ %g", currency, ([friend[@"balance"] doubleValue]*-1)];
    } else if ([friend[@"balance"] doubleValue] > 0) {
        cell.balance.text = [NSString stringWithFormat:@"Is owed %@ %g", currency, [friend[@"balance"] doubleValue]];
    } else {
        cell.balance.text = @"Has no debt";
    }
    
    if ([self.selectedList containsObject:friend]){
        cell.uncheckImage.hidden = NO;
    } else {
        cell.uncheckImage.hidden =YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary* friend;
    friend = [self.group.members objectAtIndex:indexPath.row];
    
    if ([friend[@"balance"] doubleValue] == 0){
        removeFriendCell *cell = (removeFriendCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if ([self.selectedList containsObject:friend]){
            [self.selectedList removeObject:friend];
            cell.uncheckImage.hidden = YES;
        } else {
            [self.selectedList addObject:friend];
            cell.uncheckImage.hidden = NO;
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ can't leave the group", friend[@"name"]]
                                                            message:[NSString stringWithFormat:@"%@'s has not cleared all the debts", friend[@"name"]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
    }
   
}

- (void)getImageForView:(UIImageView *)view Friend:(NSDictionary*)friend size:(NSInteger) size{
    
    UIImage *placeholderImage = [[UIImage alloc] init];
    placeholderImage = [UIImage imageNamed:@"profile-pic-placeholder.png"];
    
    NSString *path = friend[@"picturePath"];
    NSNumber *facebookId= [[[NSNumberFormatter alloc] init] numberFromString:path];
    
    NSURL *url = nil;
    if (facebookId) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", facebookId]];
    } else if(![path isEqualToString:@"local"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", appBaseURL, path]];
    }
    
    if (url) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
         __unsafe_unretained UIImageView *weakView = view;
        [view setImageWithURLRequest:request
                    placeholderImage:placeholderImage
                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                 weakView.image = image;
                                 [self setRoundedView:weakView picture:weakView.image toDiameter:size];
                             }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                 NSLog(@"Failed with error: %@", error);
                             }];
    } else {
        
        view.image = placeholderImage;
        [self setRoundedView:view picture:view.image toDiameter:size];
        
    }
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneAction:(id)sender {
    
    if(self.selectedList.count > 0){
        
        NSString *message;
        if (self.selectedList.count > 1){
            message = [NSString stringWithFormat:@"Do you confirm %u friends are leaving the group?", self.selectedList.count];
        } else {
            message = [NSString stringWithFormat:@"Do you confirm %u friend is leaving the group?", self.selectedList.count];
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        [alertView show];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        //NO clicked
        NSLog(@"No clicked");
        
    } else if (buttonIndex == 1) {
        
        //show spinner
        self.doneButton.enabled=NO;
        [self.spinner startAnimating];
        
        NSLog(@"list = %@", self.selectedList);
        
        NSMutableArray *friends = [[NSMutableArray alloc] init];
        for (NSDictionary *friend in self.selectedList){
            [friends addObject:friend[@"id"]];
        }
        
        //Define post parameters
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:@[self.group.identifier, friends] forKeys:@[@"group", @"friends"]];
        
        [[AuthAPIClient sharedClient] postPath:@"api/group/remove"
                                    parameters:parameters
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           NSError *error = nil;
                                           NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                           NSLog(@"%@", response);
                                           
                                           Group *group = [[Group alloc] initWithName:response[@"name"]
                                                                           identifier:response[@"id"]
                                                                              members:response[@"members"]
                                                                         activeMember:self.group.activeMember
                                                                             currency:response[@"currency"]];
                                           self.group = group;
                                           [[NSUserDefaults standardUserDefaults] setObject:self.group.members forKey:@"currentGroupMembers"];
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"doneAddMember" object:nil userInfo:nil];
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"error: %@", error);
                                           [self.spinner stopAnimating];
                                           self.doneButton.enabled = YES;
                                           
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Friends not removed"
                                                                                           message:@"Make sure you have a connection"
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"OK"
                                                                                 otherButtonTitles:nil, nil];
                                           [alert show];
                                       }];
    }
}


// ---- Design ---  //

-(void) setRoundedView:(UIImageView *)imageView picture: (UIImage *)picture toDiameter:(float)newSize{
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0f);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:100.0] addClip];
    // Draw your image
    CGRect frame=imageView.bounds;
    frame.size.width=newSize;
    frame.size.height=newSize;
    [picture drawInRect:frame];
    
    // Get the image, here setting the UIImageView image
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
}

@end

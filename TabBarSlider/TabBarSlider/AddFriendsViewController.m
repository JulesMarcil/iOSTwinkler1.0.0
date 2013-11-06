//
//  AddFriendsViewController.m
//  Twinkler
//
//  Created by Jules Marcilhacy on 21/10/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "addFacebookFriendCell.h"
#import "UIImageView+AFNetworking.h"
#import "AuthAPIClient.h"
#import "Group.h"
#import "TellViewController.h"

@interface AddFriendsViewController ()

@end

@implementation AddFriendsViewController

@synthesize friendTableView=_friendTableView;

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
    self.screenName = @"AddFriendVC";
	// Do any additional setup after loading the view.
    
    [self requestFacebookFriends];
    
    self.retryCount = 0;
    
    [self.spinner stopAnimating];
    
    self.isSearching = NO;
    self.list = [[NSArray alloc] init];
    self.filteredList = [[NSMutableArray alloc] init];
    self.selectedList = [[NSMutableArray alloc] init];
    
    self.spinnerView.layer.cornerRadius=5;
    
    self.searchbarContainer.backgroundColor=[UIColor colorWithRed:(254/255.0) green:(106/255.0) blue:(100/255.0) alpha:1];
    self.searchBar.tintColor = [UIColor colorWithRed:(254/255.0) green:(106/255.0) blue:(100/255.0) alpha:1];
    
    if ([self.friendTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.friendTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    for (UIView *subview in self.searchBar.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;
                textField.returnKeyType = UIReturnKeyDefault;
                break;
            }
        }
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"AddFriendVC";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.isSearching && [self.filteredList count]) {
        //If the user is searching, use the list in our filteredList array.
        return [self.filteredList count];
    } else {
        return [self.list count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"friendCell";
    
    addFacebookFriendCell *cell = [_friendTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[addFacebookFriendCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary<FBGraphUser>* friend;
    if (self.isSearching && [self.filteredList count]) {
        friend = [self.filteredList objectAtIndex:indexPath.row];
    } else {
        friend = [self.list objectAtIndex:indexPath.row];
    }
    cell.facebookFriendName.text = friend.name;
    
    [self getImageForView:cell.profilePic Friend:friend size:35.0];
    
    if ([self.selectedList containsObject:friend]){
        cell.checkImage.hidden = NO;
    } else {
        cell.checkImage.hidden =YES;
    }
    
    return cell;
}

- (void)getImageForView:(UIImageView *)view Friend:(NSDictionary<FBGraphUser>*)friend size:(NSInteger) size{
    
    UIImage *placeholderImage = [[UIImage alloc] init];
    placeholderImage = [UIImage imageNamed:@"profile-pic-placeholder.png"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", [friend objectForKey:@"id"]]];
    
    if (url) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [view setImageWithURLRequest:request
                    placeholderImage:placeholderImage
                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                 view.image = image;
                                 [self setRoundedView:view picture:view.image toDiameter:size];
                             }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                 NSLog(@"Failed with error: %@", error);
                             }];
    } else {
        
        view.image = placeholderImage;
        [self setRoundedView:view picture:view.image toDiameter:size];
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary<FBGraphUser>* friend;
    
    if (self.isSearching && [self.filteredList count]) {
        //If the user is searching, use the list in our filteredList array.
        friend = [self.filteredList objectAtIndex:indexPath.row];
    } else {
        friend = [self.list objectAtIndex:indexPath.row];
    };
    
    addFacebookFriendCell *cell = (addFacebookFriendCell *)[tableView cellForRowAtIndexPath:indexPath];

    if ([self.selectedList containsObject:friend]){
        [self.selectedList removeObject:friend];
        cell.checkImage.hidden = YES;
    } else {
        [self.selectedList addObject:friend];
        cell.checkImage.hidden = NO;
    }
}

- (IBAction)dismissModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneAction:(id)sender {
    
    if(self.selectedList.count > 0){
        
        //show spinner
        self.doneButton.hidden=YES;
        [self.spinner startAnimating];
        
        NSLog(@"list = %@", self.selectedList);
        
        NSMutableDictionary *friends = [[NSMutableDictionary alloc] init];
        for (NSDictionary<FBGraphUser> *friend in self.selectedList){
            NSDictionary *f = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [friend objectForKey:@"id"], @"id",
                                    friend.name, @"name",
                                    friend.first_name, @"first_name",
                                    friend.last_name, @"last_name",
                                    friend.username, @"username",
                               nil];
            [friends setObject:f forKey:[friend objectForKey:@"id"]];
        }
        
        //Define post parameters
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:@[self.group.identifier, friends] forKeys:@[@"group", @"friends"]];
        
        [[AuthAPIClient sharedClient] postPath:@"api/group/facebook"
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
                                           [self.spinner stopAnimating];
                                           self.doneButton.hidden = NO;
                                           [self.selectedList removeAllObjects];
                                           self.searchBar.text = @"";
                                           [self.friendTableView reloadData];
                                           [self performSegueWithIdentifier:@"FriendsToTell" sender:self];
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"error: %@", error);
                                           [self.spinner stopAnimating];
                                           self.doneButton.hidden = NO;
                                           
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Friends not added"
                                                                                           message:@"Make sure you have a connection"
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"OK"
                                                                                 otherButtonTitles:nil, nil];
                                           [alert show];
                                       }];
    } else {
        [self performSegueWithIdentifier:@"FriendsToTell" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"FriendsToTell"]){
        TellViewController *tvc = [segue destinationViewController];
        tvc.group = self.group;
    }
}

- (void)filterListForSearchText:(NSString *)searchText
{
    NSLog(@"filterListForSearchText");
    [self.filteredList removeAllObjects]; //clears the array from all the string objects it might contain from the previous searches
    
    for (NSDictionary<FBGraphUser>* friend in self.list) {
        NSRange nameRange = [friend.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (nameRange.location != NSNotFound) {
            [self.filteredList addObject:friend];
        }
    }
    [self.friendTableView reloadData];
}

#pragma mark - UISearchDisplayControllerDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    NSLog(@"searchDisplayControllerWillBeginSearch");
    //When the user taps the search bar, this means that the controller will begin searching.
    self.isSearching = YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    NSLog(@"searchDisplayControllerWillEndSearch");
    //When the user taps the Cancel Button, or anywhere aside from the view.
    self.isSearching = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"shouldReloadTableForSearchString");
    [self filterListForSearchText:searchString]; // The method we made in step 7
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSLog(@"shouldReloadTableForSearchScope");
    [self filterListForSearchText:[self.searchDisplayController.searchBar text]]; // The method we made in step 7
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
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

// --- Facebook handle error --- //

- (void) requestFacebookFriends {
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        if (error){
            [self handleAPICallError:error];
            self.spinnerView.hidden = YES;
            
        } else {
            NSLog(@"%@", result);
            self.list = [result objectForKey:@"data"];
            self.spinnerView.hidden = YES;
            NSLog(@"Found: %i friends", self.list.count);
            [self.friendTableView reloadData];
        }
    }];
}

// Helper method to handle errors during API calls
- (void)handleAPICallError:(NSError *)error
{
    // Some Graph API errors are retriable. For this sample, we will have a simple
    // retry policy of one additional attempt.
    self.retryCount++;
    if (error.fberrorCategory == FBErrorCategoryRetry ||
        error.fberrorCategory == FBErrorCategoryThrottling) {
        // We also retry on a throttling error message. A more sophisticated app
        // should consider a back-off period.
        if (*self.retryCount < 2) {
            NSLog(@"Retrying open graph post");
            // Recovery tactic: Call API again.
            [self requestFacebookFriends];
            return;
        } else {
            NSLog(@"Retry count exceeded.");
        }
    }
    
    NSString *alertTitle, *alertMessage;
    // People can revoke post permissions on your app externally so it
    // can be worthwhile to request for permissions again at the point
    // that they are needed. This sample assumes a simple policy
    // of re-requesting permissions.
    if (error.fberrorCategory == FBErrorCategoryPermissions) {
        NSLog(@"Re-requesting permissions");
        // Recovery tactic: Ask for required permissions.
        alertTitle = @"Error in permissions";
        alertMessage = @"Please log out and log in again";
    }
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it.
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
    } else {
        NSLog(@"Unexpected error posting to open graph: %@", error);
        alertTitle = @"Unknown error";
        alertMessage = @"Unable to post to open graph. Please try again later.";
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end

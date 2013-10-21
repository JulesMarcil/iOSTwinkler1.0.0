//
//  AddFriendsViewController.m
//  Twinkler
//
//  Created by Jules Marcilhacy on 21/10/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "addFacebookFriendCell.h"

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
	// Do any additional setup after loading the view.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.isSearching = NO;
    self.list = [[NSArray alloc] init];
    self.filteredList = [[NSMutableArray alloc] init];
    self.selectedList = [[NSMutableArray alloc] init];
    
    
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        self.list = [result objectForKey:@"data"];
        NSLog(@"Found: %i friends", self.list.count);
        [self.friendTableView reloadData];
        
    }];
    
    
    
    [[self.cancelButton layer] setBorderWidth:1.0f];
    [[self.cancelButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self.doneButton layer] setBorderWidth:1.0f];
    [[self.doneButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.searchbarContainer.backgroundColor=[UIColor colorWithRed:(254/255.0) green:(106/255.0) blue:(100/255.0) alpha:1];
    self.searchBar.tintColor = [UIColor colorWithRed:(254/255.0) green:(106/255.0) blue:(100/255.0) alpha:1];

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
    
    cell.profilePic.image = [UIImage imageNamed:@"profile-pic-placeholder.png"];
    
    [self setRoundedView:cell.profilePic picture:cell.profilePic.image toDiameter:35.0];
    
    return cell;
}



- (IBAction)dismissModal:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];    NSDictionary<FBGraphUser>* friend;
    if (self.isSearching && [self.filteredList count]) {
        //If the user is searching, use the list in our filteredList array.
        friend = [self.filteredList objectAtIndex:indexPath.row];
    } else {
        friend = [self.list objectAtIndex:indexPath.row];
    };
    
    NSLog(friend.name);
     addFacebookFriendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.checkImage.hidden=NO;
    
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

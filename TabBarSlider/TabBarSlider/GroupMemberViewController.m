//
//  GroupMemberViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 22/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "GroupMemberViewController.h"
#import "Group.h"
#import "AddMemberCell.h"
#import "UIImageView+AFNetworking.h"
#import "InviteViewController.h"
#import "AuthAPIClient.h"
#import <QuartzCore/QuartzCore.h>

@interface GroupMemberViewController ()

@end

@implementation GroupMemberViewController

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [[AuthAPIClient sharedClient] getPath:@"api/friends"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError *error = nil;
                                      NSMutableArray *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      NSLog(@"%@", response);
                                      self.friends = response;
                                      [self.memberSuggestionTableView reloadData];
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                  }];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.groupNameTextField.text = self.group.name;
    self.backButton.hidden = self.hideBack;
    
    CGRect frame= [self.memberSuggestionTableView frame];
    [self.memberSuggestionTableView setFrame:CGRectMake(frame.origin.x,
                                                        1000,
                                                        frame.size.width,
                                                        frame.size.height)];
    
    frame= [self.actionBarContainer frame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.actionBarContainer setFrame:CGRectMake(frame.origin.x,
                                                 screenRect.size.height-frame.size.height-40,
                                                 frame.size.width,
                                                 frame.size.height)];
    frame= [self.scrollView frame];
    [self.scrollView setFrame:CGRectMake(0,
                                         0,
                                         frame.size.width,
                                         frame.size.height)];
    
    self.nextButton.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.8];
    self.nextButton.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.nextButton.layer.borderWidth = 1.0f;
    
    self.cancelButton.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.8];
    self.cancelButton.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.cancelButton.layer.borderWidth = 1.0f;
    
    self.memberTableView.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.8];
    self.memberTableView.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.memberTableView.layer.borderWidth = 1.0f;
    
    self.searchTextField.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.8];
    self.searchTextField.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.searchTextField.layer.borderWidth = 1.0f;
    
    self.memberSuggestionTableView.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    self.memberSuggestionTableView.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.memberSuggestionTableView.layer.borderWidth = 1.0f;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 1) {
        return 1;
    } else {
        return 1;
    }
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return self.memberArray.count;
    } else {
        return self.friends.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        
        static NSString *CellIdentifier = @"memberCell";
        
        AddMemberCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        
        if (!cell) {
            cell = (AddMemberCell*) [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                           reuseIdentifier:  CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *memberAtIndex = [self.memberArray objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = memberAtIndex[@"name"];
        
        if ([memberAtIndex[@"balance"] doubleValue] != 0) {
            cell.memberButton.alpha = 0.2;
        } else {
            cell.memberButton.alpha = 1;
        }
        
        NSString *path = memberAtIndex[@"picturePath"];
        NSNumber *facebookId= [[[NSNumberFormatter alloc] init] numberFromString:path];
        
        NSURL *url;
        if (facebookId) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", facebookId]];
        } else if(![path isEqualToString:@"local"]) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", appBaseURL, path]];
        }
        
        if(url) {
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            [cell.memberProfilePic setImageWithURLRequest:request
                                         placeholderImage:[UIImage imageNamed:@"profile-pic.png"]
                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                      cell.memberProfilePic.image = image;
                                                      [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:25.0];
                                                  }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                      NSLog(@"Failed with error: %@", error);
                                                  }];
        }
        
        [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:25.0];
        
        return cell;
        
    } else {
        
        static NSString *CellIdentifier = @"memberSuggestionCell";
        
        AddMemberCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        
        if (!cell) {
            cell = (AddMemberCell*) [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                           reuseIdentifier:  CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *memberAtIndex = [self.friends objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = memberAtIndex[@"name"];
        
        NSString *path = memberAtIndex[@"picturePath"];
        NSNumber *facebookId= [[[NSNumberFormatter alloc] init] numberFromString:path];
        
        NSURL *url;
        if (facebookId) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", facebookId]];
        } else if(![path isEqualToString:@"local"]) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", appBaseURL, path]];
        }
        
        if(url) {
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            [cell.memberProfilePic setImageWithURLRequest:request
                                         placeholderImage:[UIImage imageNamed:@"profile-pic.png"]
                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                      cell.memberProfilePic.image = image;
                                                      [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:25.0];
                                                  }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                      NSLog(@"Failed with error: %@", error);
                                                  }];
        }
        
        [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:25.0];
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"did select row at index path");
    
    if (tableView.tag == 2) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        NSDictionary *friend = [self.friends objectAtIndex:indexPath.row];
        
        NSLog(@"selected friend = %@", friend);
        
        NSArray *objects = @[friend[@"id"], friend[@"name"], friend[@"picturePath"], @"0", @"friendAdd"];
        NSArray *keys = @[@"id", @"name", @"picturePath", @"balance", @"status"];
        NSDictionary *member = [[NSDictionary alloc] initWithObjects:objects
                                                             forKeys:keys];
        
        [self.memberArray addObject:member];
        [self.memberTableView reloadData];
    }
    self.memberNameTextField.text = @"";
    [self dismissKeyboard:nil];
}

- (IBAction)manualAddMember:(id)sender {
    
    if (self.memberNameTextField.text.length >0) {
        NSArray *objects = @[@0, self.memberNameTextField.text, @"local", @"0", @"manualAdd"];
        NSArray *keys = @[@"id", @"name", @"picturePath", @"balance", @"status"];
        NSDictionary *member = [[NSDictionary alloc] initWithObjects:objects
                                                             forKeys:keys];
        
        [self.memberArray addObject:member];
        [self.memberTableView reloadData];
        self.memberNameTextField.text = @"";
    }
    [self dismissKeyboard:nil];
}

- (void)removeMember:(id)sender :(NSIndexPath *)indexPath{
    
    NSDictionary *memberAtIndex = [self.memberArray objectAtIndex:indexPath.row];
    
    if ([memberAtIndex[@"balance"] doubleValue] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"impossible"
                                                        message:@"you cannot remove a member with a non null balance"
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [self.memberArray removeObject:memberAtIndex];
        [self.memberTableView reloadData];
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.memberNameTextField resignFirstResponder];
    [UIView beginAnimations:@"MoveOut" context:nil];
    CGRect frame= [self.memberSuggestionTableView frame];
    [self.memberSuggestionTableView setFrame:CGRectMake(frame.origin.x,
                                                        1000,
                                                        frame.size.width,
                                                        frame.size.height)];
    [UIView commitAnimations];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) animateTextField: (UITextField*) textField up:(BOOL)up {
    int movement = (up ? -60 : 60);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:@"MoveIn" context:nil];
    CGRect frame= [self.memberSuggestionTableView frame];
    [self.memberSuggestionTableView setFrame:CGRectMake(frame.origin.x,
                                                        109,
                                                        frame.size.width,
                                                        frame.size.height)];
    [self animateTextField:textField up:YES];
    [UIView commitAnimations];
    
}

-(void)textresign {
    [[self.view viewWithTag:1]resignFirstResponder];
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:@"MoveOut" context:nil];
    CGRect frame= [self.memberSuggestionTableView frame];
    [self.memberSuggestionTableView setFrame:CGRectMake(frame.origin.x,
                                                        1000,
                                                        frame.size.width,
                                                        frame.size.height)];
    [self animateTextField:textField up:NO];
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)doneButton:(id)sender {
    
    self.group.members = self.memberArray;
    
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

                                       self.link = response[@"link"];
                                       
                                       [[NSUserDefaults standardUserDefaults] setObject:self.group.identifier forKey:@"currentGroupId"];
                                       [[NSUserDefaults standardUserDefaults] setObject:self.group.name forKey:@"currentGroupName"];
                                       [[NSUserDefaults standardUserDefaults] setObject:self.group.members forKey:@"currentGroupMembers"];
                                       [[NSUserDefaults standardUserDefaults] setObject:self.group.activeMember forKey:@"currentMember"];
                                       [[NSUserDefaults standardUserDefaults] setObject:self.group.currency forKey:@"currentGroupCurrency"];
                                       
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"newGroupSelected" object:nil];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"doneAddMember" object:nil];
                                       
                                       [self performSegueWithIdentifier: @"MembersToInvite" sender: self];
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"error: %@", error);
                                   }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"MembersToInvite"]) {
        InviteViewController *ivc = [segue destinationViewController];
        ivc.group = self.group;
        ivc.link = self.link;
    }
}

// Design function !!!

-(void) setRoundedView:(UIImageView *)imageView picture: (UIImage *)picture toDiameter:(float)newSize{
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    
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

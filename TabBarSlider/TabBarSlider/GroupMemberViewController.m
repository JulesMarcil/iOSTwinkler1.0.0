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

@interface GroupMemberViewController ()

@end

@implementation GroupMemberViewController

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
    CGRect frame= [self.memberSuggestionTableView frame];
    [self.memberSuggestionTableView setFrame:CGRectMake(frame.origin.x,
                                                    1000,
                                                    frame.size.width,
                                                    frame.size.height)];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1) {
        return 1;
    }else{
        return 1;
    }
        
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return self.memberArray.count;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
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
            cell.memberButton.hidden = YES;
        } else {
            cell.memberButton.hidden = NO;
        }
        
        NSString *path = memberAtIndex[@"picturePath"];
        NSNumber *facebookId= [[[NSNumberFormatter alloc] init] numberFromString:path];
        
        NSURL *url;
        if (facebookId) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", facebookId]];
        } else if(![path isEqualToString:@"local"]) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8888/Twinkler1.2.3/web/%@", path]];
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                      reuseIdentifier: CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text=@"amigos";
        return cell;
        
    }
}

// Old function from Arnaud, kept in case of need again ...
/*
- (IBAction)goToTimeline:(id)sender {
    [self presentModalViewController:[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateInitialViewController] animated:YES];
}
*/

- (IBAction)manualAddMember:(id)sender {
    
    if (self.memberNameTextField.text.length >0) {
        NSArray *objects = @[@0, self.memberNameTextField.text, @"local", @"0"];
        NSArray *keys = @[@"id", @"name", @"picturePath", @"balance"];
        NSDictionary *member = [[NSDictionary alloc] initWithObjects:objects
                                                         forKeys:keys];
        
        [self.memberArray addObject:member];
        [self.memberTableView reloadData];
        self.memberNameTextField.text = @"";
    }
    [self dismissKeyboard:nil];
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


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:@"MoveIn" context:nil];
    CGRect frame= [self.memberSuggestionTableView frame];
    [self.memberSuggestionTableView setFrame:CGRectMake(frame.origin.x,
                                                        40,
                                                        frame.size.width,
                                                        frame.size.height)];
    [UIView commitAnimations];
    
}
-(void)textresign{
    
    [[self.view viewWithTag:1]resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:@"MoveOut" context:nil];
    CGRect frame= [self.memberSuggestionTableView frame];
    [self.memberSuggestionTableView setFrame:CGRectMake(frame.origin.x,
                                                        1000,
                                                        frame.size.width,
                                                        frame.size.height)];
    [UIView commitAnimations];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"MembersToInvite"]) {
        
        self.group.members = self.memberArray;
        InviteViewController *ivc = [segue destinationViewController];
        ivc.group = self.group;
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

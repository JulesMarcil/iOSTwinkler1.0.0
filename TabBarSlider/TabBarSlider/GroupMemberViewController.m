//
//  GroupMemberViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 22/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "GroupMemberViewController.h"
#import "Group.h"

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
    
    NSLog(@"group = %@", self.group.name);
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
        return self.group.members.count;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (tableView.tag == 1) {
        
        static NSString *CellIdentifier = @"memberCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                          reuseIdentifier:  CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text=[self.group.members objectAtIndex:indexPath.row][@"name"];
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
- (IBAction)goToTimeline:(id)sender {
    [self presentModalViewController:[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateInitialViewController] animated:YES];
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
@end

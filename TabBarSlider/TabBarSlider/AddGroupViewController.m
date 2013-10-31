//
//  AddGroupViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "AddGroupViewController.h"
#import "AddFriendsViewController.h"
#import "ConnectViewController.h"
#import "Group.h"
#import <QuartzCore/QuartzCore.h>
#import "AuthAPIClient.h"

@interface AddGroupViewController ()

@end

@implementation AddGroupViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewdidload in add group with group name = %@", self.group.name);
    
    if (self.group){
        NSLog(@"self.group detected in add group");
        [self nextAction];
    }
    
    [self.spinner stopAnimating];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    NSDictionary *Euro = [[NSDictionary alloc] initWithObjectsAndKeys:@"Euro", @"name", @"€", @"symbol", @1, @"id", nil];
    NSDictionary *USDollar = [[NSDictionary alloc] initWithObjectsAndKeys:@"US Dollar", @"name", @"$", @"symbol", @2, @"id", nil];
    NSDictionary *BritishPound = [[NSDictionary alloc] initWithObjectsAndKeys:@"BritishPound", @"name", @"£", @"symbol", @3, @"id", nil];
    NSDictionary *IndianRupee = [[NSDictionary alloc] initWithObjectsAndKeys:@"Indian Rupee", @"name", @"Rs", @"symbol", @4, @"id", nil];
    NSDictionary *AustralianDollar = [[NSDictionary alloc] initWithObjectsAndKeys:@"Australian Dollar", @"name", @"AU$", @"symbol", @5, @"id", nil];
    NSDictionary *CanadianDollar = [[NSDictionary alloc] initWithObjectsAndKeys:@"Canadian Dollar", @"name", @"CA$", @"symbol", @6, @"id", nil];
    NSDictionary *SwissFranc = [[NSDictionary alloc] initWithObjectsAndKeys:@"Swiss Franc", @"name", @"CHF", @"symbol", @7, @"id", nil];
    NSDictionary *ChineseYuanRenminbi = [[NSDictionary alloc] initWithObjectsAndKeys:@"Chinese Yuan Renminbi", @"name", @"CN¥", @"symbol", @8, @"id", nil];
    NSDictionary *JapaneseYen = [[NSDictionary alloc] initWithObjectsAndKeys:@"Japanese Yen", @"name", @"¥", @"symbol", @9, @"id", nil];
    NSDictionary *ColombianPeso = [[NSDictionary alloc] initWithObjectsAndKeys:@"Colombian Peso", @"name", @"$", @"symbol", @10, @"id", nil];
    NSDictionary *BrazilianReal = [[NSDictionary alloc] initWithObjectsAndKeys:@"Brazilian Real", @"name", @"R$", @"symbol", @11, @"id", nil];
    
    currencies = [[NSArray alloc] initWithObjects:Euro,USDollar,BritishPound,IndianRupee,AustralianDollar,CanadianDollar,SwissFranc,ChineseYuanRenminbi,JapaneseYen,ColombianPeso,BrazilianReal, nil];
    
    self.selectedCurrency = Euro;
    self.currentCurrency.text = @"Euro";
    
    
    
    //-----DESIGN------//
    
    self.view.backgroundColor=[UIColor colorWithRed:(247/255.0) green:(245/255.0) blue:(245/255.0) alpha: 1];
    self.toolbar.backgroundColor=[UIColor colorWithRed:(254/255.0) green:(106/255.0) blue:(100/255.0) alpha:1];
    
    UIColor *textColor = [UIColor whiteColor] ;
    
    [self.nextButton setTitleColor: textColor forState: UIControlStateNormal];
    //[self.nextButton.layer  setBorderColor:[UIColor colorWithRed:(136/255.0) green:(202/255.0) blue:(0/255.0) alpha:1].CGColor];
    //[self.nextButton.layer  setBorderWidth:1.0];
    self.nextButton.layer.cornerRadius = 5;
    
    [self.cancelButton setTitleColor: textColor forState: UIControlStateNormal];
    //[self.cancelButton.layer  setBorderColor:borderColor.CGColor];
    //[self.cancelButton.layer  setBorderWidth:1.0];
    self.cancelButton.layer.cornerRadius = 5;
    
    self.groupNameContainer.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    self.groupNameContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    self.groupNameContainer.layer.borderWidth = 1.0f;
    self.groupNameContainer.layer.cornerRadius = 5;
    self.groupNameContainer.layer.masksToBounds = YES;
    
    CGRect frame= [self.actionBarContainer frame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.actionBarContainer setFrame:CGRectMake(frame.origin.x,
                                                 screenRect.size.height-frame.size.height-40,
                                                 frame.size.width,
                                                 frame.size.height)];
    
    self.errorView.backgroundColor=[UIColor colorWithRed:(243/255.0) green:(221/255.0) blue:(221/255.0) alpha:1];
    self.errorView.layer.borderColor = [UIColor colorWithRed:(237/255.0) green:(211/255.0) blue:(215/255.0) alpha:1].CGColor;
    self.errorView.layer.borderWidth = 1.0f;
    self.errorView.layer.cornerRadius = 5;
    self.errorView.layer.masksToBounds = YES;
    
    UIColor *borderColor = [UIColor colorWithRed:(200/255.0) green:(200/255.0) blue:(200/255.0) alpha:1] ;
    self.currencyContainer.layer.cornerRadius = 5;
    [self.currencyContainer.layer  setBorderColor:borderColor.CGColor];
    [self.currencyContainer.layer  setBorderWidth:1.0];
    
    [self.groupName becomeFirstResponder];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"AddGroupVC";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----Currency Picker--------//
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return currencies.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [currencies objectAtIndex:row][@"name"];
}

-(void)closePicker:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.currencyPicker.frame = CGRectMake(0,
                                               560, //Displays the view off the screen
                                               self.currencyPicker.frame.size.width,
                                               self.currencyPicker.frame.size.height);
    }];
}


- (void)dismissCurrencyPicker{
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.currencyPicker.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
    [self closePicker:nil];
    
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}



- (IBAction)showPicker:(id)sender {
    if ([self.view viewWithTag:9]) {
        return;
    }
    
    [self.groupName resignFirstResponder];
    
    
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-216)];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCurrencyPicker)] ;
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    [self.view insertSubview:darkView belowSubview:self.currencyContainer];
    
    [self.view addSubview:self.currencyPicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)] ;
    toolBar.tag = 11;
    toolBar.tintColor= [UIColor blackColor];
    toolBar.translucent=YES;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(nextButton:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    self.currencyPicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
    
    //Set selected owner to the first one in the list (to be updated with current member)
    self.selectedCurrency = [currencies objectAtIndex:0];
    self.currentCurrency.text=self.selectedCurrency[@"name"];
    [self.currencyPicker reloadAllComponents];
    [self.currencyPicker selectRow:0 inComponent:0 animated:YES];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedCurrency = [currencies objectAtIndex:row];
    self.currentCurrency.text=self.selectedCurrency[@"name"];
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)dismissKeyboard{
    [self.groupName resignFirstResponder];
}

- (IBAction)nextButton:(id)sender {
    
    if ([self.groupName.text length]) {
        //show spinner
        self.nextButton.hidden=YES;
        self.cancelButton.hidden=YES;
        [self.spinner startAnimating];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.groupName.text, @"name",
                                    self.selectedCurrency[@"id"], @"currency",
                                    nil];
        
        [[AuthAPIClient sharedClient] postPath:@"api/post/group"
                                    parameters:parameters
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           NSError *error = nil;
                                           NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                           NSLog(@"%@", response);
                                           
                                           Group *group = [[Group alloc] initWithName:response[@"name"]
                                                                           identifier:response[@"id"]
                                                                              members:response[@"members"]
                                                                         activeMember:response[@"activeMember"]
                                                                             currency:response[@"currency"]];
                                           self.group = group;
                                           
                                           [[NSUserDefaults standardUserDefaults] setObject:self.group.activeMember             forKey:@"currentMember"];
                                           [[NSUserDefaults standardUserDefaults] setObject:self.group.identifier               forKey:@"currentGroupId"];
                                           [[NSUserDefaults standardUserDefaults] setObject:self.group.name                     forKey:@"currentGroupName"];
                                           [[NSUserDefaults standardUserDefaults] setObject:self.group.members                  forKey:@"currentGroupMembers"];
                                           [[NSUserDefaults standardUserDefaults] setObject:self.group.currency                 forKey:@"currentGroupCurrency"];
                                           
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"doneAddMember" object:nil userInfo:nil];
                                           [self nextAction];
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"error: %@", error);
                                           [self.spinner stopAnimating];
                                           self.nextButton.hidden=NO;
                                           self.cancelButton.hidden=NO;
                                           
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Group not added"
                                                                                           message:@"Make sure you have a connection"
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"OK"
                                                                                 otherButtonTitles:nil, nil];
                                           [alert show];
                                       }];
    }else{
        [self dismissCurrencyPicker];
        [self.groupName becomeFirstResponder];
        self.errorView.hidden=NO;
        self.errorLabel.hidden=NO;
        self.addGroupImage.hidden=YES;
        self.addGroupLabel.hidden=YES;
    }
}

- (void) nextAction{
    if (FBSession.activeSession.isOpen == YES){
        [self performSegueWithIdentifier:@"GroupToFriends" sender:self];
    } else {
        [self performSegueWithIdentifier:@"GroupToConnect" sender:self];
    }
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"GroupToFriends"]) {
        
        AddFriendsViewController *afvc = [segue destinationViewController];
        afvc.group = self.group;
        
    } else if ([[segue identifier] isEqualToString:@"GroupToConnect"]) {
        
        ConnectViewController *cvc = [segue destinationViewController];
        cvc.group = self.group;
        
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    if (!textField.inputAccessoryView) {
        textField.inputAccessoryView = [self keyboardToolBar];
    }
}

- (void) selectCurrency:(id)sender{
    
    if ([self.groupName.text length]) {
    [self.groupName resignFirstResponder];
    [self showPicker:sender];
    }else{
        [self.groupName becomeFirstResponder];
        self.errorView.hidden=NO;
        self.errorLabel.hidden=NO;
        self.addGroupImage.hidden=YES;
        self.addGroupLabel.hidden=YES;
        
    }
}

- (UIToolbar *)keyboardToolBar {
    UIToolbar *toolbar=[[UIToolbar alloc]init];
    
    toolbar.translucent=NO;
    [toolbar sizeToFit];
    toolbar.tag=1;
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(selectCurrency:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:spacer,spacer,doneButton, nil]];
    
    return toolbar;
}


@end

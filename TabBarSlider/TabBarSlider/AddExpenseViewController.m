//
//  AddExpenseViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AddExpenseViewController.h"
#import "Expense.h"
#import "FUIButton.h"
#import "UIImage+FlatUI.h"

@interface AddExpenseViewController ()

@end

@implementation AddExpenseViewController

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
    [self.view endEditing:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.expenseName.enablesReturnKeyAutomatically = NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyy"];
    self.dateLabel.text=[dateFormatter stringFromDate:[NSDate date]];
    [self closePicker:nil];
    
    memberArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupMembers"];
    self.selectedExpenseOwner = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"];
    self.expenseOwner.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"][@"name"];
    
    self.cancelExpenseButton.buttonColor = [UIColor colorWithRed:(236/255.0) green:(240/255.0) blue:(241/255.0) alpha:1] ;
    self.cancelExpenseButton.shadowColor = [UIColor colorWithRed:(185/255.0) green:(195/255.0) blue:(199/255.0) alpha:1] ;
    self.cancelExpenseButton.shadowHeight = 3.0f;
    self.cancelExpenseButton.cornerRadius = 6.0f;
    [self.cancelExpenseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelExpenseButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    self.addExpenseButton.buttonColor = [UIColor colorWithRed:(242/255.0) green:(118/255.0) blue:(105/255.0) alpha:1] ;
    self.addExpenseButton.shadowColor = [UIColor colorWithRed:(219/255.0) green:(106/255.0) blue:(93/255.0) alpha:1] ;
    self.addExpenseButton.shadowHeight = 3.0f;
    self.addExpenseButton.cornerRadius = 6.0f;
    [self.addExpenseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addExpenseButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    self.expenseNameContainer.layer.cornerRadius = 6;
    self.expenseNameContainer.layer.masksToBounds = YES;
    self.expenseNameContainer.layer.borderColor = [UIColor colorWithRed:(235/255.0) green:(235/255.0) blue:(235/255.0) alpha:1].CGColor  ;
    self.expenseNameContainer.layer.borderWidth = 2.0f;
    
    self.expenseAmountContainer.layer.cornerRadius = 6;
    self.expenseAmountContainer.layer.masksToBounds = YES;
    self.expenseAmountContainer.layer.borderColor = [UIColor colorWithRed:(235/255.0) green:(235/255.0) blue:(235/255.0) alpha:1].CGColor  ;
    self.expenseAmountContainer.layer.borderWidth = 2.0f;
    
    self.amountLabelContainer.layer.cornerRadius = 6;
    self.amountLabelContainer.layer.masksToBounds = YES;
    self.amountLabelContainer.layer.borderColor = [UIColor colorWithRed:(235/255.0) green:(235/255.0) blue:(235/255.0) alpha:1].CGColor  ;
    self.amountLabelContainer.layer.borderWidth = 2.0f;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.expenseName resignFirstResponder];
    [self.expenseAmount resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)changeDate:(UIDatePicker *)sender {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyy"];
    NSString *strDate = [dateFormatter stringFromDate:sender.date];
    
    self.dateLabel.text=strDate;
    
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}

- (IBAction)callDP:(id)sender {
    if ([self.view viewWithTag:9]) {
        return;
    }
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)] ;
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)] ;
    datePicker.tag = 10;
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)] ;
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return memberArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [memberArray objectAtIndex:row][@"name"];
}

-(IBAction)closePicker:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.expenseMemberPicker.frame = CGRectMake(self.expenseMemberPicker.frame.origin.x,
                                                    460, //Displays the view off the screen
                                                    self.expenseMemberPicker.frame.size.width,
                                                    self.expenseMemberPicker.frame.size.height);
    }];
}


- (void)dismissMemberPicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.expenseMemberPicker.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
    [self closePicker:nil];
}



- (IBAction)showPicker:(id)sender {
    if ([self.view viewWithTag:9]) {
        return;
    }
    
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)] ;
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    [self.view addSubview:self.expenseMemberPicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)] ;
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissMemberPicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    self.expenseMemberPicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
    
    //Set selected owner to the first one in the list (to be updated with current member)
    self.selectedExpenseOwner = [memberArray objectAtIndex:0];
    [self.expenseMemberPicker reloadAllComponents];
    [self.expenseMemberPicker selectRow:0 inComponent:0 animated:YES];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectedExpenseOwner = [memberArray objectAtIndex:row];
    
    self.expenseOwner.text= [memberArray objectAtIndex:row][@"name"];
    NSLog(@"%@", self.selectedExpenseOwner);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        if ([self.expenseName.text length] || [self.expenseAmount.text length]) {
            
            //NSString to NSNumber formatter
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *formattedAmount = [f numberFromString:self.expenseAmount.text];
            
            //Get date of today
            NSDate *today = [NSDate date];
            
            //Create Member Array (to be completed)
            NSArray *members = [[NSArray alloc] init];
            
            Expense *expense = [[Expense alloc] initWithName:self.expenseName.text
                                                      amount:formattedAmount
                                                       owner:self.selectedExpenseOwner
                                                        date:today
                                                     members:members
                                                      author:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"][@"name"]
                                                   addedDate:today];
            self.expense = expense;
            NSLog(@"%@", self.selectedExpenseOwner);
        }
    }
}



@end

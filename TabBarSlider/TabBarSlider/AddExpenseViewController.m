//
//  AddExpenseViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <math.h>
#import "AddExpenseViewController.h"
#import "Expense.h"
#import "memberCollectionViewCell.h"

@interface AddExpenseViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation AddExpenseViewController

@synthesize collectionView=_collectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view endEditing:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    CGRect frame= [self.collectionView frame];
    


    self.expenseName.enablesReturnKeyAutomatically = NO;
    

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyy"];
    self.dateLabel.text=[dateFormatter stringFromDate:[NSDate date]];
    [self closePicker:nil];
    
    memberArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupMembers"];
    self.selectedExpenseOwner = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"];
    self.expenseOwner.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"][@"name"];
    
    
    [self.collectionView setFrame:CGRectMake(0,
                                             240,
                                             frame.size.width,
                                             fmax(120,(((int)([memberArray count]/4)) +1)* 90))];
    
    frame= [self.bottomButtonContainer frame];
    [self.bottomButtonContainer setFrame:CGRectMake(frame.origin.x,
                                                    frame.origin.y+fmax(0,((int)([memberArray count]/4)-1)*80),
                                                    frame.size.width,
                                                    frame.size.height)];
    
    frame= [self.selectionButtonContainer frame];
    [self.selectionButtonContainer setFrame:CGRectMake(frame.origin.x,
                                                    frame.origin.y+fmax(0,((int)([memberArray count]/4)-1)*80),
                                                    frame.size.width,
                                                    frame.size.height)];
    
    self.scrollView.frame=CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height);
    self.scrollView.scrollEnabled = YES;
    frame= [self.bottomButtonContainer frame];
    self.scrollView.contentSize =CGSizeMake(320, frame.origin.y+55) ;
    
    
    self.expenseNameContainer.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.8];
    self.expenseNameContainer.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor  ;
    self.expenseNameContainer.layer.borderWidth = 1.0f;
    
    self.expenseAmountContainer.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1];
    self.expenseAmountContainer.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor  ;
    self.expenseAmountContainer.layer.borderWidth = 1.0f;
    
    self.amountLabelContainer.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.8];
    self.amountLabelContainer.layer.borderColor =  [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor  ;
    self.amountLabelContainer.layer.borderWidth = 1.0f;
    
    
    UIColor *borderColor = [UIColor colorWithRed:(200/255.0) green:(200/255.0) blue:(200/255.0) alpha:1] ;    
    UIColor *textColor = [UIColor colorWithRed:(65/255.0) green:(65/255.0) blue:(65/255.0) alpha:1] ;
    
    [self.addExpenseButton setTitleColor: textColor forState: UIControlStateNormal];
    [self.addExpenseButton.layer  setBorderColor:borderColor.CGColor];
    [self.addExpenseButton.layer  setBorderWidth:1.0];
    
    [self.cancelExpenseButton setTitleColor: textColor forState: UIControlStateNormal];
    [self.cancelExpenseButton.layer  setBorderColor:borderColor.CGColor];
    [self.cancelExpenseButton.layer  setBorderWidth:1.0];
    
    self.collectionView.backgroundColor =[UIColor clearColor];

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
                                                    500, //Displays the view off the screen
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

- (IBAction)selectAll:(id)sender {
    [self.deselectAllButton setSelected:NO];
    [self.selectAllButton setSelected:YES];
    
    for(memberCollectionViewCell* cell in self.collectionView){
        
        cell.memberProfilePic.alpha=0.5;
    }
}

- (IBAction)deselectAll:(id)sender {
    [self.deselectAllButton setSelected:YES];
    [self.selectAllButton setSelected:NO];
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectedExpenseOwner = [memberArray objectAtIndex:row];
    
    self.expenseOwner.text= [memberArray objectAtIndex:row][@"name"];
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
        }
    }
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [memberArray count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    memberCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"memberCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *checkedMember=[[UIImageView alloc] initWithFrame:CGRectMake(45, 0, 16, 12)];
    checkedMember.image=[UIImage imageNamed: @"green-check"];
    checkedMember.tag=indexPath.row+1;
    [cell addSubview:checkedMember];
    cell.memberProfilePic.alpha=1;
    cell.isSelected=YES;
    [self.deselectAllButton setSelected:NO];
    [self.selectAllButton setSelected:YES];

    cell.memberNameLabel.text=[memberArray objectAtIndex:indexPath.row][@"name"];

    cell.memberNameLabel.backgroundColor=[UIColor clearColor];
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    memberCollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.isSelected){
        [[self.view viewWithTag:indexPath.row+1] removeFromSuperview];
        cell.memberProfilePic.alpha=0.5;
        cell.isSelected=NO;
        [self.selectAllButton setSelected:NO];

    }else{
        UIImageView *checkedMember=[[UIImageView alloc] initWithFrame:CGRectMake(45, 0, 16, 12)];
        checkedMember.image=[UIImage imageNamed: @"green-check"];
        checkedMember.tag=indexPath.row+1;
        [cell addSubview:checkedMember];
        cell.memberProfilePic.alpha=1;
        cell.isSelected=YES;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(80, 60);
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end

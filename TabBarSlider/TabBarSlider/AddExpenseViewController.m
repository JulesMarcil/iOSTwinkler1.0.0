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
#import "UIImageView+AFNetworking.h"
#import "AuthAPIClient.h"
#import "ExpenseViewController.h"

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
    
    
    CGRect frame= [self.view frame];
    CGFloat screenHeight= [[UIScreen mainScreen] bounds].size.height;
    [self.view setFrame:CGRectMake(frame.origin.x,
                                                    0,
                                                    frame.size.width,
                                                    screenHeight)];
    
    
    frame= [self.scrollView frame];
    [self.scrollView setFrame:CGRectMake(frame.origin.x,
                                                  20,
                                                  frame.size.width,
                                                  frame.size.height)];
    
    
    
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
    
    switch ([memberArray count]) {
        case 1:
            frame= [self.collectionView frame];
            [self.collectionView setFrame:CGRectMake(120,
                                                     frame.origin.y,
                                                     frame.size.width,
                                                     frame.size.height)];
            break;
        case 2:
            frame= [self.collectionView frame];
            [self.collectionView setFrame:CGRectMake(80,
                                                     frame.origin.y,
                                                     frame.size.width,
                                                     frame.size.height)];
            break;
        case 3:
            frame= [self.collectionView frame];
            [self.collectionView setFrame:CGRectMake(40,
                                                     frame.origin.y,
                                                     frame.size.width,
                                                     frame.size.height)];
            break;
            
        default:
            frame= [self.collectionView frame];
            [self.collectionView setFrame:CGRectMake(frame.origin.x,
                                                     frame.origin.y,
                                                     frame.size.width,
                                                     frame.size.height)];
            break;
    }
    
    frame= [self.bottomButtonContainer frame];
    [self.bottomButtonContainer setFrame:CGRectMake(frame.origin.x,
                                                    fmax(screenHeight-frame.size.height-40,frame.origin.y+fmax(0,((int)([memberArray count]/4)-1)*80)),
                                                    frame.size.width,
                                                    frame.size.height)];
    
    frame= [self.selectionButtonContainer frame];
    [self.selectionButtonContainer setFrame:CGRectMake(frame.origin.x,
                                                       fmax(screenHeight-frame.size.height-self.bottomButtonContainer.frame.size.height-40,frame.origin.y+fmax(0,((int)([memberArray count]/4)-1)*80)),
                                                       frame.size.width,
                                                       frame.size.height)];
    
    frame= [self.expenseMemberPicker frame];
    [self.expenseMemberPicker setFrame:CGRectMake(frame.origin.x,
                                                       600,
                                                       frame.size.width,
                                                       frame.size.height)];
    
    self.scrollView.scrollEnabled = YES;
    frame= [self.bottomButtonContainer frame];
    self.scrollView.contentSize =CGSizeMake(320, frame.origin.y+55) ;
    
    self.expenseNameContainer.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.8];
    self.expenseNameContainer.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
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
    
    self.expenseAmount.keyboardType=UIKeyboardTypeDecimalPad;
    self.expenseAmount.inputAccessoryView=[self toolBarForKeyboardAccessory];
    
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
    datePicker.backgroundColor=[UIColor whiteColor];
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)] ;
    toolBar.tag = 11;
    toolBar.tintColor= [UIColor blackColor];
    toolBar.translucent=YES;
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

-(void)closePicker:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.expenseMemberPicker.frame = CGRectMake(self.expenseMemberPicker.frame.origin.x,
                                                    700, //Displays the view off the screen
                                                    self.expenseMemberPicker.frame.size.width,
                                                    self.expenseMemberPicker.frame.size.height);
    }];
}

- (void)dismissMemberPicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    self.expenseMemberPicker.frame=datePickerTargetFrame;
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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMemberPicker:)] ;
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    [self.view addSubview:self.expenseMemberPicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)] ;
    toolBar.tag = 11;
    toolBar.tintColor= [UIColor blackColor];
    toolBar.translucent=YES;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissMemberPicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    self.expenseMemberPicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
    
    self.expenseMemberPicker.backgroundColor=[UIColor whiteColor];
    
    //Set selected owner to the first one in the list (to be updated with current member)
    self.selectedExpenseOwner = [memberArray objectAtIndex:0];
    [self.expenseMemberPicker reloadAllComponents];
    [self.expenseMemberPicker selectRow:0 inComponent:0 animated:YES];
}


-(UIToolbar *)toolBarForKeyboardAccessory
{
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    keyboardToolbar.tintColor= [UIColor blackColor];
    keyboardToolbar.translucent=YES;
    
    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
    
    [keyboardToolbar setItems:[NSArray arrayWithObjects: flexSpace, flexSpace, flexSpace, flexSpace, flexSpace, cancelButton, nil] animated:NO];
    
    return keyboardToolbar;
    
}

- (void) doneButtonClicked: (id) sender{
    
    [self textFieldShouldReturn:self.expenseAmount];
}

- (IBAction)selectAll:(id)sender {
    
    for(memberCollectionViewCell* cell in [self.collectionView visibleCells]){
        [UIView beginAnimations:@"fade in" context:nil];
        [UIView setAnimationDuration:0.2];
        cell.checkIcon.alpha=1;
        cell.memberProfilePic.alpha=1;
        [UIView commitAnimations];
    }
}

- (IBAction)addExpense:(id)sender {
    
    if ([self.expenseName.text length] && [self.expenseAmount.text length] && ([self.expenseAmount.text intValue]>0)) {
        
        //show spinner
        self.addExpenseButton.hidden=YES;
        self.cancelExpenseButton.hidden=YES;
        [self.spinnner startAnimating];
        
        //Get date of today
        NSDate *today = [NSDate date];
        
        //Create Member Array (to be completed)
        NSMutableArray *selectedMembers = [[NSMutableArray alloc] init];
        
        //get selected members
        for(memberCollectionViewCell* cell in [self.collectionView visibleCells]){
            
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            if (cell.isSelected) {
                NSDictionary *member = [memberArray objectAtIndex:indexPath.row];
                [selectedMembers addObject:member];
            }
        }
        
        //calculate share (to be done with nspredicate - waiting for it to be displayed) /Jules
        NSNumber *share = @-1;
        
        Expense *expense = [[Expense alloc] initWithIdentifier:@-1
                                                          name:self.expenseName.text
                                                        amount:[NSNumber numberWithInteger: [self.expenseAmount.text integerValue]]
                                                         owner:self.selectedExpenseOwner
                                                          date:today
                                                       members:selectedMembers
                                                        author:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"][@"name"]
                                                     addedDate:today
                                                         share:share
                            ];
        
        self.expense = expense;
        
        //create selected member ids array
        NSMutableArray *selectedIds = [[NSMutableArray alloc] init];
        for(NSDictionary *member in self.expense.members){
            [selectedIds addObject:member[@"id"]];
        }
        
        
        // initialize the request parameters
        NSString *currentGroupId = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentGroupId"];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.expense.name, @"name",
                                    self.expense.amount, @"amount",
                                    currentGroupId, @"currentGroupId",
                                    self.selectedExpenseOwner[@"id"], @"owner_id",
                                    selectedIds, @"member_ids",
                                    [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"][@"id"], @"author_id",
                                    nil];
        
        [[AuthAPIClient sharedClient] postPath:@"api/post/expense"
                                    parameters:parameters
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           NSError *error = nil;
                                           NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                           NSLog(@"%@", response);
                                           
                                           NSDictionary *expense_response = response[@"expense"];
                                           
                                           NSTimeInterval interval1 = [expense_response[@"date"] doubleValue];
                                           NSTimeInterval interval2 = [expense_response[@"addedDate"] doubleValue];
                                           
                                           Expense *expense = [[Expense alloc] initWithIdentifier:expense_response[@"id"]
                                                                                             name:expense_response[@"name"]
                                                                                           amount:[NSNumber numberWithInteger: [expense_response[@"amount"] integerValue]]
                                                                                            owner:expense_response[@"owner"]
                                                                                             date:[NSDate dateWithTimeIntervalSince1970:interval1]
                                                                                          members:expense_response[@"members"]
                                                                                           author:expense_response[@"author"]
                                                                                        addedDate:[NSDate dateWithTimeIntervalSince1970:interval2]
                                                                                            share:expense_response[@"share"]
                                                               ];
                                           
                                           self.expense = expense;
                                           
                                           NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
                                           [format setNumberStyle:NSNumberFormatterDecimalStyle];
                                           [format setRoundingMode:NSNumberFormatterRoundHalfUp];
                                           [format setMaximumFractionDigits:2];
                                           NSNumber *balance = [NSNumber numberWithFloat:[response[@"balance"] floatValue]];
                                           
                                           NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:@[expense, balance] forKeys:@[@"expense", @"balance"]];
                                           
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"expenseAddedSuccesfully" object:nil userInfo:dictionary];
                                           NSLog(@"expense added notification");
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"error: %@", error);
                                           [self.spinnner stopAnimating];
                                           self.addExpenseButton.hidden=NO;
                                           self.cancelExpenseButton.hidden=NO;
                                           
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Expense not added"
                                                                                           message:@"Make sure data is enabled on your iPhone"
                                                                                          delegate:self
                                                                                 cancelButtonTitle:@"OK"
                                                                                 otherButtonTitles:nil, nil];
                                           [alert show];                                           
                                       }];
    } else if (![self.expenseName.text length]) {
        
        UIColor *color = [UIColor redColor];
        self.expenseName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"What has been paid?" attributes:@{NSForegroundColorAttributeName: color}];
        
    } else if (![self.expenseAmount.text length]) {
        
        UIColor *color = [UIColor redColor];
        self.expenseAmount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"0.00" attributes:@{NSForegroundColorAttributeName: color}];
        
    } else if ([self.expenseAmount.text intValue] == 0) {
        UIColor *color = [UIColor redColor];
        self.expenseAmount.text = @"";
        self.expenseAmount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"0.00" attributes:@{NSForegroundColorAttributeName: color}];
    }
}

- (IBAction)deselectAll:(id)sender {
    for(memberCollectionViewCell* cell in [self.collectionView visibleCells]){
        [UIView beginAnimations:@"fade in" context:nil];
        [UIView setAnimationDuration:0.2];
        cell.checkIcon.alpha=0;
        cell.memberProfilePic.alpha=0.5;
        cell.isSelected=NO;
        [UIView commitAnimations];
    }
}

- (IBAction)cancelAddExpense:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectedExpenseOwner = [memberArray objectAtIndex:row];
    
    self.expenseOwner.text= [memberArray objectAtIndex:row][@"name"];
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
    [cell.memberProfilePic setFrame:CGRectMake(22,0,35,35)];
    [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:35.0];
    cell.checkIcon.alpha=1;
    cell.memberProfilePic.alpha=1;
    cell.isSelected=YES;
    
    NSDictionary *member = [memberArray objectAtIndex:indexPath.row];
    
    NSString *path = member[@"picturePath"];
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
                                                  [cell.memberProfilePic setFrame:CGRectMake(22,0,35,35)];
                                                  [self setRoundedView:cell.memberProfilePic picture:cell.memberProfilePic.image toDiameter:35.0];
                                                  
                                              }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  NSLog(@"Failed with error: %@", error);
                                              }];
    }
    
    cell.memberProfilePic.alpha=1;
    cell.isSelected=YES;
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
    memberCollectionViewCell *cell= (memberCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.checkIcon.alpha==1){
        [UIView beginAnimations:@"fade in" context:nil];
        [UIView setAnimationDuration:0.2];
        cell.checkIcon.alpha=0;
        cell.memberProfilePic.alpha=0.5;
        [UIView commitAnimations];
        
        cell.isSelected=NO;
        
    }else{
        [UIView beginAnimations:@"fade in" context:nil];
        [UIView setAnimationDuration:0.2];
        cell.checkIcon.alpha=1;
        cell.memberProfilePic.alpha=1;
        [UIView commitAnimations];
        
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

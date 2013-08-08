//
//  AddExpenseViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FUIButton;
@class Expense;

@interface AddExpenseViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>{
    NSArray *memberArray; }

@property (weak, nonatomic) IBOutlet UIPickerView *expenseMemberPicker;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *expenseNameContainer;
@property (weak, nonatomic) IBOutlet UIView *expenseAmountContainer;
@property (weak, nonatomic) IBOutlet UIView *amountLabelContainer;
@property (weak, nonatomic) IBOutlet UITextField *expenseName;
@property (weak, nonatomic) IBOutlet UITextField *expenseAmount;
@property (weak, nonatomic) NSDictionary *selectedExpenseOwner;
@property (weak, nonatomic) IBOutlet UILabel *expenseOwner;
@property (strong, nonatomic) Expense *expense;
@property (weak, nonatomic) IBOutlet FUIButton *addExpenseButton;
@property (weak, nonatomic) IBOutlet FUIButton *cancelExpenseButton;

- (IBAction)showPicker:(id)sender;

@end

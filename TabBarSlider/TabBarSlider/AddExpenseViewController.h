//
//  AddExpenseViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Expense;

@interface AddExpenseViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    NSArray *memberArray; }

@property (weak, nonatomic) IBOutlet UIPickerView *expenseMemberPicker;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *expenseName;
@property (weak, nonatomic) IBOutlet UITextField *expenseAmount;
@property (weak, nonatomic) NSDictionary *selectedExpenseOwner;
@property (strong, nonatomic) Expense *expense;

- (IBAction)showPicker:(id)sender;

@end

//
//  AddExpenseViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddExpenseViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
 NSArray *arrStatus; }

@property (weak, nonatomic) IBOutlet UIPickerView *expenseMemberPicker;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *expenseName;
@property (weak, nonatomic) IBOutlet UITextField *expenseAmount;



- (IBAction)showPicker:(id)sender;

@end

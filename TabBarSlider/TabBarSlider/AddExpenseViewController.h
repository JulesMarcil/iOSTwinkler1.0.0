//
//  AddExpenseViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Expense;

@interface AddExpenseViewController : GAITrackedViewController <UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>{
    NSArray *memberArray;}

@property (strong, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIView *bottomButtonContainer;
@property (weak, nonatomic) IBOutlet UIView *selectionButtonContainer;
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
@property (weak, nonatomic) IBOutlet UIButton *addExpenseButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelExpenseButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UIButton *deselectAllButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinnner;


@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;

- (IBAction)showPicker:(id)sender;
- (IBAction)selectAll:(id)sender;
- (IBAction)deselectAll:(id)sender;
- (IBAction)addExpense:(id)sender;
- (IBAction)cancelAddExpense:(id)sender;

@end

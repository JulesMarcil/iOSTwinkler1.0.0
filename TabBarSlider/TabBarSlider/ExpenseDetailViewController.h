//
//  ExpenseDetailViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/09/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Expense;

@interface ExpenseDetailViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDataSource, UIScrollViewDelegate>{
	IBOutlet UIScrollView *scrollView;
}

@property (weak, nonatomic) IBOutlet UIView *actionBarView;
@property (weak, nonatomic) IBOutlet UILabel *expenseNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ownerPic;
@property (weak, nonatomic) IBOutlet UILabel *expenseOwnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *getLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseMembersLabel;
@property (weak, nonatomic) IBOutlet UITableView *memberTableView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *expenseAuthorLabel;
@property (strong, nonatomic) Expense *expense;
@property (weak, nonatomic) UIImage * presentationImage;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)editExpense:(id)sender;
- (IBAction)deleteExpense:(id)sender;
- (IBAction)dismissDetail:(id)sender;

@end

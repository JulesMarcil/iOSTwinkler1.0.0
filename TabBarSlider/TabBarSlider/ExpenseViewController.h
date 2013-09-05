//
//  ExpenseViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseDataController.h"
#import "AddExpenseViewController.h"
#import "DRNRealTimeBlurView.h"

@interface ExpenseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView* expenseListTable;
}

@property (nonatomic, strong) UITableView *expenseListTable;
@property (nonatomic, strong) ExpenseDataController *expenseDataController;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet DRNRealTimeBlurView *blurView;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIImageView *ownerPic;
@property (weak, nonatomic) IBOutlet UILabel *expenseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UITableView *involvedMemberTableView;

- (IBAction)addExpenseButton:(id)sender;
- (IBAction)doneAddMember:(UIStoryboardSegue *)segue;
- (IBAction)cancelAddMember:(UIStoryboardSegue *)segue;


@end

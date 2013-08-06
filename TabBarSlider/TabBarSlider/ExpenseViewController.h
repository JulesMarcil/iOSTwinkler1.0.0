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

@interface ExpenseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>  {
    IBOutlet UITableView* expenseListTable;
}

@property (nonatomic, strong) UITableView *expenseListTable;
@property (nonatomic, strong) ExpenseDataController *expenseDataController;
@property (weak, nonatomic) IBOutlet UIView *addItemToolbar;

- (IBAction)addExpenseButton:(id)sender;
- (IBAction)doneAddMember:(UIStoryboardSegue *)segue;
- (IBAction)cancelAddMember:(UIStoryboardSegue *)segue;


@end
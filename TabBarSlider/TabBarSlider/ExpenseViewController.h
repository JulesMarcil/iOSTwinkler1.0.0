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

@interface ExpenseViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView* expenseListTable;
}

@property (nonatomic, strong) UITableView *expenseListTable;
@property (nonatomic, strong) ExpenseDataController *expenseDataController;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIView *headerViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *timelineImage;
@property (weak, nonatomic) IBOutlet UIView *addExpenseView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshSpinner;
@property (weak, nonatomic) IBOutlet UIView *spinnerView;
@property (weak, nonatomic) IBOutlet UIView *addExpenseBck;
@property (weak, nonatomic) IBOutlet UIView *balanceContainer;

- (IBAction)addExpenseButton:(id)sender;

@end

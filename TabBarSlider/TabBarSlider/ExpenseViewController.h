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

@interface ExpenseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    IBOutlet UITableView* expenseListTable;
}

@property (nonatomic, strong) UITableView *expenseListTable;
@property (nonatomic, strong) ExpenseDataController *expenseDataController;
@property (weak, nonatomic) IBOutlet UIView *addItemToolbar;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *memberCollectionView;

- (IBAction)addExpenseButton:(id)sender;
- (IBAction)doneAddMember:(UIStoryboardSegue *)segue;
- (IBAction)cancelAddMember:(UIStoryboardSegue *)segue;


@end

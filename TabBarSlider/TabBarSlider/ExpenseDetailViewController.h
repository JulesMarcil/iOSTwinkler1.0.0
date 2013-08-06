//
//  ExpenseDetailViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 06/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>  {
    IBOutlet UITableView* expenseDetailMemberTable;
}

@property (weak, nonatomic) IBOutlet UITableView *expenseDetailMemberTable;
@property (weak, nonatomic) IBOutlet UILabel *expenseName;
@property (weak, nonatomic) IBOutlet UILabel *expenseAmount;
@property (weak, nonatomic) IBOutlet UILabel *expenseDate;
@property (weak, nonatomic) IBOutlet UILabel *expenseOwner;
@property (weak, nonatomic) IBOutlet UILabel *expenseAuthor;

@end

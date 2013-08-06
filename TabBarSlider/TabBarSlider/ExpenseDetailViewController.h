//
//  ExpenseDetailViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 06/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>  {
    IBOutlet UITableView* expenseDetailTable;
}

@property (weak, nonatomic) IBOutlet UITableView *expenseDetailTable;

@end

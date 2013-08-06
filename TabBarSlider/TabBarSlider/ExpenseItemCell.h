//
//  ExpenseItemCell.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 06/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *expenseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseAmountLabel;

@end

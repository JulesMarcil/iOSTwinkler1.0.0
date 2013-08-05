//
//  ExpenseDataController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Expense;

@interface ExpenseDataController : NSObject

@property (nonatomic, copy) NSMutableArray *expenseList;

- (NSUInteger)countOfList;
- (Expense *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addExpenseWithExpense:(Expense *)expense;

@end

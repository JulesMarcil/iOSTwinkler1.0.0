//
//  ExpenseDataController.h
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 30/07/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Expense;

@interface ExpenseDataController : NSObject

@property (nonatomic, copy) NSMutableArray *expenseList;

- (NSUInteger)countOfList;
- (Expense *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addExpenseWithExpense:(Expense *)expense;

@end

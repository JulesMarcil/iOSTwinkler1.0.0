//
//  ExpenseDataController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "ExpenseDataController.h"


#import "ExpenseDataController.h"
#import "Expense.h"

@interface ExpenseDataController ()

- (void)initializeDefaultDataList;

@end

@implementation ExpenseDataController

- (void)initializeDefaultDataList {
    NSMutableArray *ExpenseList = [[NSMutableArray alloc] init];
    self.ExpenseList = ExpenseList;
    Expense *expense;
    NSDate *today = [NSDate date];
    expense = [[Expense alloc] initWithName:@"Bouteille au Stirwen" amount:[NSNumber numberWithInt:1000] date:today];

    
    [self addExpenseWithExpense:expense];
}

- (void)setExpenseList:(NSMutableArray *)newList {
    if (_expenseList != newList) {
        _expenseList = [newList mutableCopy];
    }
}

- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList {
    return [self.expenseList count];
}

- (Expense *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.expenseList objectAtIndex:theIndex];
}

- (void)addExpenseWithExpense:(Expense *)expense {
    [self.expenseList addObject:expense];
}

@end

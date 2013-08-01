//
//  ExpenseDataController.m
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 30/07/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import "ExpenseDataController.h"
#import "Expense.h"
#import "AFJSONRequestOperation.h"

@interface ExpenseDataController ()

- (void)initializeDefaultDataList;

@end

@implementation ExpenseDataController

- (void)initializeDefaultDataList {
    NSMutableArray *localExpenseList = [[NSMutableArray alloc] init];
    self.expenseList = localExpenseList;

    NSURL *expensesURL = [NSURL URLWithString:@"http://localhost:8888/Twinkler1.2.3/web/app_dev.php/group/json/expenses"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:expensesURL];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *dataArray = JSON;
        //NSString to NSNumber formatter
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        for(id key in dataArray) {
            
            NSNumber *formattedAmount = [f numberFromString:key[@"amount"]];
            NSTimeInterval interval1 = [key[@"date"] doubleValue];
            NSTimeInterval interval2 = [key[@"addedDate"] doubleValue];
            
            Expense *expense = [[Expense alloc] initWithName:key[@"name"]
                                                      amount:formattedAmount
                                                       owner:key[@"owner"]
                                                        date:[NSDate dateWithTimeIntervalSince1970:interval1]
                                                     members:key[@"members"]
                                                      author:key[@"author"]
                                                   addedDate:[NSDate dateWithTimeIntervalSince1970:interval2]];
            
            [self addExpenseWithExpense:expense];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"expensesWithJSONFinishedLoading" object:nil];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"NSError: %@",error.localizedDescription);
    }];
    [operation start];
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

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
#import "AuthAPIClient.h"

@interface ExpenseDataController ()

- (void)initializeDefaultDataList;

@end

@implementation ExpenseDataController

- (void)initializeDefaultDataList {
    NSMutableArray *ExpenseList = [[NSMutableArray alloc] init];
    self.ExpenseList = ExpenseList;
    
    NSMutableArray *expenseList = [[NSMutableArray alloc] init];
    self.expenseList = expenseList;
    
    //Set parameters for request
    NSDictionary *currentMember = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"];
    NSLog(@"current member id = %@", currentMember[@"id"]);
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:currentMember[@"id"], @"currentMemberId", nil];
    
    [[AuthAPIClient sharedClient] getPath:@"api/expenses"
                               parameters:parameters
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError *error = nil;
                                      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      NSLog(@"success: %@", response);
                                      
                                      //NSString to NSNumber formatter
                                      NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                                      [f setNumberStyle:NSNumberFormatterDecimalStyle];
                                      
                                      self.balance = response[@"balance"];
                                      NSLog(@"balance from dc = %@", self.balance);
                                      
                                      for(id key in response[@"expenses"]) {
                                          
                                          NSNumber *formattedAmount = [f numberFromString:key[@"amount"]];
                                          NSTimeInterval interval1 = [key[@"date"] doubleValue];
                                          NSTimeInterval interval2 = [key[@"addedDate"] doubleValue];
                                          
                                          Expense *expense = [[Expense alloc] initWithName:key[@"name"]
                                                                                    amount:formattedAmount
                                                                                     owner:key[@"owner"]
                                                                                      date:[NSDate dateWithTimeIntervalSince1970:interval1]
                                                                                   members:key[@"members"]
                                                                                    author:key[@"author"]
                                                                                 addedDate:[NSDate dateWithTimeIntervalSince1970:interval2]
                                                                                     share:key[@"share"]
                                                              ];
                                          
                                          [self addExpenseWithExpense:expense];
                                      }
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"expensesWithJSONFinishedLoading" object:nil];
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                  }];
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

- (void) addExpenseWithExpense:(Expense *)expense atIndex:(NSUInteger)index {
    [self.expenseList insertObject:expense atIndex:index];
}

@end

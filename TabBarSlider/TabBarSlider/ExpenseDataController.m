//
//  ExpenseDataController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "ExpenseDataController.h"
#import "Expense.h"
#import "AuthAPIClient.h"
#import "AFHTTPRequestOperation.h"

@interface ExpenseDataController ()

- (void)initializeDefaultDataList;

@end

@implementation ExpenseDataController

- (void)initializeDefaultDataList {
    
    NSMutableArray *ExpenseList = [[NSMutableArray alloc] init];
    self.ExpenseList = ExpenseList;
    
    //Set parameters for request
    CredentialStore *store = [[CredentialStore alloc] init];
    NSString *authToken = [store authToken];
    NSDictionary *currentMember = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/expenses?access_token=%@&currentMemberId=%@", appURL, authToken, currentMember[@"id"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cachedResponse != nil && [[cachedResponse data] length] > 0) {
        
        NSLog(@"cached data for expenses");
        // Get cached data
        NSError* error;
        NSDictionary* response = [NSJSONSerialization JSONObjectWithData:cachedResponse.data options:kNilOptions error:&error];
        
        self.balance = response[@"balance"];
        for(id key in response[@"expenses"]) {
            
            NSTimeInterval interval1 = [key[@"date"] doubleValue];
            NSTimeInterval interval2 = [key[@"addedDate"] doubleValue];
            
            Expense *expense = [[Expense alloc] initWithIdentifier:key[@"id"]
                                                              name:key[@"name"]
                                                            amount:[NSNumber numberWithDouble: [key[@"amount"] doubleValue]]
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
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        [self.expenseList removeAllObjects];
        self.balance = response[@"balance"];
        
        for(id key in response[@"expenses"]) {
            
            NSTimeInterval interval1 = [key[@"date"] doubleValue];
            NSTimeInterval interval2 = [key[@"addedDate"] doubleValue];
            
            Expense *expense = [[Expense alloc] initWithIdentifier:key[@"id"]
                                                              name:key[@"name"]
                                                            amount:[NSNumber numberWithDouble: [key[@"amount"] doubleValue]]
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
        NSLog(@"expensesWithJSONFinishedLoading");
    }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"expensesWithJSONFailedLoading" object:nil];
                                          NSLog(@"expensesWithJSONFailedLoading");
                                          NSLog(@"error: %@",  operation.responseString);
                                          
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

- (void)addExpenseWithExpense:(Expense *)expense atIndex:(NSUInteger)index {
    [self.expenseList insertObject:expense atIndex:index];
}

- (void)removeExpenseWithExpense:(Expense *)expense {
    [self.expenseList removeObject:expense];
}

-(void)refreshData{
    
    NSDictionary *currentMember = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentMember"];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:currentMember[@"id"], @"currentMemberId", nil];
    
    [[AuthAPIClient sharedClient] getPath:@"api/expenses"
                               parameters:parameters
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      NSError *error = nil;
                                      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      
                                      [self.expenseList removeAllObjects];
                                      self.balance = response[@"balance"];
                                      
                                      for(id key in response[@"expenses"]) {
                                          
                                          NSTimeInterval interval1 = [key[@"date"] doubleValue];
                                          NSTimeInterval interval2 = [key[@"addedDate"] doubleValue];
                                          
                                          Expense *expense = [[Expense alloc] initWithIdentifier:key[@"id"]
                                                                                            name:key[@"name"]
                                                                                          amount:[NSNumber numberWithDouble: [key[@"amount"] doubleValue]]
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
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"expensesWithJSONFailedRefreshing" object:nil];
                                      NSLog(@"expensesWithJSONFailedRefreshing");
                                      NSLog(@"error: %@", error);
                                  }];
}

@end

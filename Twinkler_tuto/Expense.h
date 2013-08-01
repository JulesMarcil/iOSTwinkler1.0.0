//
//  Expense.h
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 30/07/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expense : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSDictionary *owner;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSDate *addedDate;

- (id)initWithName:(NSString *)name
            amount:(NSNumber *)amount
             owner:(NSDictionary *)owner
              date:(NSDate *)date
           members:(NSArray *)members
            author:(NSString *)author
         addedDate:(NSDate *)addedDate;

@end

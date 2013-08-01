//
//  Expense.m
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 30/07/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import "Expense.h"

@implementation Expense

- (id)initWithName:(NSString *)name amount:(NSNumber *)amount owner:(NSDictionary *)owner date:(NSDate *)date members:(NSArray *)members author:(NSString *)author addedDate:(NSDate *)addedDate
{
    self = [super init];
    if (self) {
        _name = name;
        _amount = amount;
        _owner = owner;
        _date = date;
        _members = members;
        _author = author;
        _addedDate = addedDate;
        return self;
    }
    return nil;
}

@end

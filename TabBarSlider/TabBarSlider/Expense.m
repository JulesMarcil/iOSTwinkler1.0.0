//
//  Expense.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "Expense.h"

@implementation Expense


-(id)initWithIdentifier:(NSNumber *)identifier name:(NSString *)name amount:(NSNumber *)amount owner:(NSDictionary *)owner date:(NSDate *)date members:(NSArray *)members author:(NSString *)author addedDate:(NSDate *)addedDate share:(NSNumber *)share {
    self=[super init];
    if(self){
        _identifier=identifier;
        _name = name;
        _amount = amount;
        _owner = owner;
        _date = date;
        _members = members;
        _author = author;
        _addedDate = addedDate;
        _share=share;
        return self;
    }
    return nil;
}

@end

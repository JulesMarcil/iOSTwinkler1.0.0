//
//  Expense.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "Expense.h"

@implementation Expense


-(id)initWithName:(NSString *)name amount:(NSNumber*)amount date:(NSDate *)date{
    self=[super init];
    if(self){
        _name = name;
        _amount= amount;
        _date= date;
        return self;
    }
    return nil;
}

@end

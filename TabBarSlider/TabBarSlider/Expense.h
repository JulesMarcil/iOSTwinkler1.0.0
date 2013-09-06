//
//  Expense.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expense : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSDictionary *owner;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSDate *addedDate;
@property (nonatomic, strong) NSNumber *share;

- (id)initWithIdentifier:(NSNumber *)identifier
                    name:(NSString *)name
                  amount:(NSNumber *)amount
                   owner:(NSDictionary *)owner
                    date:(NSDate *)date
                 members:(NSArray *)members
                  author:(NSString *)author
               addedDate:(NSDate *)addedDate
                   share:(NSNumber *)share;
@end
